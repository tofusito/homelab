import * as api from '@actual-app/api';
import { mkdirSync } from 'fs';
import { createServer } from 'http';

const PORT = 3456;
const API_TOKEN = process.env.API_TOKEN;
const ACTUAL_SERVER_URL = process.env.ACTUAL_SERVER_URL || 'http://actual_server:5006';
const ACTUAL_PASSWORD = process.env.ACTUAL_PASSWORD;
const ACTUAL_SYNC_ID = process.env.ACTUAL_SYNC_ID;

if (!API_TOKEN || !ACTUAL_PASSWORD || !ACTUAL_SYNC_ID) {
  console.error('FATAL: Missing required env vars: API_TOKEN, ACTUAL_PASSWORD, ACTUAL_SYNC_ID');
  process.exit(1);
}

const DATA_DIR = '/tmp/actual-cache';
mkdirSync(DATA_DIR, { recursive: true });

let ready = false;

async function connect() {
  await api.init({ dataDir: DATA_DIR, serverURL: ACTUAL_SERVER_URL, password: ACTUAL_PASSWORD });
  const budgets = await api.getBudgets();
  const match = budgets.find(b => b.groupId === ACTUAL_SYNC_ID || b.cloudFileId === ACTUAL_SYNC_ID);
  if (!match) {
    const available = budgets.map(b => `  - ${b.name} (groupId: ${b.groupId})`).join('\n');
    console.error(`FATAL: ACTUAL_SYNC_ID "${ACTUAL_SYNC_ID}" not found.\nAvailable budgets:\n${available || '  (none)'}`);
    process.exit(1);
  }
  await api.downloadBudget(ACTUAL_SYNC_ID);
  ready = true;
  console.log(`Connected to budget: ${match.name}`);
}

connect().catch(e => { console.error('FATAL:', e.message); process.exit(1); });

// Re-sync si el presupuesto se desincroniza (modificaciones desde la UI)
async function syncAndRetry(fn) {
  try {
    await api.sync();
    return await fn();
  } catch (e) {
    if (e.reason === 'out-of-sync') {
      console.log('Out of sync, re-downloading budget...');
      await api.downloadBudget(ACTUAL_SYNC_ID);
      return await fn();
    }
    throw e;
  }
}

function json(res, status, data) {
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(data));
}

function checkAuth(req) {
  return req.headers['authorization'] === `Bearer ${API_TOKEN}`;
}

function readBody(req) {
  return new Promise((resolve, reject) => {
    let data = '';
    req.on('data', chunk => data += chunk);
    req.on('end', () => { try { resolve(JSON.parse(data || '{}')); } catch(e) { reject(e); } });
  });
}

const server = createServer(async (req, res) => {
  const url = new URL(req.url, 'http://localhost');
  try {
    if (req.method === 'GET' && url.pathname === '/health') {
      return json(res, 200, { status: ready ? 'ok' : 'initializing' });
    }

    if (!checkAuth(req)) return json(res, 401, { error: 'Unauthorized' });
    if (!ready) return json(res, 503, { error: 'Not ready yet' });

    if (req.method === "GET" && url.pathname === "/accounts") {
      const accounts = await syncAndRetry(() => api.getAccounts());
      return json(res, 200, accounts.map(a => ({ id: a.id, name: a.name, type: a.type, closed: a.closed })));
    }

    if (req.method === 'POST' && url.pathname === '/transaction') {
      const body = await readBody(req);
      console.log('Incoming transaction:', JSON.stringify(body));

      const { account_id, amount, payee, notes, date, category_id } = body;
      if (!account_id || amount === undefined || !payee) {
        return json(res, 400, { error: 'Required: account_id, amount, payee' });
      }

      const txDate = date ? date.slice(0, 10) : new Date().toISOString().slice(0, 10);
      const amountInt = Math.round(parseFloat(String(amount).replace(',', '.')) * 100);

      console.log(`Adding: date=${txDate} amount=${amountInt} payee=${payee} category=${category_id}`);

      const ids = await syncAndRetry(() => api.addTransactions(account_id, [{
        date: txDate,
        amount: amountInt,
        payee_name: payee,
        notes: notes || '',
        category: category_id || undefined,
        cleared: true,
      }]));

      return json(res, 200, { ok: true, id: ids[0] });
    }

    json(res, 404, { error: 'Not found' });
  } catch (e) {
    console.error('Error:', e.message);
    json(res, 500, { error: e.message });
  }
});

server.listen(PORT, () => console.log(`actual-api listening on :${PORT}`));
