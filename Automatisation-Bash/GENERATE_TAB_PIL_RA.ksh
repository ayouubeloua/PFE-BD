#!/bin/ksh

GENERATE_DOM_TABLE_RA()
{
echo -e "Generate ${DOM}_${Table_Name}_RA.sql" >> FichierLog.${current_vers}.log

echo -e "-- -------------------------------------------------
--  SUPPRESSION - TABLES $""{IND_ODS_DISE}.${DOM}_${Table_Name}
-- -------------------------------------------------\n" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${DOM}_${Table_Name}.sql"
echo -e ".export file = '$""{IND_ODS_GEN_FILES}/data/tmp/INS/drop_${DOM}_${Table_Name}.tmp',close;
LOCKING ROW FOR ACCESS
SELECT 'DROP TABLE '||trim(DATABASENAME)||'.'||trim(TABLENAME)||';' (title '')
FROM DBC.TABLES
WHERE DATABASENAME = '$""{IND_ODS_DISE}' AND  TABLENAME = '${DOM}_${Table_Name}' AND TABLEKIND = 'T';
.export reset;
.run file '$""{IND_ODS_GEN_FILES}/data/tmp/INS/drop_${DOM}_${Table_Name}.tmp';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${DOM}_${Table_Name}.sql"

echo -e "-- -------------------------------------------------
--  SUPPRESSION - TABLES $""{IND_TMP_DISE}.${DOM}_T_${Table_Name}_$""{NB}
-- -------------------------------------------------\n" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${DOM}_${Table_Name}.sql"
echo -e ".export file = '$""{IND_ODS_GEN_FILES}/data/tmp/INS/drop_${DOM}_T_${Table_Name}.tmp',close;
LOCKING ROW FOR ACCESS
SELECT 'DROP TABLE '||trim(DATABASENAME)||'.'||trim(TABLENAME)||';' (title '')
FROM DBC.TABLES
WHERE DATABASENAME = '$""{IND_TMP_DISE}' AND  TABLENAME LIKE '%${DOM}_T_${Table_Name}_%' AND TABLEKIND = 'T';
.export reset;
.run file '$""{IND_ODS_GEN_FILES}/data/tmp/INS/drop_${DOM}_T_${Table_Name}.tmp';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${DOM}_${Table_Name}.sql"

echo -e "-- -------------------------------------------------
--  SUPPRESSION - TABLES $""{IND_ODS_DISE_V}.V_${DOM}_${Table_Name}
-- -------------------------------------------------\n" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${DOM}_${Table_Name}.sql"
echo -e ".export file = '$""{IND_ODS_GEN_FILES}/data/tmp/INS/drop_V_${DOM}_${Table_Name}.tmp',close;
LOCKING ROW FOR ACCESS
SELECT 'DROP VIEW '||trim(DATABASENAME)||'.'||trim(TABLENAME)||';' (title '')
FROM DBC.TABLES
WHERE DATABASENAME = '$""{IND_ODS_DISE_V}' AND  TABLENAME = 'V_${DOM}_${Table_Name}' AND TABLEKIND = 'V';
.export reset;
.run file '$""{IND_ODS_GEN_FILES}/data/tmp/INS/drop_V_${DOM}_${Table_Name}.tmp';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;
.quit 0" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${DOM}_${Table_Name}.sql"
}
    #########GENERATE_data_PIL_R_FILE_VersPack_RA#########
GENERATE_data_PIL_R_FILE_APP_VersPack_RA()
{
echo "Generate ${PREFIX_DATA_FILEA}${current_vers}_RA.sql" >> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_R_FILE_APP WHERE APPLICATION_ID='1' AND FILE_CD='${FILE_CD}';
.IF ERRORCODE <> 0 THEN.QUIT ERRORCODE;" >>  ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_FILEA}${current_vers}${SUFFIX_RA}.sql"
}


    #########GENERATE_data_PIL_R_FILE_VersPack#########
GENERATE_data_PIL_R_FILE_VersPack_RA()
{
echo "Generate ${PREFIX_DATA_RFILE}${current_vers}_RA.sql">> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_R_FILE WHERE FILE_CD='${FILE_CD}' AND FILE_DS='${Table_Name}.DYYYYMMDD.THHMMSSSEQ';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_RFILE}${current_vers}${SUFFIX_RA}.sql"
}


    #########GENERATE_data_PIL_R_STATS_versPack#########

GENERATE_data_PIL_R_STATS_versPack_RA()
{
echo "Generate ${PREFIX_DATA_RSTAT}${current_vers}_RA.sql">> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_R_STATS WHERE NOM_TAB='${DOM}_${Table_Name}';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_RSTAT}${current_vers}${SUFFIX_RA}.sql"
}


    #########GENERATE_data_PIL_R_TABLE_APP_VersPack#########

GENERATE_data_PIL_R_TABLE_APP_VersPack_RA()
{
echo "Generate ${PREFIX_DATA_TABLEA}${current_vers}_RA.sql">> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_R_TABLE_APP WHERE APPLICATION_ID='3' AND NOM_TAB='${Table_Name}';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;">> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_TABLEA}${current_vers}${SUFFIX_RA}.sql"
}

    #########GENERATE_data_PIL_REF_TAB_VersPack#########

GENERATE_data_PIL_REF_TAB_VersPack_RA()
{
echo "Generate ${PREFIX_DATA_REFTAB}${current_vers}_RA.sql">> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_REF_TAB
WHERE NOM_TAB = '${Table_Name}';
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_REFTAB}${current_vers}${SUFFIX_RA}.sql"
}


    ######### GENERATE_data_PIL_TAB_CONFIG_VersPack #########

GENERATE_data_PIL_TAB_CONFIG_VersPack_RA()
{
echo "Generate ${PREFIX_DATA_TABCONF}${current_vers}_RA.sql">> FichierLog.${current_vers}.log
echo -e "DELETE FROM $""{ALIM_IND_DISE}.PIL_TAB_CONFIG WHERE NOM_DOM = '${DOM}' AND NOM_TAB = '${Table_Name}'AND NB_MAX_TMPN = 3 AND PRIORITE_DOM = 1 AND PRIORITE_TAB = 1;">> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_TABCONF}${current_vers}${SUFFIX_RA}.sql"
}


Head_File_RA()
{

cat Package_Versions.txt |uniq | while read versline
do
current_vers=${versline}
echo -e "GENERAT Heads for RA_VERSION" >> FichierLog.${current_vers}.log

echo -e "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES
 WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_R_FILE_APP' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_FILEA}${versline}${SUFFIX_RA}.sql"

echo -e "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES
WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_R_FILE' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_RFILE}${versline}${SUFFIX_RA}.sql"

echo -e "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES
WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_R_STATS' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >>  ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_RSTAT}${versline}${SUFFIX_RA}.sql"

echo -e "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES
WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_R_TABLE_APP' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_TABLEA}${versline}${SUFFIX_RA}.sql"

echo -e "LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES
WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_REF_TAB' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_REFTAB}${versline}${SUFFIX_RA}.sql"

echo -e " LOCKING ROW FOR ACCESS
SELECT DISTINCT TABLENAME FROM DBC.TABLES WHERE DATABASENAME='$""{ALIM_IND_DISE}' AND TABLENAME='PIL_TAB_CONFIG' AND TABLEKIND='T';
.IF ACTIVITYCOUNT = 0 THEN .QUIT ERRORCODE;\n" >> ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers}/"${PREFIX_DATA_TABCONF}${versline}${SUFFIX_RA}.sql"

done
}
###EXECUT FUNCTIONS####
Head_File_RA ;
echo -e "CURRENT GENERATION : TAB_PIL_RA"

cat ${Liste_des_tables} |sed 1,1d | while read List_Line
do
##PARAMETERS
Table_Name=`echo $List_Line|cut -d"#" -f3|sed -e "s/ *$//"`
DOM=`echo $List_Line|cut -d"#" -f2|sed -e "s/ *$//"`
FILE_CD=`echo ${List_Line}| cut -d"#" -f5`
current_vers=`echo ${List_Line}| cut -d"#" -f1|sed -e "s/ *$//"`
Table_File=`echo ${List_Line}|cut -d"#" -f4`
Table_File="cfg/${Table_File}"


if [ -e ${Table_File} ];then
  echo -e "GENERAT TAB_PIL_RA ${Table_File}" >> FichierLog.${current_vers}.log

  GENERATE_DOM_TABLE_RA ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_DOM_TABLE_RA Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_DOM_TABLE_RA  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  fi

  GENERATE_data_PIL_R_FILE_APP_VersPack_RA ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_data_PIL_R_FILE_APP_VersPack_RA Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_data_PIL_R_FILE_APP_VersPack_RA  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  fi

  GENERATE_data_PIL_R_FILE_VersPack_RA ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_data_PIL_R_FILE_VersPack_RA Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_data_PIL_R_FILE_VersPack_RA  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  fi

  GENERATE_data_PIL_R_STATS_versPack_RA ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_data_PIL_R_STATS_versPack_RA Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_data_PIL_R_STATS_versPack_RA  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  fi

  GENERATE_data_PIL_R_TABLE_APP_VersPack_RA ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_data_PIL_R_TABLE_APP_VersPack_RA Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_data_PIL_R_TABLE_APP_VersPack_RA  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  fi

  GENERATE_data_PIL_REF_TAB_VersPack_RA ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_data_PIL_REF_TAB_VersPack_RA Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_data_PIL_REF_TAB_VersPack_RA  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  fi

  GENERATE_data_PIL_TAB_CONFIG_VersPack_RA ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_data_PIL_TAB_CONFIG_VersPack_RA Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_data_PIL_TAB_CONFIG_VersPack_RA  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  fi

else echo -e "GENERAT TAB_PIL_RA ${Table_File}\n${Table_File} n'existe pas\n" >> FichierLog.${current_vers}.log
fi

done
echo -e "GENERATION DONE : TAB_PIL_RA"
