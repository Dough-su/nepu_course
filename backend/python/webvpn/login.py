import requests

from webvpn.update import update

headers = {
    'authority': 'webvpn.nepu.edu.cn',
    'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'accept-language': 'zh-CN,zh;q=0.9',
    'cache-control': 'max-age=0',
    'dnt': '1',
    'origin': 'https://webvpn.nepu.edu.cn',
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


def login(request,cookies,csrftoken):
    data = {
    'utf8': '✓',
    'authenticity_token': csrftoken,
    'user[login]': '200502222222', #请替换为你自己的webvpn学号
    'user[password]': '123456',#请替换为你自己的webvpn密码
    'user[dymatice_code]': 'unknown',
    'user[otp_with_capcha]': 'false',
    'commit': '登录 Login',
}  
#这里有一个重要的点是请求302页面被重定向了，请求到的数据是重定向以后的，需要自己加入allow_redirects=False
    response = requests.post('https://webvpn.nepu.edu.cn/users/sign_in', cookies=cookies, headers=headers, data=data,allow_redirects=False)
    cookie = response.headers['set-cookie'].split(';')
    astraeus_session = cookie[0].split('=')[1]
    cookies = {
        'SERVERID': 'Server1',
        '_webvpn_key':'',
        'webvpn_username':'',
        '_astraeus_session': astraeus_session,
    }
    return update(request,cookies)
