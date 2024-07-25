import requests
import json

ip_addressess = ["24.48.0.1", "172.217.255.255", "203.0.113.0", "8.8.8.8", "172.217.0.0"]

for ip in ip_addressess:
    response = requests.get(f"http://ip-api.com/json/{ip}").json()

    if response['status'] == 'success':
        country = response['country']
        zipcode = response['zip']
        isp = response['isp']
        city = response['city']

    else:
        print(response['status'])

    print(f"The country of the the IP {ip} is {country} and the city is {city}; the ISP is {isp}")
