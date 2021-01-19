import tweepy
from tweepy import Stream
from tweepy.streaming import StreamListener
import socket
import json

consumer_key = 'ad5r6cL5Gzc7w3H2Pswcktc7k'
consumer_secret = 'krBNdvJcVXGAfdo8g5msbNexb36FvSwyiBN8OsjT6ZeE8UDdoE'
token = '1335980664668254208-yzMrbClzVfXOf68FvVkhSPJLCEaALG'
token_secret = 'u5y7doSjijgYEPG8jBCMlAQ7Fd5eHZ1azrOGbi01TQauf'

class TweetsListener(StreamListener):
	def __init__(self, csocket):
		self.client_socket = csocket

	def on_data(self, data):
		try:
			msg = json.loads(data)
			print(msg['text'].encode('utf-8'))
			self.client_socket.send( msg['text'].encode('utf-8'))
			return True
		except BaseException as e:
			print("Error on_data: %s" % str(e))
		return True

	def on_error(self, status):
		print(status)
		return True

def sendData(c_socket):
	auth = OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(token, token_secret)
	twitter_stream = Stream(auth, TweetListener(c_socket))
	twitter_stream.filter(track = ['football'])

s = socket.socket()
host = "127.0.0.1"
port = 7918
s.bind((host, port))
print("Listening on port : %s" % str(port))

s.listen(5)
c, addr = s.accept()
print("Receive request from : %s" % str(addr))
sendData(s)
