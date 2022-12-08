async function login(req,res) {
    const CryptoJS = require("crypto-js");
    const axios = require('axios');
    var verifycode = req.query.verifycode;
    var password = req.query.password;
    var key = CryptoJS.enc.Utf8.parse(verifycode + verifycode + verifycode + verifycode);
    var srcs = CryptoJS.enc.Utf8.parse(password);
    var encrypted = CryptoJS.AES.encrypt(srcs, key, { mode: CryptoJS.mode.ECB, padding: CryptoJS.pad.Pkcs7 });
    password = encrypted.ciphertext.toString();
    const response = await axios.post(
        'https://jwgl.webvpn.nepu.edu.cn/new/login',
        new URLSearchParams({
            'account': req.query.account,
            'pwd': password,
            'verifycode': req.query.verifycode
        }),
        {
            headers: {
                'authority': 'jwgl.webvpn.nepu.edu.cn',
                'accept': 'application/json, text/javascript, */*; q=0.01',
                'accept-language': 'zh-CN,zh;q=0.9',
                'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'cookie': 'JSESSIONID='+req.query.JSESSIONID+'; _webvpn_key='+req.query._webvpn_key+'; webvpn_username='+req.query.webvpn_username+'',
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
                'x-requested-with': 'XMLHttpRequest'
            }
        }
    );
    res.send(response.data);
}
exports.login = login;