import requests

from webvpn.getjwcaptcha import getjwcaptcha
headers = {
    'authority': 'jwgl.webvpn.nepu.edu.cn',
    'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'accept-language': 'zh-CN,zh;q=0.9',
    'cache-control': 'max-age=0',
    'dnt': '1',
    'referer': 'https://webvpn.nepu.edu.cn/',
    'sec-ch-ua': '"Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'sec-fetch-dest': 'document',
    'sec-fetch-mode': 'navigate',
    'sec-fetch-site': 'same-site',
    'sec-fetch-user': '?1',
    'upgrade-insecure-requests': '1',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
}
def jwbl(request,cookies):
    response = requests.get('https://jwgl.webvpn.nepu.edu.cn/', headers=headers, cookies=cookies,allow_redirects=False)
    print(response.headers['set-cookie'])
    cookie = response.headers['set-cookie'].split(';')
    JSESSIONID = cookie[0].split('=')[1]
    #Cookies增加JSESSIONID
    cookies['JSESSIONID'] = JSESSIONID
    return getjwcaptcha(request,cookies)
