from flask import Flask
import awsgi

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello from inside a Docker Container!\n'

def lambda_handler(event, context):
    return awsgi.response(app, event, context)