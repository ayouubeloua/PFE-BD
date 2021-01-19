from __future__ import print_function
from pyspark.sql import SparkSession
from pyspark import SparkContext
from pyspark.streaming import StreamingContext

spark = SparkSession.builder.getOrCreate()

sc = spark.sparkContext
#sc = SparkContext(appName="streamtwitterapp")
sc.setLogLevel("WARN")
ssc = StreamingContext(sc, 10)

socket_stream = ssc.socketTextStream("127.0.0.1", 7918)

lines = socket_stream.window(60)

hashtags = lines.flatMap(lambda text : text.split( " " )).filter(lambda word : word.lower().startswith("#")).map(lambda word : (word, 1)).reduceByKey(lambda a,b:a+b)

author_counts_sorted_dstream = hashtags.transform(lambda foo:foo.sortBy(lambda x : x[0].lower()))

ssc.start()
ssc.awaitTermination()
