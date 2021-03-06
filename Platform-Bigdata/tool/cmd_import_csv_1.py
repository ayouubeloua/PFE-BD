import os
import sys
from itertools import islice



# Fonction qui permet de générer les commandes pour importer un fichier csv dans une base postgres
def write_cmd(filename, sep=None):
	# On ouvre le fichier, on lit les 2 premiéres lignes pour créer la table et on détermin le séparateur
	with open(filename, "r") as file:
		first = [line.replace("\n", "") for line in islice(file, 2)]
	if sep == None:
		if len(first[0].split(",")) == len(first[1].split(",")) and len(first[1].split(",")) != 1:
			sep = ","
		elif len(first[0].split(";")) == len(first[1].split(";")) and len(first[1].split(";")) != 1:
			sep = ";"
	# Si le séparateur est définie on éctir les 2 commandes et on enregistre les variables dans j=une liste
	if sep:
		var = []
		cmd = "CREATE TABLE if not exists " + filename.split(".")[0].split("/")[-1] + " ("
		copy = "\COPY " + filename.split(".")[0] + " FROM " + filename + " CSV HEADER DELIMITER '" + sep + "';"
		for f, z in zip(first[0].split(sep), first[1].split(sep)):
			var += [f.lower().replace("'", "").replace("\"", "")]
			try:
				int(z)
				cmd += f + " INT,"
			except:
				try:
					float(z)
					cmd += f + " DECIMAL(100, 5),"
				except:
					cmd += f.replace("'", "").replace("\"", "") + " VARCHAR(255)," 
	return cmd[:-1] + ");", copy, var
	
	
	
# Fonction qui vas chercher tous les fichiers csv d'un dossier et qui génére les commandes pour importer les csv grâce à la fonctions ci-dessus
def import_random_csv(filename, older_cmd = None, sep=None):
	# Ecriture des commandees pour le fichier demandé
	cre, cop, var = write_cmd(filename, sep)
	# On tente d'exécuter les commandes
	os.system("psql -d open_data_lake -c '" + cre + "'")
	os.system("psql -d open_data_lake -c  \"" + cop + "\"")
	# Vérification que les commandes on bien fonctionnées en lisant le fichier des log
	os.system("tail -n 3 /var/log/postgresql/postgresql-10-main.log > tmp.log")
	with open("tmp.log", "r") as file:
		res1 = file.readline()
		res2 = file.readline().replace(":", "").split()
		res3 = file.readline()

	# En cas d'erreur on change le type de la colonne qui pose problème en VARCHAR et on rappelle la fonction 
	if "ERROR" in res1:
		pb = False
		for v in var:
			if v.strip('"') in res2 and "psql -d open_data_lake -c \" ALTER TABLE " + filename.split(".")[0] + " ALTER COLUMN " + v + " TYPE VARCHAR;\"" != older_cmd:
				older_cmd = "psql -d open_data_lake -c \" ALTER TABLE " + filename.split(".")[0] + " ALTER COLUMN " + v + " TYPE VARCHAR;\""
				os.system("psql -d open_data_lake -c \" ALTER TABLE " + filename.split(".")[0] + " ALTER COLUMN " + v + " TYPE VARCHAR;\"") 
				pb = True
				break
		if pb:
			return import_random_csv(filename, older_cmd, sep)
		else:
			os.system("rm tmp.log")
			return False
	os.system("rm tmp.log")
	
	
	
if __name__ == "__main__":
	if len(sys.argv) == 3:
		if sys.argv[2] == "tab":
			import_random_csv(sys.argv[1], sep = "\t")
		else:
			sep = sys.argv[2]
			import_random_csv(sys.argv[1], sep=sep)
	else:
		import_random_csv(sys.argv[1])
