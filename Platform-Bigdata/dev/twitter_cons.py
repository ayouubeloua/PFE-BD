from kafka import KafkaConsumer
import json
import pyspark
from pyspark import SparkContext
from pyspark.streaming import StreamingContext

if __name__ == "__main__":
	sc = SparkContext()
	consumer = KafkaConsumer("user_test", bootstrap_servers="localhost:9092", auto_offset_reset="earliest")
	print("Consumer started")
	for msg in consumer:
		if 'text' in json.loads(msg.value):
			word = sc.parallelize([json.loads(msg.value)['text']])
			word = word.flatMap(lambda x : x.split( ' ' )).filter(lambda word : word.lower()).map(lambda x: (x, 1)).reduceByKey(lambda a, b : a + b)
			print(word.take(100))
