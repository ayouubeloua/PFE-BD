from pymongo import MongoClient
from bs4 import BeautifulSoup
import sys
import requests
import json

def new_link(url):
	# Lecture de l'url
	soup = BeautifulSoup(requests.get(url).text, features="html.parser")
	client = MongoClient("localhost", 27017)
	db = client["link_open_data"]
	col = db["balise"]
	# Lecture des balises ou créations de celles-ci en fonction du site présent dans l'url
	bal = list(col.find({url.split("/")[2].replace(".", "--") : { "$exists" : True }}))
	if bal == []:
		bal = input("Donner les balises sous forme de dictionnaire svp\n")
		bal = json.loads(bal)
		col.insert_one({url.split("/")[2].replace(".", "--") : bal})
	else:
		bal = bal[0][url.split("/")[2].replace(".", "--")]
	res = soup.find_all("a", bal)
	res = [i["href"] for i in res if "href" in i.attrs]
	# Ecriture des liens dans la base de données pour une vérifications utlérieur du site
	col = db["url_to_verif"]
	test = list(col.find({ url.replace(".", "--") : { "$exists" : True }}))
	if test == []:
		col.insert_one({url.replace(".", "--") : list(res)})
	else:
		print("Link already in the db")
	
	
	
def verif_all():
	# On se connecte à la bdd puis on détecte tous les liens à vérifier
	client = MongoClient("localhost", 27017)
	db = client["link_open_data"]
	col = db["url_to_verif"]
	res = list(col.find())
	# On aura besoin des balises
	col = db["balise"]
	for doc in res:
		for url, link in doc.items():
			if not "id" in url:
				soup = BeautifulSoup(requests.get(url.replace("--", ".")).text, features="html.parser")
				bal = list(col.find({url.split("/")[2] : { "$exists" : True}}))[0][url.split("/")[2]]
				soup = soup.find_all("a", bal)
				soup = [ i["href"] for i in soup if "href" in i.attrs]
				if soup != link:
					with open("/home/projetrd/New_file", "a") as file:
						file.write("New file in the url : " + url.replace("--", "."))
					print(url.replace("--", "."))
	
	
	
if  __name__ == "__main__":
	if sys.argv[1] == "insert":
		new_link(sys.argv[2])
	elif sys.argv[1] == "verif":
		verif_all()
