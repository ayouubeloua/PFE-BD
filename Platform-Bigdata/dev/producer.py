from kafka import KafkaProducer
import json
import time
from faker import Faker



def json_encod(data):
	return json.dumps(data).encode('utf-8')
	
	
	
def false_user(fake):
	return { "name" : fake.name(), "adress" : fake.address(), "date" : fake.year() }
	
	
	
producer = KafkaProducer(bootstrap_servers=['localhost:9092'], value_serializer=json_encod)

if __name__ == "__main__":
	fake = Faker()
	while True:
		new_user = false_user(fake)
		print(new_user)
		producer.send("user_test", new_user)
		time.sleep(5)
