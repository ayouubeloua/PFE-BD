#!/bin/ksh

   #######Generate_FICHIER_XFR#######
####Generate_INVALIDES_VALUES_TABLE####

GENERATE_Invalid_values_table()
{
GENERATE_Invalid_values=$(cat<< 'EOF'
BEGIN {                                                                         
FS = "[[:space:]]*#[[:space:]]*";
printf("out :: reformat(in) =\nbegin\nout.FLAG_REJET :: \"Y\";\nout.indicateur_2 :: in.indicateur_2;\n")
}
{
if($5 != "") 
printf("out."$1" :: string_lrtrim(in."$1");\n")
}
END {
printf("end;")
}
EOF
)

echo "Generate ${PREFIX_XFR_INVALID}${Table_Name}.xfr" >> FichierLog.${current_vers}.log
awk "$GENERATE_Invalid_values" ${Table_FIle} > ${FOLDER_APP}${current_vers}${Repository_XFR}/"${PREFIX_XFR_INVALID}${Table_Name}.xfr" ;
}

####Generate_NULL_VALUES_TABLE####

GENERATE_Null_values_table()
{
GENERATE_NULL_VALUES=$(cat<< 'EOF'
BEGIN {                                                                         
FS = "[[:space:]]*#[[:space:]]*";
printf("out :: reformat(in) =\nbegin\nout.* :: in.*;\n")
}
{
if($5 != "") 
printf("out."$1" :: first_defined(in."$1",\"#\");\n")}
END {
printf("end;")
}
EOF
)

echo "Generate ${PREFIX_DML_NULL}${Table_Name}.xfr" >> FichierLog.${current_vers}.log
awk "$GENERATE_NULL_VALUES" ${Table_FIle} > ${FOLDER_APP}${current_vers}${Repository_XFR}/"${PREFIX_DML_NULL}${Table_Name}.xfr" ;
}  
 

#####EXECUT FUNCTIONS#####
echo -e "CURRENT GENERATION XFR"

cat $Liste_des_tables |sed 1,1d | while read List_Line
do
##PARAMETERS
Table_Name=`echo ${List_Line}|cut -d"#" -f3|sed -e "s/ *$//"`;
Table_FIle=`echo ${List_Line}|cut -d"#" -f4`
Table_FIle="cfg/${Table_FIle}"
current_vers=`echo ${List_Line}|cut -d"#" -f1|sed -e "s/ *$//"`

if [ -e ${Table_FIle} ] ;then
  echo -e "GENERAT XFR FIles ${Table_FIle}"	>> FichierLog.${current_vers}.log
  GENERATE_Null_values_table ;
                if [ $? -ne 0 ];then
                  echo -e "##Erreur : GENERATE_Null_values_table Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
                else echo -e "##GENERATE_Null_values_table  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
               fi

  GENERATE_Invalid_values_table ;
               if [ $? -ne 0 ];then
                  echo -e "##Erreur : GENERATE_Invalid_values_table Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
               else echo -e "##GENERATE_Invalid_values_table  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
               fi
else echo -e "GENERAT XFR FIles ${Table_FIle}\n${Table_FIle} n'existe pas" >> FichierLog.${current_vers}.log
fi
done
echo -e "GENERAT DONE XFR"



