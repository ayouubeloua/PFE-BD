import tweepy
import json
import time
from kafka import KafkaProducer

def json_encod(data):
	return json.dumps(data).encode('utf-8')
	
	
	
def search_for_hashtags(consumer_key, consumer_secret, access_token, access_token_secret, hashtag_phrase):

	#create authentication for accessing Twitter
	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(access_token, access_token_secret)

	#initialize Tweepy API
	api = tweepy.API(auth)

	for tweet in tweepy.Cursor(api.search, q=hashtag_phrase+' -filter:retweets', \
		lang="fr", tweet_mode='extended').items(1):
		return { 'text' : tweet.full_text }
	
	
	
def search_for_user(consumer_key, consumer_secret, access_token, access_token_secret, user):

	#create authentication for accessing Twitter
	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(access_token, access_token_secret)

	#initialize Tweepy API
	api = tweepy.API(auth)

	for status in api.user_timeline(screen_name=user, count=1, tweet_mode='extended'):
		res = status
	return {'text' : res }
	
	
	
consumer_key = 'QuM5rJnk4hc1Z97OoQJqu8ib7'
consumer_secret = 'a7BExStAxftSH0FR9kX0VXDuj6U1gIdZ2FLZIO34sPVOx6dSrU'
access_token = '1335980664668254208-lIcErlioFWE7QTbTHgQSiJsniy7mWr'
access_token_secret = 'C7LouNRn1DyZtg9lrt12aatlNGCzAOPCdP7KwdYFlxU7H'


if __name__ == '__main__':
	producer = KafkaProducer(bootstrap_servers=['localhost:9092'], value_serializer=json_encod)
	#search_for_hashtags(consumer_key, consumer_secret, access_token, access_token_secret, "PBALille")
	#search_for_user(consumer_key, consumer_secret, access_token, access_token_secret, "realDonaldTrump")
	while True:
		test = search_for_hashtags(consumer_key, consumer_secret, access_token, access_token_secret, 'football')
		producer.send("user_test", test)
		print(test)
		time.sleep(60)

