#!/bin/ksh
target=$1
output1="FichierTMP1.txt"
output2="FichierTMP2.txt"


GENERATE_FTMP1(){
cat ${Liste_des_tables} |sed 1,2d| while read list_Line
do
##PARAMETERS
Table_Name=`echo ${list_Line}|cut -d"#" -f3|sed -e "s/ *$//"`;
GOT=`echo ${list_Line}|cut -d"#" -f9|sed -e "s/ *$//"`;
version=`echo ${list_Line}|cut -d"#" -f1|sed -e "s/ *$//"`;
Table_File=`echo ${list_Line}|cut -d"#" -f4`
Table_File="cfg/${Table_File}"


if [ -e ${Table_File} ] &&  [[ ${GOT} != "" ]]; then
  echo -e "${GOT}#${Table_Name}#${version}" >> FichierTMP1.txt
fi
done
}


GENERATE_FTMP2()
{
FONC=$(cat<< 'EOF'
BEGIN {
FS = "[[:space:]]*#[[:space:]]*";
}
FNR==NR{

  arr[$1,$3]=(arr[$1,$3]?arr[$1,$3]",":"")$2
  next
}
(($1,$3) in arr){
  print $1"#"arr[$1,$3]
  delete arr[$1,$3]
}
END {
}
EOF
)

awk  "${FONC}" ${output1} ${output1} > "FichierTMP2.txt"

}
GENERATE_java()
{

echo -e "#REAL NEEDS" >> ${FOLDER_APP}${current_vers}${Repository_JAVA}/"refresh_tables_anyway_properties.txt"
i=0
(cat ${output2}| while read Line
do
  i=$((i + 1))

  echo -e "C${i}=${Line}"
done ) >> ${FOLDER_APP}${current_vers}${Repository_JAVA}/"refresh_tables_anyway_properties.txt"
}
echo -e "CURRENT GENERATION : JAVA"
cat Package_Versions.txt |uniq | while read versline
do
current_vers=${versline}
GENERATE_FTMP1;
GENERATE_FTMP2;
GENERATE_java;
done
#Supprimer les fichiers temporaires
rm -r ${output1}
rm -r ${output2}
echo -e "GENERATION DONE : JAVA"
