import requests

from webvpn.login import login
headers = {
    'authority': 'webvpn.nepu.edu.cn',
    'accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
    'accept-language': 'zh-CN,zh;q=0.9',
    'dnt': '1',
    'referer': 'https://webvpn.nepu.edu.cn/users/sign_in',
    'sec-ch-ua': '"Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'sec-fetch-dest': 'image',
    'sec-fetch-mode': 'no-cors',
    'sec-fetch-site': 'same-origin',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
}
def get_captcha(request,cookies,csrftoken):
    response = requests.get('https://webvpn.nepu.edu.cn/rucaptcha/', cookies=cookies, headers=headers)
    cookie = response.headers['set-cookie'].split(';')
    astraeus_session = cookie[0].split('=')[1]
    cookies = {
        'SERVERID': 'Server1',
        '_astraeus_session': astraeus_session,
    }
    return login(request,cookies,csrftoken)