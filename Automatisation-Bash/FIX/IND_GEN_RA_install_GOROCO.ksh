#!/bin/ksh  

# *******************************************************************                              
# ** Systeme technique : INSIDE                                                       
# ** Logiciel (Module)    : Générique                                                              
# *******************************************************************                              
# ** Fichier           : IND_GEN_RA_Install_Version.ksh                                                     
# ** Auteur            : Atos                                                                 
# ** Date de creation  : Juin 2011                                                                 
# ** Description :      Script d'installation                                                                    
# **                                     
# *******************************************************************                              
# ** Version     Aut  Description                                                                  
# ** ==========  ===  ===============================================                              
# ** 00.01       CAP  Creation                                                                     
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

[ ! -f ${HOME}/.bash_profile ] \
	&& echo "fichier ${HOME}/.profile absent" \
	&& exit 1




### Vérification lancement
# Récupération des arguments du scrip
typeset Facility=$0
typeset facility=$(basename ${Facility})
NB_ARGS=$#

[ ${NB_ARGS} -ne 4 ] && print "Mauvais nombre d'argument" && exit 1

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
LOG="$EMPLACEMENT_PACKAGES/${POST_VERSION}/Log/retour_Arriere_Installation_Inside_CDC_${POST_VERSION}_$(date +%Y%m%d%H%M%S).log"

### Vérification lancement
# Récupération des arguments du scrip
NB_ARGS=$#

mkdir $EMPLACEMENT_PACKAGES/${POST_VERSION}/Log 2>/dev/null



#############################################################################
#####           ###               #    
 ## ##           ##              ##    
 ##  ##   ####   ##     ##  ##  #####  
 ##  ##  ##  ##  #####  ##  ##   ##    
 ##  ##  ######  ##  ## ##  ##   ##    
 ## ##   ##      ##  ## ##  ##   ## #  
#####     ####  ## ###   ### ##   ##   
#############################################################################

ecritureLogInstall "*********************************************************"
  ecritureLogInstall "***** Retour arriere Inside  ${POST_VERSION}                           ****"
  ecritureLogInstall "*********************************************************"
  
COMMAND="$0"

ecritureLogInstall "*********************************************************"
ecritureLogInstall "**** Retour Arriere                                    **"
ecritureLogInstall "**** le  $la_date                                         "
ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Controle des pre-requis                         ***"
ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Operation 1.1 : controle du user                ***"
ecritureLogInstall "*********************************************************"

if [[ "$user" = "${compte_install}" ]]
then 
	ecritureLogInstall "***** utilisateur courant : ${compte_install}  : OK                ***"
	ecritureLogInstall "*                                                       *"
	ecritureLogInstall "*********************************************************"

else    
	ecritureLogInstall "***** ERREUR le user actuel est :  $user        "
	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "***** ERREUR le user actuel est :  $user  "
	ecritureLogInstall "***** ERREUR vous n'utilisez pas le bon user           ***"
	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "***** Le script va etre arreter : Lire le MOI svp !   ***"
	ecritureLogInstall "*********************************************************"
	
	exit 1
fi

ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Operation 1.2 : controle du chemin courant      ***"
ecritureLogInstall "*********************************************************"

cd $EMPLACEMENT_PACKAGES/${POST_VERSION}/sh_install 2>/dev/null
chemin=$(pwd)

if [[ "$chemin" = "$EMPLACEMENT_PACKAGES/$POST_VERSION/sh_install" ]]
then 
	ecritureLogInstall "***** chemin courant :  $chemin"
	ecritureLogInstall "***** Resultat OK                                       *"
	ecritureLogInstall "*********************************************************"
	
else    
	ecritureLogInstall "***** ERREUR le chemin courant : $chemin "
	ecritureLogInstall "***** ERREUR position dans l'arborescence incorrecte  ***"
	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "***** Le script va etre arreter : Lire le MOI svp !   ***"
	ecritureLogInstall "*********************************************************"

	exit 1
fi


ecritureLogInstall "*********************************************************"
ecritureLogInstall "***** Operation 1.3 : controle du repertoire de livraison"
ecritureLogInstall "*********************************************************"

if [[ -d $EMPLACEMENT_PACKAGES/$POST_VERSION/ ]]
then 
	ecritureLogInstall "***** chemin de livraison :  $CHEM_IND/livraison/$POST_VERSION "
	ecritureLogInstall "***** Resultat OK                                       *"
	ecritureLogInstall "*********************************************************"                            
	
else    
	ecritureLogInstall "***** ERREUR le chemin de livraison :  $CHEM_IND/livraison/$POST_VERSION"
	ecritureLogInstall "***** ERREUR position dans l'arborescence incorrecte  ***"
	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "***** Le script va etre arreter : Lire le MOI svp !   ***"
	ecritureLogInstall "*********************************************************"
	
	exit 1
fi


ecritureLogInstall "*********************************************************"
  ecritureLogInstall "***** Operation 1.4 : Verification du current           *"
  ecritureLogInstall "*********************************************************"

if [[ -d ${CHEM_IND}/current ]]
then 
	ecritureLogInstall "***** chemin de livraison : ${CHEM_IND}/current"
	ecritureLogInstall "***** Resultat OK                                       *"
	ecritureLogInstall "*********************************************************"
else    
	ecritureLogInstall "***** ERREUR le chemin de livraison : ${CHEM_IND}/current"
	ecritureLogInstall "***** ERREUR position dans l'arborescence incorrecte  ***"
	ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	ecritureLogInstall "*********************************************************"
	ecritureLogInstall "***** Le script va etre arreter : Lire le MOI svp !   ***"
	ecritureLogInstall "*********************************************************"
	
	exit 1
fi

  ecritureLogInstall "*********************************************************"
  ecritureLogInstall "*********************************************************"
  ecritureLogInstall "***** Debut du retour arriere                         ***"
  ecritureLogInstall "*********************************************************"
 ecritureLogInstall " * Operation 1.1:  Recuperation du current               *"
 ecritureLogInstall " *********************************************************"

  cd ${CHEM_IND}/current 
  pwd -P > ${CHEM_IND}/remove_current
  if [ $? != 0 ]; then
	  ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	  exit 1
  else
    ecritureLogInstall "***** Resultat OK                                     ***"
  fi
  

  ecritureLogInstall "*********************************************************"
  ecritureLogInstall "* Operation 1.1.1:  RA post-install                     *"
  ecritureLogInstall "*********************************************************"
  ecritureLogInstall "***** Verification de la presence du script : ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/IND_${POST_VERSION}_RA_POST_INSTALLATION.ksh"

  if [ -f ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/IND_${POST_VERSION}_RA_POST_INSTALLATION.ksh ];
        then
         ecritureLogInstall "***** Fichier : IND_${POST_VERSION}_RA_POST_INSTALLATION.ksh  trouve"
          ecritureLogInstall "***** Verification des droits d execution             ***"

                if [ -x ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/IND_${POST_VERSION}_RA_POST_INSTALLATION.ksh ];
            then
            ecritureLogInstall "***** Resultat OK                                     ***"
            ecritureLogInstall "***** Lancement du script specifique                  ***"
                        cd ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/
           ${EMPLACEMENT_PACKAGES}/${POST_VERSION}/sh_install/IND_${POST_VERSION}_RA_POST_INSTALLATION.ksh
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
  ecritureLogInstall "* Operation 1.2:  Modification du current               *"
  ecritureLogInstall "*********************************************************"


  if [[ $INIT -eq 1 ]]
  then
	cd ${CHEM_IND}
	rm -f current
	if [ $? != 0 ]; then
	  ecritureLogInstall "***** ERREUR Resultat KO                              ***"
	exit 1
	 else
	ecritureLogInstall "***** Resultat OK                                     ***"
	 fi
  else
	
	  rm -f ${CHEM_IND}/current
	  ln -sf ${CHEM_IND}/${ANT_VERSION} ${CHEM_IND}/current > /dev/null
	  
	  if [ $? != 0 ]; then
		  ecritureLogInstall "***** ERREUR Resultat KO                              ***"
		exit 1
	  else
		ecritureLogInstall "***** Resultat OK                                     ***"
	  fi
	  
  fi

  ecritureLogInstall "*********************************************************"
  ecritureLogInstall "* Operation 1.3:  Purge de la derniere version          *"
  ecritureLogInstall "*********************************************************"


  cd ${CHEM_IND}
  rm -Rf `cat ${CHEM_IND}/remove_current`
  if [ $? != 0 ]; then
	  ecritureLogInstall "***** ERREUR Resultat KO                              ***"
    exit 1
  else
    ecritureLogInstall "***** Resultat OK                                     ***"
	rm ${CHEM_IND}/remove_current
  fi
 
 ecritureLogInstall "*********************************************************"
  ecritureLogInstall "* Retour arriere termine avec succes                    *"
  ecritureLogInstall "*********************************************************"
  ecritureLogInstall "* IP  $IP       "
  ecritureLogInstall " la_date=$(date)"
 ecritureLogInstall " *********************************************************"
  
