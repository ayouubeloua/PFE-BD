import os
from itertools import islice



# Fonction qui permet de générer les commandes pour importer un fichier csv dans une base postgres
def write_cmd(path):
    with open(path) as file:
        first = [line.replace("\n", "") for line in islice(file, 2)]
        if len(first[0].split(",")) == len(first[1].split(",")) and len(first[1].split(",")) != 1:
            print(len(first[0].split(",")), "-", len(first[1].split(",")))
            sep = ","
        elif len(first[0].split(";")) == len(first[1].split(";")) and len(first[1].split(";")) != 1:
            sep = ";"
        else:
            sep = None
        if sep:
            cmd = "CREATE TABLE " + path.split(".")[1].split("/")[-1] + " ("
            copy = "\COPY " + path.split(".")[1].split("/")[-1] + " FROM " + path + " CSV HEADER DELIMITER '" + sep + "';"
            for f, z in zip(first[0].split(sep), first[1].split(sep)):
                try:
                    int(z)
                    cmd += f + " INT,"
                except:
                    try:
                        float(z)
                        cmd += f + " DECIMAL(100, 5),"
                    except:
                        cmd += f + " VARCHAR(255)," 
    return cmd[:-1] + ");", copy
	
	
	
# Fonction qui vas chercher tous les fichiers csv d'un dossier et qui génére les commandes pour importer les csv grâce à la fonctions ci-dessus
def import_random_csv(path = "./", rec = False):
	if path.split(".")[-1] != "/":
		path += "/"
	file_list = os.listdir(path)
	for f in file_list:
		if rec and os.path.isdir(path + f):
			import_random_csv(path + f + "/")
		if os.path.isfile(path + f):
			if f.split(".")[-1] == "csv":
				cmd, cop = write_cmd(path + f)
				print("-----------------------------------")
				print(cmd)
				print(cop)
				print("-----------------------------------")
	
	
	
if __name__ == "__main__":
	import_random_csv()
