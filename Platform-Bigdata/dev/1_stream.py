from pyspark import SparkContext
from pyspark.streaming import StreamingContext
import pyspark.streaming.kinesis
import pyspark.streaming.kafka
from pyspark.streaming.kafka import KafkaUtils

if __name__ == '__main__':
	sc = SparkContext(appName='test sparkstreaming kafka')
	ssc = StreamingContext(sc, 60)
	message = KafkaUtils.createDirectStream(ssc, topics=['test'], kafkaParams={ 'metadata.broker.list' : 'localhost:9092'})

	word = message.flatMap(lambda x : x.split( ' ' ))
	word.pprint()

	ssc.start()
	ssc.awaitTermination()
