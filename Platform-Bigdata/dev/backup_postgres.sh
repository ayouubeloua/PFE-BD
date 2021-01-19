#/bin/bash

text=$(psql -d postgres -c 'SELECT datname FROM pg_database')

#Definir le  delimiter
delimiter=" "

#Concatenate the delimiter with the main string
string=$text$delimiter

#Split the text based on the delimiter
myarray=()
while [[ $string ]]; do
  myarray+=( "${string%%"$delimiter"*}" )
  string=${string#*"$delimiter"}
done

mkdir dump_file
#Print the words after the split
for value in ${myarray[@]}
do
  echo $value en cours "-------------------------------------------------"
  pg_dump -d $value -f dump_file/$value.dump
  echo $value importe "----------------------------------------------------------------"
done

# on zip le fichier
zip -r dump_file.zip dump_file

