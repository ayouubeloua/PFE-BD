import pandas as pd
import requests
import psycopg2
import sys
from pymongo import MongoClient



# Connection à la base de donnée
def connect():
	HOST = "projetrd2.francecentral.cloudapp.azure.com"
	USER = "projetrd"
	PASSWORD = "test123"
	DATABASE = "open_data_lake"

	# Open connection
	conn = psycopg2.connect("host=%s dbname=%s user=%s password=%s" % (HOST, DATABASE, USER, PASSWORD))
	conn.autocommit = True
	return conn
	
	
	
# Téléchargement de l'état des parking de Lille en temps réel
def get_doc(url):
	res = requests.get(url).json()
	res = [{ i : j for i, j in dico["fields"].items()} for dico in res["records"]]
	df = pd.DataFrame(res, columns=res[0].keys())
	return df
	
	
	
# Génére les commandes sql pour importer l'état des parkings
def generate_commande(df, dbname):
	create_cmd = "CREATE TABLE if not exists " +  dbname + " (" + ' varchar,'.join([i for i in df.columns]) + " varchar);"
	insert_cmd = "INSERT INTO " + dbname + " values"
	for row in df.values:
		insert_cmd += "( " + ' , '.join(["'" + str(j).replace("'", "\"") + "'" for j in row]) + "),"
	insert_cmd = insert_cmd[:-1] + ";"
	return create_cmd, insert_cmd
	
	
	
# Execute les commandes qui ont étaient générées
def execute_cmd(conn, cmd):
	with conn.cursor() as cur:
		cur.execute(cmd)
	
	
	
# Find if a link is import or not
def find(url):
	client = MongoClient("localhost", 27017)
	db = client["base_api"]
	col = db["ref_api"]
	ref = col.find({ url.replace(".", "--") : { "$exists" : True}})
	return list(ref)
	
	
	
# Permet d'intégrer la base de l'api en une seul commande
def integre_la_base(url, dbname = None):
	conn = connect()
	df = get_doc(url)
	ref = find(url)
	if ref == []:
		if type(dbname) == str:
			client = MongoClient("localhost", 27017)
			db = client["base_api"]
			col = db["ref_api"]
			col.insert_one({url.replace(".", "--") : [dbname, False]})
	else:
		dbname = ref[0][url.replace(".", "--")][0]
	if dbname:
		cre, ins = generate_commande(df, dbname)
		execute_cmd(conn, cre)
		execute_cmd(conn, ins)
	
	
	
# Permet de changer le temps où on insert des nouvelles données de l'api
def change_maj(url, tps_maj):
	client = MongoClient("localhost", 27017)
	db = client["base_api"]
	col = db["ref_api"]
	ref = list(col.find({ url.replace(".", "--") : { "$exists" : True}}))
	col.update_one(ref[0], {"$set": { url.replace(".", "--") : [ref[0][url.replace(".", "--")][0], tps_maj]}})
	
	
	
if __name__ == "__main__":
	if len(sys.argv) == 2:
		url = sys.argv[1]
		integre_la_base(url)
	if len(sys.argv) >= 3:
		url = sys.argv[1] 
		dbname =  sys.argv[2]
		integre_la_base(url, dbname)
	if len(sys.argv) == 4:
		change_maj(url, sys.argv[3])
