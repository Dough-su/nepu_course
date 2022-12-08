import requests
#获取网页验证码的验证
from bs4 import BeautifulSoup
from webvpn.getcaptcha import get_captcha

headers = {
    'authority': 'webvpn.nepu.edu.cn',
    'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'accept-language': 'zh-CN,zh;q=0.9',
    'cache-control': 'max-age=0',
    'dnt': '1',
    'if-none-match': 'W/"a4d94db15f69adefca84abe15f9673be"',
    'sec-ch-ua': '"Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'sec-fetch-dest': 'document',
    'sec-fetch-mode': 'navigate',
    'sec-fetch-site': 'none',
    'sec-fetch-user': '?1',
    'upgrade-insecure-requests': '1',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
}
def jwc_login(request):
        response = requests.get('https://webvpn.nepu.edu.cn/users/sign_in', headers=headers)
        #提取cookie中的_astraeus_session ,SERVERID
        cookie = response.headers['set-cookie'].split(';')
        astraeus_session = cookie[0].split('=')[1]
        html=BeautifulSoup(response.text,'html.parser')
        csrftoken=html.find('meta',attrs={'name':'csrf-token'})['content']
        #
        cookies = {
        '_astraeus_session': astraeus_session,
        'SERVERID': 'Server1',
        }
        return get_captcha(request,cookies,csrftoken)
