import requests

from jwgl.course import get_course
headers = {
    'authority': 'jwgl.webvpn.nepu.edu.cn',
    'accept': 'application/json, text/javascript, */*; q=0.01',
    'accept-language': 'zh-CN,zh;q=0.9',
    'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
    # Requests sorts cookies= alphabetically
    # 'cookie': '_webvpn_key=eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiMjAwNTAyMTQwMjI0IiwiZ3JvdXBzIjpbMTIxLDFdLCJpYXQiOjE2Njk3OTI3NTYsImV4cCI6MTY2OTg3OTE1Nn0.E4mLe2D6VrD324TakXJ0RpvsXDNNHWGUcEH80E2UWjc; webvpn_username=200502140224%7C1669792756%7Ca0b7176053087c75d12ab4407cf8bebe14080fdb; JSESSIONID=64904BD6340BB22C48CE7CD310E1FA5C',
    'dnt': '1',
    'origin': 'https://jwgl.webvpn.nepu.edu.cn',
    'referer': 'https://jwgl.webvpn.nepu.edu.cn/',
    'sec-ch-ua': '"Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-origin',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
    'x-requested-with': 'XMLHttpRequest',
}


def login(requestx):
 #获取request参数
 account = requestx.args.get('account')
 pwd = requestx.args.get('password')
 verifycode = requestx.args.get('verifycode')
 data = {
        'account': account,
        'pwd': pwd,
        'verifycode': verifycode,
    }
 cookies = {
       '_webvpn_key': requestx.args.get('_webvpn_key'),
       'webvpn_username': requestx.args.get('webvpn_username'),
        'JSESSIONID': requestx.args.get('JSESSIONID'),
    }
 response = requests.post('https://jwgl.webvpn.nepu.edu.cn/new/login', headers=headers, cookies=cookies, data=data)
 return response.text