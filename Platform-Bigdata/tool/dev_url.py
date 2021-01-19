from pymongo import MongoClient
import os
import pandas as pd
import cmd_generate_postgres as cmddd


class import_url_in_database:
	
	# Initialisation de l'instance
	def __init__(self, url, filename):
		self.url = url
		self.dbname = filename.split(".")[0]
		self.client = MongoClient("localhost", 27017)
		self.db = self.client["base_url"]
	
	
	
	# On télécharge et on intégre le fichier à la bdd
	def charge(self):
		self.collection = self.db[self.url.replace(".", "--")]
		db_list = list(self.collection.find({ "db" : { "$exists" : True }})
		self.collection.update_one({db : db_list}, { db : db_list + [dbname]})
		
	
	
	
		def validation_import(self, impor = None):
		self.collection = self.db[self.url.replace(".", "--")]
		res = list(self.collection.find({self.link.replace(".", "--") : {"$exists" : True}}))
		valid = ""
		if impor:
			if res == [] or res[0][self.link.replace(".", "--")] == "":
				while True:
                        		valid = input("Le dossier est il bien importé? yes or no\n")
                        		if valid == "yes" or valid == "no":
                                		break
			else:
				print("ATTENTION FICHIER DEJA IMOPRTE : " + res[0][self.link.replace(".", "--")])
		else:
			valid = "yes"
		if valid == "yes":
			if res == []:
				self.collection.insert_one({self.link.replace(".", "--") : self.dbname.replace(".", "--")})
			else:
				self.collection.update_one({self.link.replace(".", "--")}, {"$set": {self.link.replace(".", "--") : self.dbname.replace(".", "--")}})
