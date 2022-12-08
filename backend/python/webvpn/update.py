import requests

from webvpn.jwgl import jwbl
headers = {
    'authority': 'webvpn.nepu.edu.cn',
    'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'accept-language': 'zh-CN,zh;q=0.9',
    'cache-control': 'max-age=0',
    'dnt': '1',
    'referer': 'https://webvpn.nepu.edu.cn/users/sign_in',
    'sec-ch-ua': '"Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'sec-fetch-dest': 'document',
    'sec-fetch-mode': 'navigate',
    'sec-fetch-site': 'same-origin',
    'sec-fetch-user': '?1',
    'upgrade-insecure-requests': '1',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
}

def update(request,cookies):
    response = requests.get('https://webvpn.nepu.edu.cn/vpn_key/update', cookies=cookies, headers=headers,allow_redirects=False)
    print(response.headers['set-cookie'])
    #获取_webvpn_key和_webvpn_username
    cookie = response.headers['set-cookie'].split(';')
    webvpn_key = cookie[0].split('=')[1]
    webvpn_username = cookie[4].split('=')[1]
    print(webvpn_key)
    print(webvpn_username)
    cookies={
        '_webvpn_key':webvpn_key,
        'webvpn_username':webvpn_username,
    }
    return jwbl(request,cookies)