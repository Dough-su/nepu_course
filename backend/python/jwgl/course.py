import json
import requests
import sqlite3
headers = {
    'authority': 'jwgl.webvpn.nepu.edu.cn',
    'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'accept-language': 'zh-CN,zh;q=0.9',
    'cache-control': 'max-age=0',
    'dnt': '1',
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
def get_course(requestx):
 cookies = {
    '_webvpn_key': requestx.args.get('_webvpn_key'),
    'webvpn_username': requestx.args.get('webvpn_username'),
    'JSESSIONID': requestx.args.get('JSESSIONID'),
}
 response = requests.get('https://jwgl.webvpn.nepu.edu.cn/default!getCalendar.action', cookies=cookies, headers=headers)
 conn = sqlite3.connect('course.db')
 c = conn.cursor()
 c.execute('CREATE TABLE IF NOT EXISTS "'+cookies['JSESSIONID']+'" ( "kcmc" TEXT, "teaxms" TEXT, "jsrq" integer, "jxbmc" TEXT, "zc" integer, "xq" integer, "jxcdmc" TEXT, "sknrjj" TEXT,  "qssj" TEXT, "jssj" TEXT)') 
 conn.commit() 
 print(response.text)
 #将课程信息存入数据库
 for j in response.json():
        #如果没有teaxms字段，就结束本次循环
    try:
        j['teaxms']
    except:
        continue
    c.execute('INSERT INTO "'+cookies['JSESSIONID']+'" VALUES (?,?,?,?,?,?,?,?,?,?)',(j['kcmc'],j['teaxms'],j['jsrq'],j['jxbmc'],j['zc'],j['xq'],j['jxcdmc'],j['sknrjj'],j['qssj'],j['jssj']))
    conn.commit()#提交
    #从数据库按照课程时间和周次和星期几排序
 c.execute('SELECT * FROM "'+cookies['JSESSIONID']+'" ')
 conn.commit()
 #将课程信息存入列表
 course_list = c.fetchall()
 #将课程信息转换为json格式
 course_json = []
 for i in course_list:
     course_json.append({
         'kcmc':i[0],
         'teaxms':i[1],
         'jsrq':i[2],
         'jxbmc':i[3],
         'zc':i[4],
         'xq':i[5],
         'jxcdmc':i[6],
         'sknrjj':i[7],
         'qssj':i[8],
         'jssj':i[9]
     })
 return json.dumps(course_json,ensure_ascii=False)

