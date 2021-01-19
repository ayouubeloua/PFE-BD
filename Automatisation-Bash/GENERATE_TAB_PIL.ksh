#!/bin/ksh

#########Generate_Tableaux de Pilotage#########
    #########GENERATE_data_PIL_R_FILE_APP_VersPack#########

GENERATE_data_PIL_R_FILE_APP_VersPack_Del()
{ 

echo "Generate ${PREFIX_DATA_FILEA}${current_vers}.sql" >> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_R_FILE_APP WHERE APPLICATION_ID='1' AND FILE_CD='${FILE_CD}';
.IF ERRORCODE <> 0 THEN.QUIT ERRORCODE;" >>  ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_FILEA}${current_vers}.sql"
}
GENERATE_data_PIL_R_FILE_APP_VersPack_Ins()
{
echo -e "INSERT INTO $""{ALIM_IND_DISE}.PIL_R_FILE_APP (APPLICATION_ID, FILE_CD,MAX_FICHIER_NB, MIN_FICHIER_NB) VALUES('1','${FILE_CD}','','');
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">>  ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_FILEA}${current_vers}.sql"

}

    #########GENERATE_data_PIL_R_FILE_VersPack#########

GENERATE_data_PIL_R_FILE_VersPack_Del()
{
echo "Generate ${PREFIX_DATA_RFILE}${current_vers}.sql">> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_R_FILE WHERE FILE_CD='${FILE_CD}' AND FILE_DS='${Table_Name}.DYYYYMMDD.THHMMSSSEQ';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_RFILE}${current_vers}.sql"
}
GENERATE_data_PIL_R_FILE_VersPack_Ins()
{
echo -e "INSERT INTO $""{ALIM_IND_DISE}.PIL_R_FILE (FILE_CD,FILE_DS) VALUES ('${FILE_CD}','${Table_Name}.DYYYYMMDD.THHMMSSSEQ');
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;" >> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_RFILE}${current_vers}.sql"
}
    
    #########GENERATE_data_PIL_R_STATS_versPack#########

GENERATE_data_PIL_R_STATS_versPack_Del()
{
echo "Generate ${PREFIX_DATA_RSTAT}${current_vers}.sql">> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_R_STATS WHERE NOM_TAB='${DOM}""_${Table_Name}';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_RSTAT}${current_vers}.sql"
}
GENERATE_data_PIL_R_STATS_versPack_Ins()
{
echo -e "INSERT INTO $""{ALIM_IND_DISE}.PIL_R_STATS (NOM_TAB, BASE_NM, COLLECT_DAY_CD, TY_OBJ_COL_SN, COLLECT_TYP_CD, FREQ_IN, OBJ_COLL_NM) VALUES ('${DOM}""_${Table_Name}','IND_ODS_DISE','2','INDEX','NORMAL','W','NUPI_${DOM}""_${Table_Name}');
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;" >> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_RSTAT}${current_vers}.sql"
}

    #########GENERATE_data_PIL_R_TABLE_APP_VersPack#########

GENERATE_data_PIL_R_TABLE_APP_VersPack_Del()
{
echo "Generate ${PREFIX_DATA_TABLEA}${current_vers}.sql">> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_R_TABLE_APP WHERE APPLICATION_ID='3' AND NOM_TAB='${Table_Name}';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_TABLEA}${current_vers}.sql"
}
GENERATE_data_PIL_R_TABLE_APP_VersPack_Ins()
{
echo -e "INSERT INTO $""{ALIM_IND_DISE}.PIL_R_TABLE_APP (APPLICATION_ID, NOM_TAB, EXT_STABLE_IN, EXT_ORDRE_NU, EXT_RESTRICT_DS, EXT_ORDERBY_DS, EXT_GROUPBY_DS, EXT_HAVING_DS, EXT_FRAICH_IN, EXT_FRAICH_UN_CD) VALUES('3','${Table_Name}','','','','','','','','');
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;" >> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_TABLEA}${current_vers}.sql"
}

    #########GENERATE_data_PIL_REF_TAB_VersPack#########

GENERATE_data_PIL_REF_TAB_VersPack_Del()
{
echo "Generate ${PREFIX_DATA_REFTAB}${current_vers}.sql">> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_REF_TAB
WHERE NOM_TAB = '${Table_Name}';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;" >> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_REFTAB}${current_vers}.sql"
}
GENERATE_data_PIL_REF_TAB_VersPack_Ins()
{
echo -e "INSERT INTO $""{ALIM_IND_DISE}.PIL_REF_TAB (NOM_TAB, DEF_TAB)
VALUES ('${Table_Name}','${Table_Comment}');
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_REFTAB}${current_vers}.sql"
}

    ######### GENERATE_data_PIL_TAB_CONFIG_VersPack #########

GENERATE_data_PIL_TAB_CONFIG_VersPack_Del()
{
echo "Generate ${PREFIX_DATA_TABCONF}${current_vers}.sql">> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_TAB_CONFIG WHERE NOM_DOM = '${DOM}' AND NOM_TAB = '${Table_Name}';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_TABCONF}${current_vers}.sql"
}
GENERATE_data_PIL_TAB_CONFIG_VersPack_Ins()
{
echo -e "INSERT INTO $""{ALIM_IND_DISE}.PIL_TAB_CONFIG (NOM_DOM, NOM_TAB, NB_MAX_TMPN, PRIORITE_DOM, PRIORITE_TAB) VALUES ('${DOM}','${Table_Name}', 3, 1, 1);
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_TABCONF}${current_vers}.sql"
}

 ######### Write the headings #########

Head_File_data()
{

cat Package_Versions.txt |uniq | while read versline
do
current_vers=${versline}
echo -e "GENERAT Heads for Data Files" >> FichierLog.${current_vers}.log

echo -e "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_R_FILE_APP' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_FILEA}${versline}.sql"

echo -e "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES
WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_R_FILE' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_RFILE}${versline}.sql"

echo -e "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES
WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_R_STATS' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >>  ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_RSTAT}${versline}.sql"

echo -e "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES
WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_R_TABLE_APP' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_TABLEA}${versline}.sql"

echo -e "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES
WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_REF_TAB' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_REFTAB}${versline}.sql"

echo -e " LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_TAB_CONFIG' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_DATA}/"${PREFIX_DATA_TABCONF}${versline}.sql"

done

}

####EXECUT Functions####

Head_File_data ;


echo -e "CURRENT GENERATION : Tables_Pilotages"

###  LOOP FOR WRITING DELETE PART
cat ${Liste_des_tables} |sed 1,2d | while read List_Line
do
FILE_CD=`echo ${List_Line}| cut -d"#" -f5`
DOM=`echo ${List_Line}| cut -d"#" -f2|sed -e "s/ *$//"`
Table_Name=`echo ${List_Line}| cut -d"#" -f3|sed -e "s/ *$//"`
current_vers=`echo ${List_Line}| cut -d"#" -f1|sed -e "s/ *$//"`
Table_Comment=`echo ${List_Line}|cut -d"#" -f6|sed -e "s/ *$//"`;
Etat=`echo ${List_Line}|cut -d"#" -f8|sed -e "s/ *$//"`
Table_File=`echo ${List_Line}|cut -d"#" -f4`
Table_File="cfg/${Table_File}"
if [ -e ${Table_File} ]
then
 echo -e "GENERAT TABLES-PILOTAGE  ${Table_File}"  >> FichierLog.${current_vers}.log
if [ ${Etat} != "old" ]; then
 GENERATE_data_PIL_R_FILE_APP_VersPack_Del ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_R_FILE_APP_VersPack_Del Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_R_FILE_APP_VersPack_Del  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_data_PIL_R_FILE_VersPack_Del ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_R_FILE_VersPack_Del Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_R_FILE_VersPack_Del  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_data_PIL_R_STATS_versPack_Del ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_R_STATS_versPack_Del Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_R_STATS_versPack_Del  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_data_PIL_R_TABLE_APP_VersPack_Del ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_R_TABLE_APP_VersPack_Del Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_R_TABLE_APP_VersPack_Del  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_data_PIL_REF_TAB_VersPack_Del ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_REF_TAB_VersPack_Del Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_REF_TAB_VersPack_Del  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_data_PIL_TAB_CONFIG_VersPack_Del ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_TAB_CONFIG_VersPack_Del Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_TAB_CONFIG_VersPack_Del  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

else echo -e "GENERAT TABLES-PILOTAGE ${Table_File}\n${Table_File} n'existe pas" >> FichierLog.${current_vers}.log
fi
fi
done

###  LOOP FOR WRITING INSERT PART

cat ${Liste_des_tables} |sed 1,2d | while read List_Line
do
FILE_CD=`echo ${List_Line}| cut -d"#" -f5`
DOM=`echo ${List_Line}| cut -d"#" -f2|sed -e "s/ *$//"`
Table_Name=`echo ${List_Line}| cut -d"#" -f3|sed -e "s/ *$//"`
current_vers=`echo ${List_Line}| cut -d"#" -f1|sed -e "s/ *$//"`
Table_Comment=`echo ${List_Line}|cut -d"#" -f6|sed -e "s/ *$//"`;
Etat=`echo ${List_Line}|cut -d"#" -f8|sed -e "s/ *$//"`
Table_File=`echo ${List_Line}|cut -d"#" -f4`
Table_File="cfg/${Table_File}"
if [ -e ${Table_File} ]; then
 echo -e "GENERAT TABLES-PILOTAGE  ${Table_File}"  >> FichierLog.${current_vers}.log
if [ ${Etat} != "old" ]; then

 GENERATE_data_PIL_R_FILE_APP_VersPack_Ins ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_R_FILE_APP_VersPack_Ins Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_R_FILE_APP_VersPack_Ins  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi
GENERATE_data_PIL_R_FILE_VersPack_Ins ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_R_FILE_VersPack_Ins Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_R_FILE_VersPack_Ins  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_data_PIL_R_STATS_versPack_Ins ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_R_STATS_versPack_Ins Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_R_STATS_versPack_Ins  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_data_PIL_R_TABLE_APP_VersPack_Ins ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_R_TABLE_APP_VersPack_Ins Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_R_TABLE_APP_VersPack_Ins  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_data_PIL_REF_TAB_VersPack_Ins ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_REF_TAB_VersPack_Ins Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_REF_TAB_VersPack_Ins  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

 GENERATE_data_PIL_TAB_CONFIG_VersPack_Ins ;
 if [ $? -ne 0 ];then
  echo -e "##Erreur : GENERATE_data_PIL_TAB_CONFIG_VersPack_Ins Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  else echo -e "##GENERATE_data_PIL_TAB_CONFIG_VersPack_Ins  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 fi

else echo -e "GENERAT TABLES-PILOTAGE ${Table_File}\n${Table_File} n'existe pas" >> FichierLog.${current_vers}.log
fi
fi
done

echo -e "GENERAT DONE : Tables_Pilotages"
