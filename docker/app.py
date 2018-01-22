import os
from flask import Flask
from redis import Redis

app = Flask(__name__)

redishost = os.environ["REDIS_HOST"]
redis = Redis(host=redishost, port=6379)

@app.route('/')
def hello():
    count = redis.incr('hits')
    return 'Hello World! I have been seen {} times.\n'.format(count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
