#!/bin/ksh

###Créer les dossiers du package


cat Package_Versions.txt |uniq | while read versline
do
current_vers=${versline}

mkdir -p ${FOLDER_APP}${current_vers}/RCT_sandbox/dml
mkdir -p ${FOLDER_APP}${current_vers}/RCT_sandbox/xfr
mkdir -p ${FOLDER_APP}${current_vers}/sql/INS
mkdir -p ${FOLDER_APP}${current_vers}/sql/ALM
mkdir -p ${FOLDER_APP}${current_vers}/sql/CHG
mkdir -p ${FOLDER_APP}${current_vers}/sql/INS/data
mkdir -p ${FOLDER_APP}${current_vers}/sql/INS/vuesODS
mkdir -p ${FOLDER_APP}${current_vers}/sql/INS/tableODS
mkdir -p ${FOLDER_APP}${current_vers}/sql/INS/RA_${current_vers}
mkdir -p ${FOLDER_APP}${current_vers}/cfg/INS
mkdir -p ${FOLDER_APP}${current_vers}/cfg/INI
mkdir -p ${FOLDER_APP}${current_vers}/cfg/RCT
mkdir -p ${FOLDER_INST}${current_vers}/sh_install
mkdir -p ${FOLDER_APP}${current_vers}/java/cdc_check_subscriptions


done
#mkdir -p ${FOLDER_INST}/signatures/PA-OD1-M_INSTL-${Current_Vers}.SIG
##____

###Copier les fichiers non modifiables du package
cat Package_Versions.txt |uniq | while read versline
do
current_vers=${versline}
cp FIX/IND_ODS_cle_table.cfg ${FOLDER_APP}${current_vers}${Repository_CFG_RCT}
cp FIX/Listfic.cfg ${FOLDER_APP}${current_vers}${Repository_CFG_RCT}
cp FIX/IND_ODS_INI_Config_Dom.cfg ${FOLDER_APP}${current_vers}${Repository_CFG_INI}
cp  -r FIX/PA-OD1-M_INSTL-/cfg ${FOLDER_INST}${current_vers}
cp  -r FIX/PA-OD1-M_INSTL-/Log ${FOLDER_INST}${current_vers}
cp FIX/PA-OD1-M_INSTL-/IND_GEN_RA_install_GOROCO.ksh ${FOLDER_INST}${current_vers}/sh_install
cp FIX/PA-OD1-M_INSTL-/IND_GEN_Install_Version.ksh ${FOLDER_INST}${current_vers}/sh_install
##____

###Copier les fichiers et les renommer
cp FIX/PA-OD1-M_INSTL-/version_PRE_RA_INSTALLATION.ksh ${FOLDER_INST}${current_vers}/sh_install
cp FIX/PA-OD1-M_INSTL-/version_PRE_INSTALLATION.ksh ${FOLDER_INST}${current_vers}/sh_install
mv ${FOLDER_INST}${current_vers}/sh_install/version_PRE_RA_INSTALLATION.ksh  ${FOLDER_INST}${current_vers}/sh_install/${current_vers}_PRE_RA_INSTALLATION.ksh
mv ${FOLDER_INST}${current_vers}/sh_install/version_PRE_INSTALLATION.ksh  ${FOLDER_INST}${current_vers}/sh_install/${current_vers}_PRE_INSTALLATION.ksh.ksh
##____
done

