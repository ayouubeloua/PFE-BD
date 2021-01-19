from kafka import KafkaConsumer
import json

if __name__ == "__main__":
	consumer = KafkaConsumer("user_test", bootstrap_servers="localhost:9092", auto_offset_reset="earliest")
	print("Consumer started")
	for msg in consumer:
		print(msg)
