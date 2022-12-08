from flask import Flask
from flask import request
from jwgl.course import get_course
from jwgl.login import login
from webvpn.jwc_login import jwc_login


app = Flask(__name__)


@app.route('/jwc_login', methods=['GET', 'POST'])
def jwc_login_handler():
        return jwc_login(request)
@app.route('/', defaults={'path': ''})
def hello_world():
        return "Hello, World!"
@app.route('/login', methods=['GET', 'POST'])
def login_handler():
        return login(request)
@app.route('/course',methods=['GET', 'POST'])
def course_handler():
        print('被调用')
        return get_course(request)        
if __name__ == '__main__':
        app.run(host='0.0.0.0',port=9000)
