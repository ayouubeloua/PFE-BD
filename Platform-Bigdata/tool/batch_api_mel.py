import requests
import json
import os

url = 'https://opendata.lillemetropole.fr/api/records/1.0/search/?dataset=disponibilite-parkings&q=&rows=100&facet=libelle&facet=ville&facet=etat'
dbname = 'batch_mel'
	
	
	
ins = f'insert into {dbname} values ('
soup = json.loads(requests.get(url).text)
for val in soup['records']:
	cre = f'create table if not exists {dbname} ('
	for col, v in val['fields'].items():
		if col == 'datemaj':
			v = '-'.join(list(reversed(v.split("T")[0].split('-')))) + " " + ':'.join(v.split('T')[1].split(':')[0:2])
		if 'int' in str(type(v)) or 'float'in str(type(v)):
			cre += col + ' int, '
			ins += str(v) + ', '
		else:
			if 'dict' not in str(type(v)):
				cre += col + ' varchar, '
				ins += '\'' +str(v.replace('\'', ' ')) + '\', '
	ins = ins[:-2] +  '), ('
cre = cre[:-2] + ')'
ins = ins[:-3]
os.system('psql -d open_data_lake -c "' + cre + '"')
os.system('psql -d open_data_lake -c "' + ins + '"')
