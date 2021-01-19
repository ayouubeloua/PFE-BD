#!/bin/ksh

	#########Generate_FICHIER_SQL#########
    #########GENERATE_IND_ALM_TABLE_Insert#########
GENERATE_IND_ALM_TABLE_Insert()
{
echo -e "Generate ${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Ins}.sql" >> FichierLog.${current_vers}.log

echo -e "INSERT INTO $""{IND_ODS_DISE}.${DOM}_${Table_Name}\n(">> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Ins}.sql"
cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
echo -e "${key},"
done >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Ins}.sql"
echo -e "FLAG_REJET,
ODS_CREATION_DATE,
ODS_UPDATE_DATE\n)\nSELECT" >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Ins}.sql"

cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
echo -e "${key},"
done >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Ins}.sql"

(echo -e "FLAG_REJET,
CURRENT_TIMESTAMP(0),
CURRENT_TIMESTAMP(0)
FROM $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB}
WHERE $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB}.TYP_MVT = 'I' ;
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;") >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Ins}.sql"
}

    #########GENERATE_IND_ALM_TABLE_DELETE#########
GENERATE_IND_ALM_TABLE_Delete()
{
echo "Generate ${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Del}.sql" >> FichierLog.${current_vers}.log

(echo -e "DELETE $""{IND_ODS_DISE}.${DOM}_${Table_Name}
FROM $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB} , $""{IND_ODS_DISE}.${DOM}_${Table_Name}
WHERE $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB}.TYP_MVT = 'D' ") >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Del}.sql"
cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
Key_Primary=`echo ${Table_Line}|cut -d"#" -f5`;

if [ "${Key_Primary}" != " " ];  then
echo -e "AND  $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB}.${key}= $""{IND_ODS_DISE}.${DOM}_${Table_Name}.${key}"
	fi

done >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Del}.sql"

echo -e ";
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Del}.sql"
}


    #########GENERATE_IND_ALM_TABLE_Update#########

GENERATE_IND_ALM_TABLE_Update()
{

echo "Generate ${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql" >> FichierLog.${current_vers}.log

(echo "MERGE INTO  $""{IND_ODS_DISE}.${DOM}_${Table_Name} TGT
USING ( SELECT * FROM  $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB} WHERE TYP_MVT = 'U' AND FLAG_REJET = 'N') AS SRC
ON (1=1)" ) >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
Key_Primary=`echo ${Table_Line}|cut -d"#" -f5`;
	if [ "${Key_Primary}" != " " ];  then
echo -e "AND SRC.${key} = TGT.${key}"
	fi
done >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

echo "WHEN MATCHED THEN UPDATE SET" >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
Key_Primary=`echo ${Table_Line}|cut -d"#" -f5`;
	if [ "${Key_Primary}" == " " ];  then
		echo -e "${key} = SRC.${key},"
	fi
done >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

echo -e  "FLAG_REJET = SRC.FLAG_REJET,
ODS_UPDATE_DATE  = CURRENT_TIMESTAMP(0)\n
WHEN NOT MATCHED THEN INSERT(" >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`

echo -e "${key},"
done >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

(echo "FLAG_REJET,
ODS_CREATION_DATE,
ODS_UPDATE_DATE
) VALUES (") >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
echo -e "SRC.${key},"
done >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

(echo -e "SRC.FLAG_REJET,
CURRENT_TIMESTAMP(0),
CURRENT_TIMESTAMP(0));\n
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;\n

MERGE INTO   $""{IND_ODS_DISE}.${DOM}_${Table_Name} TGT
USING ( SELECT * FROM  $""{IND_ODS_DISE}.${DOM}_T_${Table_Name}_$""{NB} WHERE TYP_MVT = 'U' AND FLAG_REJET = 'Y') AS SRC\nON (1=1)") >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
Key_Primary=`echo ${Table_Line}|cut -d"#" -f5`;
	if [ "$Key_Primary" != " " ];  then
		echo -e "AND SRC.${key} = TGT.${key}"
	fi
done >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

echo -e "WHEN MATCHED THEN UPDATE SET\nFLAG_REJET = 'Y',
ODS_UPDATE_DATE = CURRENT_TIMESTAMP(0)
WHEN NOT MATCHED THEN INSERT(" >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

cat ${Table_File} | while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
echo -e "${key},"
done >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

(echo "FLAG_REJET,
ODS_CREATION_DATE,
ODS_UPDATE_DATE
) VALUES (") >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
echo -e "SRC.${key},"
done >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"

echo -e "SRC.FLAG_REJET,
CURRENT_TIMESTAMP(0),
CURRENT_TIMESTAMP(0));\n
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;" >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_Up}.sql"
}

    #########GENERATE_IND_ALM_TABLE_Insert_DEL#########

GENERATE_IND_ALM_TABLE_Insert_DEL()
{
INSERT_DEL=$(cat<< 'EOF'
BEGIN {
  FS = "[[:space:]]*#[[:space:]]*";
}

{
if($5 != "")
printf "%s%s", sep,$1; sep = "|| ' | ' ||"; }

END {
printf ",\n"
}
EOF
)

echo "Generate ${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_InsDel}.sql"	>> FichierLog.${current_vers}.log
(echo -e "INSERT INTO   $""{IND_ODS_DISE}.SUIV_GLOBAL_REJ
(
  DOM_TRT ,
  TAB_CIBL ,
  CHMP_CLE_FCT ,
  DAT_SUPP
)
SELECT
\t'${DOM}',
\t'${Table_Name}',
") >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_InsDel}.sql"

awk "${INSERT_DEL}" ${Table_File} >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_InsDel}.sql"

echo -e "CURRENT_TIMESTAMP(0)">> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_InsDel}.sql"

(echo -e "FROM   $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB}
WHERE   $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB}.TYP_MVT='D'\n;
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;") >> ${FOLDER_APP}${current_vers}${Repository_ALM}/"${PREFIX_SQL_ALM}${DOM}_${Table_Name}${SUFFIX_SQL_InsDel}.sql"
}

    #########GENERATE_TABLE_SCHEMA#########
GENERATE_TABLE_schema()
{

echo "Generate ${DOM}_${Table_Name}${SUFFIX_SQL_CGH}.sql" >> FichierLog.${current_vers}.log
(cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
Key_Type=`echo ${Table_Line}|cut -d"#" -f3`;
Key_DateTime=`echo ${Table_Line}|cut -d"#" -f6`
Int_Part=`echo ${Table_Line}|cut -d"#" -f4|cut -d"." -f1|cut -d" " -f2`
Key_Size=`echo ${Table_Line}|cut -d"#" -f4|sed -e "s/ *$//"`;
i=$(($Int_Part + 2 ))
n=$(($Int_Part + 1 ))
	if [ ${Key_Type} == "DECIMAL" ];  then
	case "${Key_DateTime}" in
    		date*|Date*)  echo -e ${key} "VARCHAR(10)," ;;
    		heure*|Heure*) echo -e ${key} "VARCHAR(8),"  ;;
		*)      echo -e ${key} "VARCHAR(${i})," ;;
	esac
  elif [ ${Key_Type} == "NUMERIC" ];  then
    echo -e ${key} "VARCHAR(${n}),"
	else
	echo -e  ${key} "VARCHAR(${Key_Size}),"
	fi
done ) >> ${FOLDER_APP}${current_vers}${Repository_CHG}/"${DOM}_${Table_Name}${SUFFIX_SQL_CGH}.sql"
}

    #########GENERATE_DOM_TABLE########

GENERATE_DOM_TABLE()
{
KEY_PRIMARY=$(cat<< 'EOF'
BEGIN {
FS = "[[:space:]]*#[[:space:]]*";
}
{
if($5 != "")
printf "%s%s", sep,$1; sep = ","; }

END {printf ");"
}
EOF
)


echo -e "Generate ${DOM}_${Table_Name}.sql" >> FichierLog.${current_vers}.log

echo -e  "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES WHERE DATABASENAME='$""{IND_ODS_DISE}' AND TABLENAME='${DOM}_${Table_Name}' AND TABLEKIND='T';
.IF ACTIVITYCOUNT > 0 THEN DROP TABLE $""{IND_ODS_DISE}.${DOM}_${Table_Name};
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

CREATE MULTISET TABLE $""{IND_ODS_DISE}.${DOM}_${Table_Name} , NO FALLBACK,
NO BEFORE JOURNAL,
NO AFTER JOURNAL,
CHECKSUM = DEFAULT,
DEFAULT MERGEBLOCKRATIO\n(" >> ${FOLDER_APP}${current_vers}${Repository_TableODS}/"${DOM}_${Table_Name}.sql"

i=0;
(cat ${Table_File}| while read Table_Line
do
i=$(($i + 1))
key=`echo ${Table_Line}|cut -d"#" -f1`
Key_DateTime=`echo ${Table_Line}|cut -d"#" -f6`
Key_Type=`echo ${Table_Line}|cut -d"#" -f3|sed -e "s/ *$//"`;
Key_Size=`echo ${Table_Line}|cut -d"#" -f4|sed -e "s/\./,/g"|sed -e "s/ *$//"`;
	if [ $i = 1 ];  then
	case "${Key_DateTime}" in
    		date*|Date*)  echo -e "${key} DATE FORMAT 'YYYY/MM/DD'" ;;
    		heure*|Heure*) echo -e "${key} TIME(0)"  ;;
			* )      echo -e "${key} ${Key_Type}(${Key_Size})" ;;
	esac
	else
	case "${Key_DateTime}" in
    		date*|Date*)  echo -e ",${key} DATE FORMAT 'YYYY/MM/DD'" ;;
    		heure*|Heure*) echo -e ",${key} TIME(0)"  ;;
		*)      echo -e ",${key} ${Key_Type}(${Key_Size})" ;;
	esac
	fi
done ) >> ${FOLDER_APP}${current_vers}${Repository_TableODS}/"${DOM}_${Table_Name}.sql"

echo -n ",FLAG_REJET  CHAR(1) COMPRESS ('Y','N')
,ODS_CREATION_DATE TIMESTAMP(0)
,ODS_UPDATE_DATE TIMESTAMP(0)
)
PRIMARY INDEX NUPI_${DOM}"_"${Table_Name}(" >> ${FOLDER_APP}${current_vers}${Repository_TableODS}/"${DOM}_${Table_Name}.sql" | awk "${KEY_PRIMARY}" ${Table_File}  >> ${FOLDER_APP}${current_vers}${Repository_TableODS}/"${DOM}_${Table_Name}.sql"


echo -e "\n.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

COMMENT ON TABLE $""{IND_ODS_DISE}.${DOM}_${Table_Name}  IS '${Table_Comment}';" >> ${FOLDER_APP}${current_vers}${Repository_TableODS}/"${DOM}_${Table_Name}.sql"

(cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
Key_Comment=`echo ${Table_Line}|cut -d"#" -f2`

echo -e "COMMENT ON COLUMN $""{IND_ODS_DISE}.${DOM}_${Table_Name}.${key} IS '${Key_Comment}					';"
done ) >> ${FOLDER_APP}${current_vers}${Repository_TableODS}/"${DOM}""_${Table_Name}.sql"

echo -e "\nCOLLECT STATISTICS ON $""{IND_ODS_DISE}.${DOM}_${Table_Name} INDEX NUPI_${DOM}_${Table_Name};
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;" >> ${FOLDER_APP}${current_vers}${Repository_TableODS}/"${DOM}_${Table_Name}.sql"

}

    #########GENERATE_V_{DOM}_TABLE#########
GENERATE_V_DOM_TABLE()
{
echo "Generate V_${DOM}_${Table_Name}.sql" >> FichierLog.${current_vers}.log

echo -e "REPLACE VIEW $""{IND_ODS_DISE_V}.V_${DOM}_${Table_Name} AS LOCKING ROW FOR ACCESS
SELECT" >> ${FOLDER_APP}${current_vers}${Repository_VuesODS}/"V_${DOM}_${Table_Name}.sql"
awk -F '[[:space:]]*#[[:space:]]*' '{ printf $1",\n"; sep = "||"; } END { printf "FLAG_REJET,\nODS_CREATION_DATE,\nODS_UPDATE_DATE\n" }' ${Table_File} >> ${FOLDER_APP}${current_vers}${Repository_VuesODS}/"V_${DOM}""_${Table_Name}.sql"
echo -e "FROM $""{IND_ODS_DISE}.${DOM}_${Table_Name};
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;" >> ${FOLDER_APP}${current_vers}${Repository_VuesODS}/"V_${DOM}_${Table_Name}.sql"
}

    #########GENERATE_DOM_T_TABLE#########
GENERATE_DOM_T_TABLE()
{
KEY_PRIMARY=$(cat<< 'EOF'
BEGIN {
FS = "[[:space:]]*#[[:space:]]*";
}
{
if($5 != "")
printf "%s%s", sep,$1; sep = ","; }

END {
}
EOF
)

echo "Generate ${DOM}_T_${Table_Name}.sql" >> FichierLog.${current_vers}.log

echo "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLEName FROM DBC.TABLES WHERE DATABASENAME='$""{IND_TMP_DISE}' AND TABLENAME='${DOM}_T_${Table_Name}_$""{NB}' AND TABLEKIND='T';
.IF ACTIVITYCOUNT > 0 THEN DROP TABLE $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB};
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;" >> ${FOLDER_APP}${current_vers}${Repository_INS}/"${DOM}_T_${Table_Name}.sql"

echo -e "CREATE MULTISET TABLE $""{IND_TMP_DISE}.${DOM}_${Table_Name}_$""{NB}" >> ${FOLDER_APP}${current_vers}${Repository_INS}/"${DOM}""_T_${Table_Name}.sql"

i=0;
(cat ${Table_File}| while read Table_Line
do
i=$(($i + 1))
key=`echo ${Table_Line}|cut -d"#" -f1`
Key_DateTime=`echo ${Table_Line}|cut -d"#" -f6`
Key_Type=`echo ${Table_Line}|cut -d"#" -f3|sed -e "s/NUMERIC/DECIMAL/g"|sed -e "s/ *$//"`;
Key_Size=`echo ${Table_Line}|cut -d"#" -f4|sed -e "s/\./,/g"|sed -e "s/ *$//"`;

	if [ $i = 1 ];  then
	case "${Key_DateTime}" in
    		date*|Date*)  echo -e "${key} DATE FORMAT 'YYYY/MM/DD'" ;;
    		heure*|Heure*) echo -e "${key} TIME(0)"  ;;
			*)      echo -e "${key} ${Key_Type}(${Key_Size})" ;;
	esac
	else
	case "${Key_DateTime}" in
    		date*|Date*)  echo -e ",${key} DATE FORMAT 'YYYY/MM/DD'" ;;
    		heure*|Heure*) echo -e ",${key} TIME(0)"  ;;
			*)      echo -e ",${key} ${Key_Type}(${Key_Size})" ;;
	esac
	fi
done ) >> ${FOLDER_APP}${current_vers}${Repository_INS}/"${DOM}_T_${Table_Name}.sql"

echo -n ",FLAG_REJET  CHAR(1) COMPRESS ('Y','N')
,TYP_MVT     CHAR(1) COMPRESS ('I','U','D')
)
PRIMARY INDEX NUPI_${DOM}_${Table_Name}_$""{NB}("  >> ${FOLDER_APP}${current_vers}${Repository_INS}/"${DOM}_T_${Table_Name}.sql" | awk "${KEY_PRIMARY}" ${Table_File} >> ${FOLDER_APP}${current_vers}${Repository_INS}/"${DOM}_T_${Table_Name}.sql"

( echo -e ");\n.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

COMMENT ON TABLE $""{IND_TMP_DISE}.${DOM}_${Table_Name}_$""{NB}  IS '$Table_Comment';\n" ) >> ${FOLDER_APP}${current_vers}${Repository_INS}/"${DOM}_T_${Table_Name}.sql"

(cat ${Table_File}| while read Table_Line
do
key=`echo ${Table_Line}|cut -d"#" -f1`
Key_Comment=`echo ${Table_Line}|cut -d"#" -f2`

echo -e "COMMENT ON COLUMN $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB}.${key} IS '${Key_Comment}					';"
done ) >> ${FOLDER_APP}${current_vers}${Repository_INS}/"${DOM}""_T_${Table_Name}.sql"

echo -e "\nCOMMENT ON COLUMN $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB}.FLAG_REJET IS 'Champ technique : Flag de rejet (insert or update)';
COMMENT ON COLUMN $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB}.TYP_MVT    IS 'Champ technique : Type de mouvement (I:Insert, U:Update, D:Delete';\n
" >> ${FOLDER_APP}${current_vers}${Repository_INS}/"${DOM}""_T_${Table_Name}.sql"
}

GENERATE_Vues_Anon()
{
  echo -e "REPLACE VIEW $""{IND_ODS_DISE_V_X}.V_${DOM}_${Table_Name} AS SELECT * FROM	$""{IND_ODS_DISE_V}.V_${DOM}_${Table_Name};
  ">> ${FOLDER_APP}${current_vers}${Repository_INS}/"Vues_Anon.sql"
}
#####EXECUT FUNCTIONS#####

echo -e "CURRENT GENERATION : SQL"

cat ${Liste_des_tables}|sed 1,1d | while read List_Line
do
##PARAMETERS
DOM=`echo ${List_Line}|cut -d"#" -f2|sed -e "s/ *$//"`
Table_Name=`echo ${List_Line}|cut -d"#" -f3|sed -e "s/ *$//"`;
Table_Comment=`echo ${List_Line}|cut -d"#" -f6|sed -e "s/ *$//"`;
Table_File=`echo ${List_Line}|cut -d"#" -f4`
Table_File="cfg/${Table_File}"
current_vers=`echo ${List_Line}|cut -d"#" -f1|sed -e "s/ *$//"`


if [ -e ${Table_File} ]
then
  echo -e "GENERAT SQL FILES ${Table_File}" >> FichierLog.${current_vers}.log

  GENERATE_IND_ALM_TABLE_Insert ;
  if [ $? -ne 0 ];then
    echo -e "##Erreur : GENERATE_IND_ALM_TABLE_Insert ${Table_File} Not successfully Generated##" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_IND_ALM_TABLE_Insert ${Table_File}  successfully Generated##" >> FichierLog.${current_vers}.log
  fi

  GENERATE_IND_ALM_TABLE_Delete ;
  if [ $? -ne 0 ];then
    echo -e "##Erreur : GENERATE_IND_ALM_TABLE_Delete ${Table_File} Not successfully Generated##" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_IND_ALM_TABLE_Delete ${Table_File}  successfully Generated##" >> FichierLog.${current_vers}.log
  fi

  GENERATE_IND_ALM_TABLE_Update ;
  if [ $? -ne 0 ];then
    echo -e "##Erreur : GENERATE_IND_ALM_TABLE_Update ${Table_File} Not successfully Generated##" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_IND_ALM_TABLE_Update ${Table_File}  successfully Generated##" >> FichierLog.${current_vers}.log
  fi

  GENERATE_IND_ALM_TABLE_Insert_DEL
  if [ $? -ne 0 ];then
    echo -e "##Erreur : GENERATE_IND_ALM_TABLE_Insert_DEL ${Table_File} Not successfully Generated##" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_IND_ALM_TABLE_Insert_DEL ${Table_File}  successfully Generated##" >> FichierLog.${current_vers}.log
  fi

  GENERATE_TABLE_schema
  if [ $? -ne 0 ];then
    echo -e "##Erreur : GENERATE_TABLE_schema ${Table_File} Not successfully Generated##" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_TABLE_schema ${Table_File}  successfully Generated##" >> FichierLog.${current_vers}.log
  fi

  GENERATE_DOM_TABLE
  if [ $? -ne 0 ];then
    echo -e "##Erreur : GENERATE_DOM_TABLE ${Table_File} Not successfully Generated##" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_DOM_TABLE ${Table_File}  successfully Generated##" >> FichierLog.${current_vers}.log
  fi

  GENERATE_V_DOM_TABLE
  if [ $? -ne 0 ];then
    echo -e "##Erreur : GENERATE_V_DOM_TABLE ${Table_File} Not Successfully Generated##" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_V_{DOM}_TABLE ${Table_File}  successfully Generated##">> FichierLog.${current_vers}.log
  fi

  GENERATE_DOM_T_TABLE
  if [ $? -ne 0 ];then
    echo -e "##Erreur : GENERATE_{DOM}_T_TABLE ${Table_File} Not successfully Generated##" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_{DOM}_T_TABLE ${Table_File}  successfully Generated##" >> FichierLog.${current_vers}.log
  fi

  GENERATE_Vues_Anon
  if [ $? -ne 0 ];then
    echo -e "##Erreur : GENERATE_Vues_Anon Not successfully Generated##" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_Vues_Anon  successfully Generated##" >> FichierLog.${current_vers}.log
  fi

else echo -e "\nGENERAT SQL FILES ${Table_File}${neutre}\n${Table_File} n'existe pas\n" >> FichierLog.${current_vers}.log
fi

done
echo -e "GENERATION DONE : SQL"
