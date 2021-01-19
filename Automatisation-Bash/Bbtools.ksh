#!/bin/ksh
###check the number of parameters
[ $# -ne 2 ] && echo "[WARNING] : Le moteur prend en entrée 2 paramétres" && exit 1
##____
##Input parameters

export Liste_des_tables=$1
export Package=$2
##____

##Fichiers TEMP

awk -F '[[:space:]]*#[[:space:]]*' '(NR>1){ printf $1"\n"}' ${Liste_des_tables} > Package_Versions.txt
awk -F '[[:space:]]*#[[:space:]]*' '(NR>1){ printf $1"#"$10"\n"}' ${Liste_des_tables} > Package_Vers_IN.txt
##____
###Remove Package & Log if it exists
cat Package_Versions.txt |uniq | while read versline
do
current_vers=${versline}
if [ -e package ]; then
  rm -r package
fi
if [ -e FichierLog.${current_vers}.log ]; then
  rm -r FichierLog.${current_vers}.log
fi
done
##____






###Récupérer la version du package à générer et la version précédente
export FOLDER_APP="package/PA-OD1-M_APP-RD"
export FOLDER_INST="package/PA-OD1-M_INSTL-RD"
##____

##Remove  FichierLog.${urrent_Vers}.log if it exist
if [ -e FichierLog.${Current_Vers}.log ]; then
  rm -r FichierLog.${Current_Vers}.log
fi
##____


##Folders

##____
export Repository_DML="/RCT_sandbox/dml"
export Repository_XFR="/RCT_sandbox/xfr"
export Repository_ALM="/sql/ALM"
export Repository_CHG="/sql/CHG"
export Repository_INS="/sql/INS"
export Repository_TableODS="/sql/INS/tableODS"
export Repository_VuesODS="/sql/INS/vuesODS"
export Repository_DATA="/sql/INS/data"
export Repository_CFG_INS="/cfg/INS"
export Repository_CFG_INI="/cfg/INI"
export Repository_CFG_RCT="/cfg/RCT"
export Repository_RA="/sql/INS/RA_"
export Repository_SH_INSTALL="/sh_install"
export Repository_JAVA="/java/cdc_check_subscriptions"

## suffix & prefix Files
export PREFIX_SQL_ALM="IND_ODS_ALM_"

export PREFIX_DML_FICHIER="INSIDE_Fichier_"
export PREFIX_DML_TABLE="INSIDE_Table_"
export SUFFIX_DML_FICHIER="_Int"

export PREFIX_DML_NULL="rft_null_values_"
export PREFIX_XFR_INVALID="rft_invalides_values_"

export SUFFIX_SQL_Ins="_Insert"
export SUFFIX_SQL_InsDel="_Insert_Del"
export SUFFIX_SQL_Up="_Update"
export SUFFIX_SQL_Del="_Delete"

export SUFFIX_SQL_CGH="_schema"

export PREFIX_DATA_FILEA="data_PIL_R_FILE_APP_"
export PREFIX_DATA_RFILE="data_PIL_R_FILE_"
export PREFIX_DATA_RSTAT="data_PIL_R_STATS_"
export PREFIX_DATA_TABLEA="data_PIL_R_TABLE_APP_"
export PREFIX_DATA_REFTAB="data_PIL_REF_TAB_"
export PREFIX_DATA_TABCONF="data_PIL_TAB_CONFIG_"

export SUFFIX_RA="_RA"
export PREFIX_INST_INST="IND_"
export SUFFIX_INST_POST="_POST_INSTALLATION"
export SUFFIX_INST_POST_RA="_RA_POST_INSTALLATION"
##____

##les moteurs

GENERATE_FOLDERS="GENERATE_FOLDERS.ksh"
GENERATE_DML="GENERATE_DML.ksh"
GENERATE_XFR="GENERATE_XFR.ksh"
GENERATE_SQL="GENERATE_SQL.ksh"
GENERATE_TAB_PIL="GENERATE_TAB_PIL.ksh"
GENERATE_CFG="GENERATE_CFG.ksh"
GENERATE_TAB_PIL_RA="GENERATE_TAB_PIL_RA.ksh"
GENERATE_SH_INSTALL="GENERATE_SH_INSTALL.ksh"
GENERATE_JAVA="GENERATE_JAVA.ksh"
##____

###CREATE REPOSITORY
bash ${GENERATE_FOLDERS}
##____

###EXECUTION
case ${Package} in
"DML")
  bash $GENERATE_DML ${Liste_des_tables}
  if [ $? -ne 0 ]; then
    echo -e "##Erreur : DML Package Not Succsusfuly Generated##\n"
  else
    echo -e "##DML Package  Succsusfuly Generated##\n"

  fi
  ;;

"XFR")
  bash $GENERATE_XFR ${Liste_des_tables}
  if [ $? -ne 0 ]; then
    echo -e "##Erreur : XFR Package not Succsusfuly Generated##\n"
  else
    echo -e "##XFR Package  Succsusfuly Generated##\n"
  fi
  ;;

"SQL")
  bash $GENERATE_SQL ${Liste_des_tables}
  if [ $? -ne 0 ]; then
    echo -e "##SQL Package Succsusfuly Generated##\n"
  else
    echo -e "##SQL Package  Succsusfuly Generated##"
  fi
  ;;

"TAB_PIL")
  bash $GENERATE_TAB_PIL ${Liste_des_tables}
  if [ $? -ne 0 ]; then
    echo -e "##TABLES DE PILOTAGE Package Succsusfuly Generated##\n"
  else
    echo -e "##TABLES DE PILOTAGE  Package  Succsusfuly Generated##"
  fi
  ;;

"CFG")
  bash $GENERATE_CFG ${Liste_des_tables}
  if [ $? -ne 0 ]; then
    echo -e "##CFG Package Succsusfuly Generated##\n"
  else
    echo -e "##CFG Package  Succsusfuly Generated##\n"
  fi
  ;;
"TAB_PIL_RA")
  bash $GENERATE_TAB_PIL_RA ${Liste_des_tables}
  if [ $? -ne 0 ]; then
    echo -e "##TABLES DE PILOTAGE Package Succsusfuly Generated##\n"
  else
    echo -e "##TABLES DE PILOTAGE  Package  Succsusfuly Generated##"
  fi
  ;;

"JAVA")
  bash $GENERATE_JAVA ${Liste_des_tables}
  if [ $? -ne 0 ]; then
    echo -e "##java Package NOT Succsusfuly Generated##\n"
  else
    echo -e "##java Package  Succsusfuly Generated##"
  fi
  ;;

"ALL")
  bash $GENERATE_DML ${Liste_des_tables}
  bash $GENERATE_XFR ${Liste_des_tables}
  bash $GENERATE_SQL ${Liste_des_tables}
  bash $GENERATE_TAB_PIL ${Liste_des_tables}
  bash $GENERATE_CFG ${Liste_des_tables}
  bash $GENERATE_TAB_PIL_RA ${Liste_des_tables}
  bash $GENERATE_SH_INSTALL ${Liste_des_tables}
  bash $GENERATE_JAVA ${Liste_des_tables}

  if [ $? -ne 0 ]; then
    echo -e "## Package   NOT Succsusfuly Generated##\n"
  else
    echo -e "##ALL Package  Succsusfuly Generated##\n"
  fi
  ;;
*)
  echo -e "\n[WARNING]:Le choix du 2éme paramétre est incorrecte
[Info]:CFG : pour générer les composants cfg
       XFR : pour générer les composants xfr
       DML : pour générer les composants dml
       SQL : pour générer les composants sql
       TAB_PIL : pour générer les composants tables de pilotages
       TAB_PIL_RA : pour générer les composants du dossier de retour
       ALL : pour générer tout le package"
  echo -e ""
  ;;

esac
##____

rm -r Package_Versions.txt
rm -r Package_Vers_IN.txt