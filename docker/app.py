import os
import optparse
from flask import Flask
from redis import Redis

parser = optparse.OptionParser()

parser.add_option('--redis',
    action="store", dest="redis",
    help="redis host", default="")

options, args = parser.parse_args()

app = Flask(__name__)
redishost = options.redis
redis = Redis(host=redishost, port=6379)

@app.route('/')
def hello():
    count = redis.incr('hits')
    return 'Hello World! I have been seen {} times.\n'.format(count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
