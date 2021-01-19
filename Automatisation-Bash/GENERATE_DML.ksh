#!/bin/ksh

#########Generate_FICHIER_DML#########
#########Generate_INSIDE_FICHIER_TABLE#########


GENERATE_INSIDE_FICHIER_TABLE_Int()
{
FICHIER_TABLE_Int=$(cat<< 'EOF'
BEGIN {                                                                         
  FS = "[[:space:]]*#[[:space:]]*";
   str1="(\"${SEPARATEUR_ABINITIO}\")";
   str2= "= NULL(\"\")""\t""/*""\n";
   strF="(\"${SEPARATEUR_FIN_LIGNE}\")";
printf("record\n")
printf("string(\"${SEPARATEUR_ABINITIO}\", maximum_length=1) FLAG_REJET = \"N\";\n")
printf("decimal(\"${SEPARATEUR_ABINITIO}\") sequence = NULL(\"\");\n")
printf("string(\"${SEPARATEUR_ABINITIO}\") indicateur_2 = NULL(\"\");\n\n")

}
{
gsub("\.",",",$4)
if($6 ~ /^date/) $6= "\tDATE FORMAT 'YYYY/MM/DD'\t*/;";
else if ($6 ~ /heure/) $6= "\tTIME(0)\t\t\t*/;" ;
else $6="\t"$3"("$4")\t\t\t*/;"
$3= ($3 ~ /^CHAR/ ? "string" : "decimal")
gsub("NUMERIC","DECIMAL",$6)
printf($3 str1 "\t" $1"= NULL(\"\")""\t""/*" $6 "\n")}
END {
printf($3 strF "\t" $1"= NULL(\"\")""\t""/*" $6 "\n")
printf("end")
}
EOF
)

echo "Generate ${PREFIX_DML_TABLE}${Table_Name}${SUFFIX_DML_FICHIER}.dml"  >> FichierLog.${current_vers}.log
awk "$FICHIER_TABLE_Int" ${Table_File} >> ${FOLDER_APP}${current_vers}${Repository_DML}/"${PREFIX_DML_FICHIER}${Table_Name}${SUFFIX_DML_FICHIER}.dml" ;
ed -s ${FOLDER_APP}${current_vers}${Repository_DML}/"${PREFIX_DML_FICHIER}${Table_Name}${SUFFIX_DML_FICHIER}.dml" <<< $'$-2d\nw';
}
#########Generate_INSIDE_FICHIER_TABLE_Int#########

GENERATE_INSIDE_FICHIER_TABLE()
{
INSIDE_FICHIER_TABLE=$(cat<< 'EOF'
BEGIN {                                                                         
   FS = "[[:space:]]*#[[:space:]]*";
   str1="(\"\\\"${SEPARATEUR_ABINITIO}\\\"\")";
   str2= "= NULL(\"\")""\t""/*""\n";
   strF="(\"\\\"${SEPARATEUR_FIN_LIGNE}\")";
printf("record\n"" ")
printf("decimal(\"\\\"${SEPARATEUR_ABINITIO}\\\"\") sequence = NULL(\"\");\n"" ")
printf("string(\"\\\"${SEPARATEUR_ABINITIO}\\\"\") date_heure_extraction = NULL(\"\");\n"" ")
printf("string(\"\\\"${SEPARATEUR_ABINITIO}\\\"\") indicateur_1 = NULL(\"\");\n"" ")
printf("string(\"\\\"${SEPARATEUR_ABINITIO}\\\"\") indicateur_2 = NULL(\"\");\n"" ")
printf("string(\"\\\"${SEPARATEUR_ABINITIO}\\\"\") indicateur_3 = NULL(\"\");\n\n")
}
{
gsub("\.",",",$4)
if($6 ~ /^date/) $6= "\tDATE FORMAT 'YYYY/MM/DD'\t*/;";
else if ($6 ~ /heure/) $6= "\tTIME(0)\t\t\t*/;";
else $6="\t"$3"("$4")\t\t\t*/;"
$3= ($3 ~ /^CHAR/ ? "string" : "decimal")
gsub("NUMERIC","DECIMAL",$6)
printf($3 str1 "\t" $1"= NULL(\"\")""\t""/*" $6 "\n")}

END {
printf($3 strF "\t" $1"= NULL(\"\")""\t""/*" $6 "\n")
printf("end""(\"\\\"${SEPARATEUR_FIN_LIGNE}\");")
}
EOF
)

echo "Generate ${PREFIX_DML_FICHIER}${Table_Name}.dml" >> FichierLog.${current_vers}.log
awk "$INSIDE_FICHIER_TABLE" ${Table_File} >> ${FOLDER_APP}${current_vers}${Repository_DML}/"${PREFIX_DML_FICHIER}${Table_Name}.dml"
ed -s ${FOLDER_APP}${current_vers}${Repository_DML}/"${PREFIX_DML_FICHIER}${Table_Name}.dml" <<<  $'$-2d\nw';
}
#########Generate_INSIDE_TABLE#########

GENERATE_INSIDE_TABLE()
{
echo "Generate ${PREFIX_DML_TABLE}${Table_Name}.dml"	>> FichierLog.${current_vers}.log
strDate="= NULL(\"\")    \t\t/* DATE FORMAT 'YYYY/MM/DD'\t*/; "
strDate2="date(\"YYYY-MM-DD\")"
strTime="= NULL(\"\")    \t\t/* TIME(0)\t\t\t*/; "
strTime2="datetime(\"HH24:MI:SS\")"
strNull="= NULL(\"\")    \t\t/*"
strsep="(\"\${SEPARATEUR_ABINITIO}\""
strsep2="string${strsep},maximum_length="
strFIN="string(\"\${SEPARATEUR_FIN_LIGNE}\", maximum_length=1)\t\t"
strRej="FLAG_REJET = NULL(\"\") \t\t/*"
strLat="CHARACTER SET LATIN   */;"

echo -e "record
string(\"$""{SEPARATEUR_ABINITIO}\", maximum_length=1) indicateur_2 = NULL(\"\");\n" >> ${FOLDER_APP}${current_vers}${Repository_DML}/"${PREFIX_DML_TABLE}${Table_Name}.dml"
(cat ${Table_File}| while read line
do
Table_Key=`echo ${line}|cut -d"#" -f1`;
Key_Type=`echo ${line}|cut -d"#" -f3|sed -e "s/ *$//"`;
Key_DateTime=`echo ${line}|cut -d"#" -f6`;
Int_Part=`echo ${line}|cut -d"#" -f4|cut -d"." -f1|cut -d" " -f2|sed -e "s/ *$//"`
Dec_Part=`echo ${line}|cut -d"#" -f4|cut -d"." -f2|sed -e "s/ *$//"`
Key_Size=`echo ${line}|cut -d"#" -f4|sed -e "s/ *$//"`

i=$((Int_Part + 2 ))
  if [ ${Key_Type} == "DECIMAL" ] ;  then
  case "${Key_DateTime}" in
        Date*|date*)  echo -e "${strDate2} ${strsep})\t\t\t\t${Table_Key}${strDate}" ;;
        Heure*|heure*) echo -e "${strTime2} ${strsep})\t\t\t${Table_Key}${strTime}";;
        * )     echo -e "decimal${strsep}.${Dec_Part}, maximum_length=${i}, sign_reserved)" " ${Table_Key}${strNull}" "${Key_Type}""(${Int_Part},${Dec_Part})\t\t*/;";;
  esac
  elif [ ${Key_Type} == "NUMERIC" ] ; then
  echo -e "decimal${strsep},${Dec_Part}, maximum_length=${Int_Part}, sign_reserved)" "  ${Table_Key}${strNull}" "DECIMAL""(${Int_Part},${Dec_Part})\t\t*/;"

  else 
  echo -e  "${strsep2}${Key_Size}) \t\t\t"${Table_Key}${strNull}" "${Key_Type}"(${Key_Size})\t\t\t*/;"
  fi        
done 
echo -e ${strFIN}"\t"${strRej}" CHAR(1)" ${strLat} >> ${FOLDER_APP}${current_vers}${Repository_DML}/"${PREFIX_DML_TABLE}${Table_Name}.dml"
echo "end" ) >> ${FOLDER_APP}${current_vers}${Repository_DML}/"${PREFIX_DML_TABLE}${Table_Name}.dml"
}

#####EXECUT FUNCTIONS#####

echo -e "current GENERATION DML"
cat ${Liste_des_tables} |sed 1,1d | while read list_Line
do
##PARAMETERS
Table_Name=`echo ${list_Line}|cut -d"#" -f3|sed -e "s/ *$//"`;
Table_File=`echo ${list_Line}|cut -d"#" -f4`
Table_File="cfg/${Table_File}"
current_vers=`echo ${list_Line}|cut -d"#" -f1|sed -e "s/ *$//"`

if [ -e ${Table_File} ] ; then
  echo -e "GENERAT DML Files ${Table_File}" >> FichierLog.${current_vers}.log

 GENERATE_INSIDE_FICHIER_TABLE ;
 if [ $? -ne 0 ];then
   echo -e "##Erreur : GENERATE_INSIDE_FICHIER_TABLE Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
   else echo -e "##GENERATE_INSIDE_FICHIER_TABLE  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_INSIDE_FICHIER_TABLE_Int ;
 if [ $? -ne 0 ];then
   echo -e "##Erreur : GENERATE_INSIDE_FICHIER_TABLE_Int Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
   else echo -e "##GENERATE_INSIDE_FICHIER_TABLE_Int  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_INSIDE_TABLE  ;
 if [ $? -ne 0 ];then
   echo -e "##Erreur : GENERATE_INSIDE_TABLE Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
   else echo -e "##GENERATE_INSIDE_TABLE  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

else echo -e "GENERAT DML Files : ${Table_File} N'EXISTE PAS\n"  >> FichierLog.${current_vers}.log
fi
done

echo -e "GENERAT DONE DML"



