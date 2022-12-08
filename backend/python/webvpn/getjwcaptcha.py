import requests


headers = {
    'authority': 'jwgl.webvpn.nepu.edu.cn',
    'accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
    'accept-language': 'zh-CN,zh;q=0.9',
    'dnt': '1',
    'referer': 'https://jwgl.webvpn.nepu.edu.cn/',
    'sec-ch-ua': '"Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'sec-fetch-dest': 'image',
    'sec-fetch-mode': 'no-cors',
    'sec-fetch-site': 'same-origin',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
}

def getjwcaptcha(request,cookies):
    response = requests.get('https://jwgl.webvpn.nepu.edu.cn/yzm', cookies=cookies, headers=headers)
    #取出cookies的数据
    _webvpn_key = cookies['_webvpn_key']
    webvpn_username = cookies['webvpn_username']
    JSESSIONID = cookies['JSESSIONID']
    #合并cookies
    cookies = {
         _webvpn_key,
         webvpn_username,
         JSESSIONID,
    }
    return (response.content,200,{'Content-Type': 'image/png','set-cookie': cookies})
    