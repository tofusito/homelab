import sys
import urllib.request
import urllib.parse
import time
import ssl

if __name__ == "__main__":
    print(f"Received args: {sys.argv[1]}")
    port = sys.argv[1].split(",")[0]

    print(f"Waiting to trigger port change to {port}...")
    time.sleep(7)

    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    body = {
        "json": f'{{"listen_port": "{port}"}}'
    }
    encoded_data = urllib.parse.urlencode(body).encode('utf-8')

    # Create the request
    req = urllib.request.Request(
        url="http://localhost:8888/api/v2/app/setPreferences",
        data=encoded_data,
        method="POST"
    )

    try_n = 1
    max = 10

    while try_n < max:
        print(f"Executing try {try_n} out of {max} to update the port...")
        try:
            response = urllib.request.urlopen(req, context=ctx)
            status = response.getcode()
            print(f"POST Response code: {status}")
            if status == 200:
                break

        except urllib.error.URLError as e:
            print(f"POST Request failed: {e.reason}")
            try_n += 1
            print("sleep for 10 seconds")
            time.sleep(10)  

    print("port forward updater script completed")
