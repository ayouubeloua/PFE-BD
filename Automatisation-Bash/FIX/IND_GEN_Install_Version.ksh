#!/bin/ksh  

# *******************************************************************                              
# ** Systeme technique : INSIDE                                                       
# ** Logiciel (Module)    : Générique                                                              
# *******************************************************************                              
# ** Fichier           : IND_GEN_Install_Version.ksh                                                     
# ** Auteur            : AtoS                                                                
# ** Date de creation  : Aout 2016                                                                 
# ** Description :      Script d'installation                                                                    
# **                                     
# *******************************************************************                              
# ** Version     Aut  Description                                                                  
# ** ==========  ===  ===============================================                              
# ** 00.01       AtoS  Creation                                                                     
# *******************************************************************                              
#                

#############################################################################
 #######                            #      ##                            
  ##   #                           ##                                    
  ## #    ####   #####    ####    #####   ###     ####   #####    #####  
  ####   ##  ##  ##  ##  ##  ##    ##      ##    ##  ##  ##  ##  ##      
  ## #   ##  ##  ##  ##  ##        ##      ##    ##  ##  ##  ##   ####   
  ##     ##  ##  ##  ##  ##  ##    ## #    ##    ##  ##  ##  ##      ##  
 ####     ####   ##  ##   ####      ##    ####    ####   ##  ##  #####   
############################################################################

function ecritureLogInstall
{
	message="$1"
	
	print "$message" | tee -a $LOG
}

function CreeRep
{
  mkdir -p $1 > /dev/null 
  if [ $? != 0 ]; then
	  ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	  exit 1
  else
	  ecritureLogInstall "***** Resultat OK                                     ***"
  fi
}

#############################################################################
 ##  ##                    ##            ###      ###                    
 ##  ##                                   ##       ##                    
 ##  ##   ####   ## ###   ###     ####    ##       ##     ####    #####  
 ##  ##      ##   ### ##   ##        ##   #####    ##    ##  ##  ##      
 ##  ##   #####   ##  ##   ##     #####   ##  ##   ##    ######   ####   
  ####   ##  ##   ##       ##    ##  ##   ##  ##   ##    ##          ##  
   ##     ### ## ####     ####    ### ## ## ###   ####    ####   #####   
#############################################################################

dir=$(pwd)

### Vérification lancement
# Récupération des arguments du scrip
typeset Facility=$0
typeset facility=$(basename ${Facility})

### Vérification lancement
# Récupération des arguments du scrip
NB_ARGS=$#

##[ ${NB_ARGS} -ne 4 ] && ecritureLogInstall "Mauvais nombre d'argument" && exit 1
[ ${NB_ARGS} -ne 4 ] && print "Mauvais nombre d'argument" && print "USAGE : IND_GEN_Install_Version.ksh -p <new_version> -a <old_version>" && exit 1

while getopts :p:a: opt
do
case ${opt} in
	p)
		  POST_VERSION=$OPTARG;;
	a)
		  ANT_VERSION=$OPTARG
		  if [[ "$ANT_VERSION" == "INIT" ]]
		  then
			  INIT=1
		  else
			  INIT=0
		  fi
		  ;;
	\?)
		  print "argument Inconnu"
          exit 1;;
esac
done

## Fichier de configuration d'installation
. $dir/../cfg/IND_GEN_Config_Install.cfg

#Fichier de log
DateTimeTrtDVC=$(date "+%Y%m%d%H%M%S")
LOG="$EMPLACEMENT_PACKAGES/${POST_VERSION}/Log/Installation_Inside_CDC_${POST_VERSION}_$(date +%Y%m%d%H%M%S).log"

mkdir $EMPLACEMENT_PACKAGES/${POST_VERSION}/Log 2>/dev/null
chmod 777 $EMPLACEMENT_PACKAGES/${POST_VERSION}/Log 2>/dev/null

#############################################################################
#####           ###               #    
 ## ##           ##              ##    
 ##  ##   ####   ##     ##  ##  #####  
 ##  ##  ##  ##  #####  ##  ##   ##    
 ##  ##  ######  ##  ## ##  ##   ##    
 ## ##   ##      ##  ## ##  ##   ## #  
#####     ####  ## ###   ### ##   ##   
#############################################################################


### Controle du user d'install

ecritureLogInstall "*********************************************************"
ecritureLogInstall "**** Installation du package pour la $POST_VERSION     **"
ecritureLogInstall "**** le  $DateTimeTrtDVC"
ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Controle des pre-requis                         ***"
ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Operation 1.1 : controle du user                ***"
ecritureLogInstall "*********************************************************"

if [ "$user" = "$compte_install" ];
then 
	ecritureLogInstall "***** utilisateur courant : $compte_install  : OK                ***"
	ecritureLogInstall "*********************************************************"

else    
	ecritureLogInstall "***** ERREUR le user actuel est :  $user         "       
	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "***** ERREUR vous n'utilise pas le bon user           ***"
	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "***** Le script va être arreté : Lire le MOI svp !   ****"
	ecritureLogInstall "*********************************************************"
	exit 1
fi

### Controle du chemin d'exécution

ecritureLogInstall "********************************************************"
ecritureLogInstall "***** Operation 1.2 : controle du chemin courant      ***"
ecritureLogInstall "*********************************************************"		

########cd $EMPLACEMENT_PACKAGES/${POST_VERSION}/sh_install 2>/dev/null
cd $EMPLACEMENT_PACKAGES/${POST_VERSION}/sh_install
chemin=$(pwd)

if [[ "$chemin" == "${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install" ]]
then 
	ecritureLogInstall "***** chemin courant : $chemin"
	ecritureLogInstall "***** Resultat OK                                "       
	ecritureLogInstall "********************************************************"
	
else    
	ecritureLogInstall "***** ERREUR le chemin courant :  $chemin "
	ecritureLogInstall "*****           chemin attendu :  $EMPLACEMENT_PACKAGES/${POST_VERSION}/sh_install "
	ecritureLogInstall "*                                                       *"
	ecritureLogInstall "***** ERREUR position dans l'arborescence incorrecte  ***"
	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "***** Le script va etre arreter : Lire le MOI svp !   ***"
	ecritureLogInstall "*********************************************************"
	exit 1
fi

### Controle du répertoire de livraison

ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Operation 1.3 : controle de la version précédente *"
ecritureLogInstall "*********************************************************"
if [ $INIT -ne 1 ];
	then
	if [ -d $CHEM_IND/$ANT_VERSION ];
	then 
		ecritureLogInstall "***** chemin de l'ancienne version : $CHEM_IND/$ANT_VERSION"
		ecritureLogInstall "***** Resultat OK                                       *"
		ecritureLogInstall "*********************************************************"
	else    
		ecritureLogInstall "***** ERREUR chemin de l'ancienne version : $CHEM_IND/$ANT_VERSION"
		ecritureLogInstall "***** ERREUR chemin de l'ancienne version             ***"
		ecritureLogInstall "***** ERREUR Resultat KO                              ***"
		ecritureLogInstall "*********************************************************"
		ecritureLogInstall "***** Le script va etre arreter : Lire le MOI svp !   ***"
		ecritureLogInstall "*********************************************************"
		
		exit 1
	fi
else
	ecritureLogInstall "***** Installation Première version *****"
fi

### Controle d'absence de la nouvelle version

ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Operation 1.4 : controle de la nouvelle version   *"
ecritureLogInstall "*********************************************************"

if [ $INIT -ne 1 ];
then
	if [ -d $CHEM_IND/$POST_VERSION ];
	then 
		ecritureLogInstall "***** ERREUR chemin de la nouvelle version existante :  $CHEM_IND/$POST_VERSION"
		ecritureLogInstall "***** ERREUR chemin de la nouvelle version            ***"
		ecritureLogInstall "***** ERREUR Resultat KO                              ***"
		ecritureLogInstall "*********************************************************"
		ecritureLogInstall "***** Le script va etre arreter : Lire le MOI svp !   ***"
		ecritureLogInstall "*********************************************************"
		
		exit 1
	else
		ecritureLogInstall "***** chemin de la nouvelle version : $CHEM_IND/$POST_VERSION "
		ecritureLogInstall "***** Resultat OK                                       *"
		ecritureLogInstall "*********************************************************"
	fi
else
	ecritureLogInstall "***** Installation Première version *****"
fi

########
#	Début de l'installation
########

ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Debut de l installation                         ***"
ecritureLogInstall "*********************************************************"
ecritureLogInstall "*********************************************************"
ecritureLogInstall "* Operation 1.1:  Creation de la nouvelle arborescence  *"
ecritureLogInstall "*********************************************************"

	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "* Operation 1.1.1:  Création universe/BACKUP         *"
	ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Creation du repertoire : ${CHEM_IND}/${POST_VERSION}/universe/BACKUP"

  CreeRep ${CHEM_IND}/${POST_VERSION}/universe
  CreeRep ${CHEM_IND}/${POST_VERSION}/universe/BACKUP



ecritureLogInstall "***** Creation du repertoire realisee avec succes ***"

###
#Copie de l'ancienne version si on n'est pas en Init
###

if [[ $INIT -ne 1 ]]
then

	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "* Operation 1.1.2:  Copie des fichiers anterieurs         *"
	ecritureLogInstall "*********************************************************"
	  
	  ecritureLogInstall "***** Copie des fichiers depuis : ${CHEM_IND}/${ANT_VERSION}/"
	  
	  cp -pR ${CHEM_IND}/${ANT_VERSION}/*  ${CHEM_IND}/${POST_VERSION}/ > /dev/null 
	  if [ $? != 0 ]; then
	  	 ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	  	 exit 2
	  else
	  	 ecritureLogInstall "***** Resultat OK                                     ***"
	  fi
		
	  
	  if [[ $INIT -eq 0 ]]
	  then
		  cd ${CHEM_IND}/${ANT_VERSION}/ > /dev/null 
		  pwd -P > ${CHEM_IND}/${POST_VERSION}/universe/BACKUP/bckp_current
		  if [ $? != 0 ]; then
			  ecritureLogInstall "***** ERREUR Resultat KO                              ***"
			  exit 1
		  else
			ecritureLogInstall "***** Resultat OK                                     ***"
		  fi
	  fi

else
	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "* Operation 1.1.2 Ignorée car 1ère Version (Copie des fichiers anterieurs)         *"
	ecritureLogInstall "*********************************************************"
fi

####
# Installation du package
####

ecritureLogInstall "*********************************************************"
ecritureLogInstall "* Operation 1.2:  Mise à jour de l'applicatif			  *"
ecritureLogInstall "*********************************************************"

ecritureLogInstall "***** Deplacement vers le repertoire d'accueil          *"

cd ${CHEM_IND}/${POST_VERSION} > /dev/null 
  if [ $? != 0 ]; then
    ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	exit 1
 else
    ecritureLogInstall "***** Resultat OK                                     ***"
 fi

ecritureLogInstall "***** Verification du tar de la sanbox inside          *"

if [ -f ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/PA-OD1-M_APP-RD${POST_VERSION}.tar ]; 
 then
  ecritureLogInstall "***** Modification des droits de : PA-OD1-M_APP-RD${POST_VERSION}.tar"

  chmod 664 ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/PA-OD1-M_APP-RD${POST_VERSION}.tar > /dev/null 
  if [ $? != 0 ]; then
    ecritureLogInstall "***** ERREUR Resultat KO                              ***"
    exit 1
  else
    ecritureLogInstall "***** Resultat OK                                     ***"
  fi
  
  ecritureLogInstall "***** Decompression des donnees en cours                *"

  tar -xvf ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/PA-OD1-M_APP-RD${POST_VERSION}.tar  > /dev/null   
  if [ $? != 0 ]; then
    ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	exit 1
  else
	ecritureLogInstall "***** Resultat OK                                     ***"
  fi
  
else
  ecritureLogInstall "***** Fichier tar de la sandbox inside absent          *"
fi

###
# Modif droit sandbox
###
#ecritureLogInstall "*********************************************************"
#ecritureLogInstall "* Operation 1.3:  Attribution des droits aux fichiers applicatifs   *"
#ecritureLogInstall "*********************************************************"

#ecritureLogInstall "***** Droit rwxr-x--- sur ${CHEM_IND}/${POST_VERSION}/sh  ***"

#chmod -R 750 ${CHEM_IND}/${POST_VERSION}/sh > /dev/null
#if [ $? != 0 ]; then
#	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
#	exit 1
#else
#	ecritureLogInstall "***** Resultat OK                                     ***"
#fi  

#ecritureLogInstall "***** Droit rwxr-x--- sur ${CHEM_IND}/${POST_VERSION}/sql  ***"

#chmod -R 750 ${CHEM_IND}/${POST_VERSION}/sql > /dev/null
#if [ $? != 0 ]; then
#	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
#	exit 1
#else
#	ecritureLogInstall "***** Resultat OK                                     ***"
#fi  
                                           
#ecritureLogInstall "***** Droit rwxrwx--- sur ${CHEM_IND}/${POST_VERSION}/cfg  ***"

#chmod -R 770 ${CHEM_IND}/${POST_VERSION}/cfg > /dev/null
#if [ $? != 0 ]; then
#	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
#	exit 1
#else
#	ecritureLogInstall "***** Resultat OK                                     ***"
#fi  

#ecritureLogInstall "***** Droit rwxrwx--- sur ${CHEM_IND}/${POST_VERSION}/java  ***"

#chmod -R 770 ${CHEM_IND}/${POST_VERSION}/java > /dev/null
#if [ $? != 0 ]; then
#	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
#	exit 1
#else
#	ecritureLogInstall "***** Resultat OK                                     ***"
#fi  
## TROIS SANDBOX : ALM_sandbox +  INI_sandbox  + RCT_sandbox

#for SANDBOXNAME in ALM_sandbox INI_sandbox RCT_sandbox
#do
#	ecritureLogInstall "***** Droit rwxr-x--- sur les fichiers .XXXXXX du répertoire ${CHEM_IND}/${POST_VERSION}/${SANDBOXNAME}/     *"
	
#	find ${CHEM_IND}/${POST_VERSION}/${SANDBOXNAME} -type f -name ".*" -exec chmod 750 {} > /dev/null \;
#	if [ $? != 0 ]; then
#		ecritureLogInstall "***** ERREUR Resultat KO                              ***"
#		exit 1
#	else
#		ecritureLogInstall "***** Resultat OK                                     ***"
#	fi 
	
#	ecritureLogInstall "***** Droit rwxr-x--- sur la sandbox ${SANDBOXNAME}           *"

#	chmod -R 750 ${CHEM_IND}/${POST_VERSION}/${SANDBOXNAME} > /dev/null
#	if [ $? != 0 ]; then
#		ecritureLogInstall "***** ERREUR Resultat KO                              ***"
#		exit 1
#	else
#		ecritureLogInstall "***** Resultat OK                                     ***"
#	fi  
  
#	ecritureLogInstall "***** Droit rwxrwx--- sur run de la sandbox ${SANDBOXNAME}      *"

#	chmod -R 770 ${CHEM_IND}/${POST_VERSION}/${SANDBOXNAME}/run > /dev/null
#	if [ $? != 0 ]; then
#		ecritureLogInstall "***** ERREUR Resultat KO                              ***"
#		exit 1
#	else
#		ecritureLogInstall "***** Resultat OK                                     ***"
#	fi    

#done

###
# Installation Composants DollarU
###

ecritureLogInstall "*********************************************************"
ecritureLogInstall "* Operation 1.4:  Mise à jour des composants Dollaru    *"
ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Verification du tar des composants Dollaru     *"
ecritureLogInstall "*********************************************************"

if [[ -f ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/PA-OD1-M_UNIV-RD${POST_VERSION}.tar ]]
then
    
    ecritureLogInstall "***** Modification des droits de :  PA-OD1-M_UNIV-RD${POST_VERSION}.tar"
	
    chmod 664 ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/PA-OD1-M_UNIV-RD${POST_VERSION}.tar > /dev/null
    if [ $? != 0 ]; then
		ecritureLogInstall "***** ERREUR Resultat KO                              ***"
		exit 1
    else
		ecritureLogInstall "***** Resultat OK                                     ***"
    fi

    ecritureLogInstall "***** Deplacement vers le repertoire d'accueil          *"
	
    cd $(eval "echo $ARBO_DollarU") > /dev/null
    if [ $? != 0 ]; then
		ecritureLogInstall "***** ERREUR Resultat KO                              ***"
		exit 1
    else
		ecritureLogInstall "***** Resultat OK                                     ***"
    fi

    ecritureLogInstall "***** Decompression des donnees en cours                *"
 
    tar -xvf ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/PA-OD1-M_UNIV-RD${POST_VERSION}.tar > /dev/null  
    if [ $? != 0 ]; then
		ecritureLogInstall "***** ERREUR Resultat KO                              ***"
		exit 1
    else
		ecritureLogInstall "***** Resultat OK                                     ***"
    fi
   
	

    ecritureLogInstall "***** Verification de la presence du script : IND_GEN_load_dollaru.ksh"
	
    if [[ ! -f ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/IND_GEN_load_dollaru.ksh ]]
    then
		ecritureLogInstall "* Script ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/IND_GEN_load_dollaru.ksh non present"
		ecritureLogInstall "***** ERREUR Resultat KO                              ***"
		exit 1
    fi
else
    ecritureLogInstall "***** Fichier tar des composants Dollaru non presents  *"  
fi  

#ecritureLogInstall "*********************************************************"
#ecritureLogInstall "* Operation 1.5:  Attribution des droits pour Dollaru  *"
#ecritureLogInstall "*********************************************************"

#ecritureLogInstall "***** Droit rwxrwxrwx sur le repertoire :  ${CHEM_IND}/${POST_VERSION}/universe "

#chmod -R 755 ${CHEM_IND}/${POST_VERSION}/universe	
#chmod -R 757 ${CHEM_IND}/${POST_VERSION}/universe/RULE ${CHEM_IND}/${POST_VERSION}/universe/UPROC ${CHEM_IND}/${POST_VERSION}/universe/SESSION ${CHEM_IND}/${POST_VERSION}/universe/TASK ${CHEM_IND}/${POST_VERSION}/universe/*.conf ${CHEM_IND}/${POST_VERSION}/universe/sh ${CHEM_IND}/${POST_VERSION}/universe/sh/UPROC > /dev/null 
#if [ $? != 0 ]; then
#	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
#	exit 1
#else
#	ecritureLogInstall "***** Resultat OK                                     ***"
#fi
    
#ecritureLogInstall "***** Proprietaire ${compte_dollaru}:${groupe_dollaru} sur le répertoire :  ${CHEM_IND}/${POST_VERSION}/universe"
    

###
# Mise à jour du lien symbolique Current
###
ecritureLogInstall "*********************************************************"
ecritureLogInstall "* Operation 1.6:  Mise a jour du lien symbolique        *"
ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Creation du lien symbolique vers :  ${CHEM_IND}/${POST_VERSION}"

rm -f ${CHEM_IND}/current
ln -sf ${CHEM_IND}/${POST_VERSION} ${CHEM_IND}/current > /dev/null
if [ $? != 0 ]; then
  ecritureLogInstall "***** ERREUR Resultat KO                              ***"
  exit 1
else
  ecritureLogInstall "***** Resultat OK                                     ***"
fi
###
# Opération post-install si existantes
###
ecritureLogInstall "*********************************************************"
ecritureLogInstall "* Operation 1.7:  Installation post-install             *"
ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Verification de la presence du script : ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/IND_${POST_VERSION}_POST_INSTALLATION.ksh"

  if [ -f ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/IND_${POST_VERSION}_POST_INSTALLATION.ksh ];
        then
    	  ecritureLogInstall "***** Fichier : IND_${POST_VERSION}_POST_INSTALLATION.ksh  trouve"
    	  ecritureLogInstall "***** Verification des droits d execution             ***"
		if [ -x ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/IND_${POST_VERSION}_POST_INSTALLATION.ksh ];
            then
            ecritureLogInstall "***** Resultat OK                                     ***"
            ecritureLogInstall "***** Lancement du script specifique                  ***"
            cd ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/
			${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/IND_${POST_VERSION}_POST_INSTALLATION.ksh
            if [ $? != 0 ]; then
	            ecritureLogInstall "***** ERREUR Resultat KO                              ***"
				exit 1
            else
				ecritureLogInstall "***** Script execute, verifier la log generee         ***"
            fi
        else
	          ecritureLogInstall "***** ERREUR Resultat KO                              ***"
			  exit 1
        fi
  else
    ecritureLogInstall "***** Aucun script detecte                            ***"
  fi
ecritureLogInstall "*********************************************************"
ecritureLogInstall "* Installation terminee avec succes                     "
ecritureLogInstall "* IP $IP                                            "
ecritureLogInstall "* le  $(date)                                            "
ecritureLogInstall "*********************************************************"

