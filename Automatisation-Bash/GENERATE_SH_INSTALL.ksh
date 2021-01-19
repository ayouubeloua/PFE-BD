 #!/bin/ksh

GENERATE_IND_VERSION_POST_INSTALLATION()
{
echo -e "Generate IND_VERSION_POST_INSTALLATION.ksh" >> FichierLog.${current_vers}.log

echo -n "#!/bin/ksh
##
# ${current_vers}_POST_INSTALLATION.ksh
#  Script post install de la version ${current_vers}
##

# Vérification de l'existence du fichier de configuration
dir=$""(pwd)
CONFIG=\"$""{dir}/../cfg/IND_GEN_variables.conf\"
[ ! -e $""{CONFIG} ] && echo \"ERREUR: Le ficher de configuration $""{CONFIG} n'existe pas\" && exit 1

if [ -r $""{CONFIG} ]; then
  . $""{CONFIG}
fi

### Initialisation des variables de log associé
LOGFILE=$""{fichierLogPostInstall}

### Si les fichiers de log existent, ils sont supprimés
if [ -e $""LOGFILE ]; then
  rm -f $""LOGFILE
fi

#Sauvegarde des fichiers de configurations existants
#Fichier à modifier dans POST_INSTALLATION - APPEND

cp -fp /opt/application/od1cdc/G02R02C05/cfg/INI/IND_ODS_INI_Config_Table.cfg /opt/application/od1cdc/current/cfg/INI/IND_ODS_INI_Config_Table.cfg.G02R02C05
[ $""? -ne 0 ] && exit 1
#Fichier deployé par le tar
#Fichier à modifier dans POST_INSTALLATION - APPEND

cp -fp /opt/application/od1cdc/G02R02C05/cfg/RCT/IND_ODS_cle_table.cfg /opt/application/od1cdc/current/cfg/RCT/IND_ODS_cle_table.cfg.G02R02C05
[ $""? -ne 0 ] && exit 1
#Fichier à modifier dans POST_INSTALLATION - APPEND

cp -fp /opt/application/od1cdc/${Past_Vers}/cfg/RCT/Listfic.cfg /opt/application/od1cdc/current/cfg/RCT/Listfic.cfg.${Past_Vers}
[ $""? -ne 0 ] && exit 1

#Mise à jour des fichiers de configurations INI / INS / RCT


cp -fp /opt/application/od1cdc/current/cfg/INI/IND_ODS_INI_Config_Table.cfg.${Past_Vers} /opt/application/od1cdc/current/cfg/INI/IND_ODS_INI_Config_Table.cfg
[ $""? -ne 0 ] && exit 1
cat /opt/application/od1cdc/current/cfg/INI/IND_ODS_INI_Config_Table.cfg.${current_vers} >> /opt/application/od1cdc/current/cfg/INI/IND_ODS_INI_Config_Table.cfg
[ $""? -ne 0 ] && exit 1
sed -i '/^$/d' /opt/application/od1cdc/current/cfg/INI/IND_ODS_INI_Config_Table.cfg
[ $""? -ne 0 ] && exit 1
rm -rf /opt/application/od1cdc/current/cfg/INI/IND_ODS_INI_Config_Table.cfg.${current_vers}
[ $""? -ne 0 ] && exit 1

cp -fp /opt/application/od1cdc/current/cfg/RCT/IND_ODS_cle_table.cfg.${Past_Vers} /opt/application/od1cdc/current/cfg/RCT/IND_ODS_cle_table.cfg
[ $""? -ne 0 ] && exit 1
cat /opt/application/od1cdc/current/cfg/RCT/IND_ODS_cle_table.cfg.${current_vers} >> /opt/application/od1cdc/current/cfg/RCT/IND_ODS_cle_table.cfg
[ $""? -ne 0 ] && exit 1
sed -i '/^$/d' /opt/application/od1cdc/current/cfg/RCT/IND_ODS_cle_table.cfg
[ $""? -ne 0 ] && exit 1
rm -rf /opt/application/od1cdc/current/cfg/RCT/IND_ODS_cle_table.cfg.${current_vers}
[ $""? -ne 0 ] && exit 1

cp -fp /opt/application/od1cdc/current/cfg/RCT/Listfic.cfg.${Past_Vers} /opt/application/od1cdc/current/cfg/RCT/Listfic.cfg
[ $""? -ne 0 ] && exit 1
cat /opt/application/od1cdc/current/cfg/RCT/Listfic.cfg.${current_vers} >> /opt/application/od1cdc/current/cfg/RCT/Listfic.cfg
[ $""? -ne 0 ] && exit 1
sed -i '/^$/d' /opt/application/od1cdc/current/cfg/RCT/Listfic.cfg
[ $""? -ne 0 ] && exit 1
rm -rf /opt/application/od1cdc/current/cfg/RCT/Listfic.cfg.${current_vers}
[ $""? -ne 0 ] && exit

## Installation des composants base de données
for SQL in " >> ${FOLDER_INST}${current_vers}${Repository_SH_INSTALL}/${PREFIX_INST_INST}${current_vers}${SUFFIX_INST_POST}".ksh"

F_DATA=$(ls ${FOLDER_APP}${current_vers}${Repository_DATA})

for file in ${F_DATA}
do
echo -e "\t/opt/application/od1cdc/${current_vers}/sql/INS/data/${file} \ " >> ${FOLDER_INST}${current_vers}${Repository_SH_INSTALL}/${PREFIX_INST_INST}${current_vers}${SUFFIX_INST_POST}".ksh"
done


F_TABLE=$(ls ${FOLDER_APP}${current_vers}${Repository_TableODS})
for file in ${F_TABLE}
do
echo -e "\t /opt/application/od1cdc/${current_vers}/sql/INS/tableODS/${file} \ ">> ${FOLDER_INST}${current_vers}${Repository_SH_INSTALL}/${PREFIX_INST_INST}${current_vers}${SUFFIX_INST_POST}".ksh"
done

F_VUE=$(ls ${FOLDER_APP}${current_vers}${Repository_VuesODS})
nb_fichiers=`ls ${FOLDER_APP}${current_vers}${Repository_VuesODS} | wc -l`
j=0
for file in ${F_VUE}
do
j=$(($j + 1))
    if [ $j == ${nb_fichiers} ]; then
      echo -e " \t/opt/application/od1cdc/${current_vers}/sql/INS/vuesODS/${file} " >> ${FOLDER_INST}${current_vers}${Repository_SH_INSTALL}/${PREFIX_INST_INST}${current_vers}${SUFFIX_INST_POST}".ksh"
    else  echo -e " \t/opt/application/od1cdc/${current_vers}/sql/INS/vuesODS/${file} \ " >> ${FOLDER_INST}${current_vers}${Repository_SH_INSTALL}/${PREFIX_INST_INST}${current_vers}${SUFFIX_INST_POST}".ksh"
    fi
done

echo -e "
do
  if [ -e /opt/application/od1cdc/current/sh/INS/IND_ODS_INS_Installation_SQL.ksh ]; then
   echo \"######### Exécution du script ${SQL}\" | tee -a $""{LOGFILE}
   /opt/application/od1cdc/current/sh/INS/IND_ODS_INS_Installation_SQL.ksh $""{SQL}

    if [ $""? != 0 ]; then
     echo \"######### ERREUR lors de l'exécution du script $""{SQL}\"| tee -a $""{LOGFILE}
     echo \"######### Resultat KO\" | tee -a $""{LOGFILE}
         echo \"######### Vérifier le fichier log d'erreur /opt/application/od1cdc/logs/detail/INS/INSTALLATION-<date du jour>\"
     exit 1
    else
     echo \"OK Exécution avec succès\" | tee -a $""{LOGFILE}
     echo \"#########\" | tee -a $""{LOGFILE}
    fi
  else
    echo \"######### Aucun fichier /opt/application/od1cdc/current/sh/INS/IND_ODS_INS_Installation_SQL.ksh detecte\" | tee -a $""{LOGFILE}
  fi
done

exit 0" >> ${FOLDER_INST}${current_vers}${Repository_SH_INSTALL}/${PREFIX_INST_INST}${current_vers}${SUFFIX_INST_POST}".ksh"
}

####RA
GENERATE_IND_VERSION_RA_POST_INSTALLATION()
{
echo -e "Generate IND_VERSION_RA_POST_INSTALLATION.ksh" >> FichierLog.${current_vers}.log

echo -n "#!/bin/ksh
##
# ${current_vers}_RA_POST_INSTALLATION.ksh
#  Script post retour arriere de la version ${current_vers}
##

# Vérification de l'existence du fichier de configuration
dir=$""(pwd)
CONFIG=\"$""{dir}/../cfg/IND_GEN_variables.conf\"
[ ! -e $""{CONFIG} ] && echo \"ERREUR: Le ficher de configuration $""{CONFIG} n'existe pas\" && exit 1

if [ -r $""{CONFIG} ]; then
  . $""{CONFIG}
fi

### Initialisation des variables de log associé
LOGFILE=$""{fichierLogPostDeInstall}

### Si les fichiers de log existent, ils sont supprimés
if [ -e $""LOGFILE ]; then
  rm -f $""LOGFILE
fi
LOGFILE=${LOGFILE}
## Installation des composants base de données
for SQL in " >> ${FOLDER_INST}${current_vers}${Repository_SH_INSTALL}/${PREFIX_INST_INST}${current_vers}${SUFFIX_INST_POST_RA}".ksh"

F_DATA=$(ls ${FOLDER_APP}${current_vers}${Repository_RA}${current_vers})

for file in ${F_DATA}
do
echo -e "\t/opt/application/od1cdc/${current_vers}/sql/INS/RA_${current_vers}/${file}\ " >> ${FOLDER_INST}${current_vers}${Repository_SH_INSTALL}/${PREFIX_INST_INST}${current_vers}${SUFFIX_INST_POST_RA}".ksh"
done

echo -e "
do
  if [ -e /opt/application/od1cdc/current/sh/INS/IND_ODS_INS_Installation_SQL.ksh ]; then
   echo \"######### Exécution du script ${SQL}\" | tee -a $""{LOGFILE}
   /opt/application/od1cdc/current/sh/INS/IND_ODS_INS_Installation_SQL.ksh $""{SQL}

    if [ $""? != 0 ]; then
     echo \"######### ERREUR lors de l'exécution du script \" | tee -a $""{LOGFILE}
     echo \"######### Resultat KO\" | tee -a $""{LOGFILE}
         echo \"######### Vérifier le fichier log d'erreur /opt/applcation/od1cdc/logs/detail/INS/INSTALLATION-<date du jour>\"
     exit 1
    else
     echo \"OK Exécution avec succès\" | tee -a $""{LOGFILE}
     echo \"#########\" | tee -a $""{LOGFILE}
    fi
  else
    echo \"######### Aucun fichier /opt/application/od1cdc/current/sh/INS/IND_ODS_INS_Installation_SQL.ksh detecte\" | tee -a $""{LOGFILE}
  fi
done

exit 0" >> ${FOLDER_INST}${current_vers}${Repository_SH_INSTALL}/${PREFIX_INST_INST}${current_vers}${SUFFIX_INST_POST_RA}".ksh"
}
###EXECUT FUNCTIONS####
#############################################
echo -e "CURRENT GENERATION : SH_INSTALL"

##PARAMETERS
#---
cat Package_Vers_IN.txt |uniq | while read versline
do
current_vers=`echo ${versline}|cut -d"#" -f1|sed -e "s/ *$//"`;
Past_Vers=`echo ${versline}|cut -d"#" -f12|sed -e "s/ *$//"`;

  echo -e "GENERAT SH_INSTALL" >> FichierLog.${current_vers}.log

  GENERATE_IND_VERSION_POST_INSTALLATION ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_IND_VERSION_POST_INSTALLATION Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_IND_VERSION_POST_INSTALLATION  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  fi
  GENERATE_IND_VERSION_RA_POST_INSTALLATION ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_IND_VERSION_RA_POST_INSTALLATION Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_IND_VERSION_RA_POST_INSTALLATION  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
  fi
done


echo -e "GENERATION DONE : SH_INSTALL"
