#!/bin/ksh  


### Si nombre de param�tres diff�rent de 1, on, sort
if [ $# = 0 ] && [ "`echo $VERSION`" = "" ]; then
   echo "------------------------------------------------------------------------------------------"
   echo "1 argument attendu pour ce script : le N� de la version si variable VERSION non positionn�"
   echo "------------------------------------------------------------------------------------------"
   exit 0
fi

# Affectation de version si cette variable est vide
if [ "`echo $VERSION`" = "" ]; then
   VERSION=$1
fi
# V�rification de l'existance du fichier de configuration'
dir=$(pwd)
CONFIG="${dir}/../cfg/IND_GEN_variables.conf" 
[ ! -e ${CONFIG} ] && echo "ERREUR: Le fichier de configuration ${CONFIG} n'existe pas" && exit 1

if [ -r ${CONFIG} ]; then
  . ${CONFIG}
fi

### Initialisation des variables de log associ�
LOGFILE=${fichierLogPreInstall}

### Si les fichiers de log des r�pertoires existe, ils sont supprim�s
if [ -e $LOGFILE ]; then
  rm -f $LOGFILE
fi

## Les r�pertoires � nettoyer dans le cadre de l'installation:

for REP in /opt/application/od1cdc/current/RCT_sandbox/run/ \
           /opt/application/od1cdc/current/INI_sandbox/run/ \
           /opt/application/od1cdc/current/ALM_sandbox/run/ \
		   
do
  echo "######### Nettoyage des fichiers contenus dans le repertoire ${REP}" | tee -a $LOGFILE
  find ${REP} -type p -user $(id opod1cdc | awk -F "=" '{print $2}' | awk -F "(" '{print $1}') -delete
  find ${REP} -type f -user $(id opod1cdc | awk -F "=" '{print $2}' | awk -F "(" '{print $1}') -delete
  find ${REP} -type d -user $(id opod1cdc | awk -F "=" '{print $2}' | awk -F "(" '{print $1}') -delete
  
    if [ $? != 0 ]; then
     echo "######### ERREUR lors du nettoyage du r�pertoire ${REP}" | tee -a $LOGFILE 
     echo "#########"
     exit 1
    else
     echo "OK Ex�cution avec succ�s" | tee -a $LOGFILE
     echo "#########"
    fi
done


for REP in /var/opt/data/flat/od1cdc/files/data/tmp/RCT \
           /var/opt/data/flat/od1cdc/files/data/tmp/CHG \
		   /var/opt/data/flat/od1cdc/files/data/tmp/ALM \
		   /var/opt/data/flat/od1cdc/files/data/tmp/DIF \
		   /var/opt/data/flat/od1cdc/files/data/tmp/EXT \
		   
do
  echo "######### Nettoyage des fichiers contenus dans le repertoire ${REP}" | tee -a $LOGFILE
  find ${REP} -type f -user $(id opod1cdc | awk -F "=" '{print $2}' | awk -F "(" '{print $1}') -delete
    if [ $? != 0 ]; then
     echo "######### ERREUR lors du nettoyage du r�pertoire ${REP}" | tee -a $LOGFILE 
     echo "#########"
     exit 1
    else
     echo "OK Ex�cution avec succ�s" | tee -a $LOGFILE
     echo "#########"
    fi
done




exit 0
