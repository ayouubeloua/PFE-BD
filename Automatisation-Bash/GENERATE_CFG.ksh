#!/bin/ksh

GENERATE_CFG_INS()
{
	echo -e "INS/Generate IND_ODS_INI_Config_Table.cfg.${current_vers}" >> FichierLog.${current_vers}.log
	
	if [[ ${NB_TAMPON} == ""  ]]; then
		echo "${DOM};${Table_Name};3;1;1" >> ${FOLDER_APP}${current_vers}${Repository_CFG_INS}/"IND_ODS_INI_Config_Dom.cfg.${current_vers}"
	else 
		echo  "${DOM};${Table_Name};${NB_TAMPON};1;1" >> ${FOLDER_APP}${current_vers}${Repository_CFG_INS}/"IND_ODS_INI_Config_Dom.cfg.${current_vers}"
	fi
}
GENERATE_CFG_INI()
{
	echo -e "INI/Generate IND_ODS_INI_Config_Table.cfg.${current_vers}" >> FichierLog.${current_vers}.log
  if [[ ${NB_TAMPON} == ""  ]]; then
		echo "${DOM}:SATACTDA1:${Table_Name}" >> ${FOLDER_APP}${current_vers}${Repository_CFG_INI}/"IND_ODS_INI_Config_Table.cfg.${current_vers}"
	else
		echo  "${DOM}:SATACTDA1:${Table_Name}" >> ${FOLDER_APP}${current_vers}${Repository_CFG_INI}/"IND_ODS_INI_Config_Table.cfg.${current_vers}"
	fi

	if [[ ${NB_TAMPON} == ""  ]]; then
		echo "${DOM};${Table_Name};3;1;1" >> ${FOLDER_APP}${current_vers}${Repository_CFG_INI}/"IND_ODS_INI_Config_Dom.cfg"
	else
		echo  "${DOM};${Table_Name};${NB_TAMPON};1;1" >> ${FOLDER_APP}${current_vers}${Repository_CFG_INI}/"IND_ODS_INI_Config_Dom.cfg"
	fi
}

GENERATE_CFG_RCT()
{
	echo -e "RCT/Generate IND_ODS_cle_table.cfg.${current_vers}" >> FichierLog.${current_vers}.log

echo -n "${Table_Name}:" >> ${FOLDER_APP}${current_vers}${Repository_CFG_RCT}/"IND_ODS_cle_table.cfg.${current_vers}" | awk -F '[[:space:]]*#[[:space:]]*' '{ if($5 != "") printf "%s%s", sep,$1; sep = ";"} END { printf "\n"}' ${Table_File} >> ${FOLDER_APP}${current_vers}${Repository_CFG_RCT}/"IND_ODS_cle_table.cfg.${current_vers}"

echo -e "${PREFIX_DML_FICHIER}${Table_Name};" >> ${FOLDER_APP}${current_vers}${Repository_CFG_RCT}/"Listfic.cfg.${current_vers}"

echo -n "${Table_Name}:" >> ${FOLDER_APP}${current_vers}${Repository_CFG_RCT}/"IND_ODS_cle_table.cfg" | awk -F '[[:space:]]*#[[:space:]]*' '{ if($5 != "") printf "%s%s", sep,$1; sep = ";"} END { printf "\n"}' ${Table_File} >> ${FOLDER_APP}${current_vers}${Repository_CFG_RCT}/"IND_ODS_cle_table.cfg"

echo -e "${PREFIX_DML_FICHIER}${Table_Name};" >> ${FOLDER_APP}${current_vers}${Repository_CFG_RCT}/"Listfic.cfg"

}
###EXECUT FUNCTIONS####

echo -e "CURRENT GENERATION : CFG"

cat ${Liste_des_tables} |sed 1,1d | while read List_Line
do
##PARAMETERS
Table_Name=`echo $List_Line|cut -d"#" -f3|sed -e "s/ *$//"`
DOM=`echo $List_Line|cut -d"#" -f2|sed -e "s/ *$//"`
NB_TAMPON=`echo $List_Line|cut -d"#" -f7|sed -e "s/ *$//"`;
current_vers=`echo $List_Line|cut -d"#" -f1|sed -e "s/ *$//"`;
Table_File=`echo ${List_Line}|cut -d"#" -f4`
Table_File="cfg/${Table_File}"

if [ -e ${Table_File} ];then
  echo -e "GENERAT CFG FileS ${Table_File}" >> FichierLog.${current_vers}.log

  GENERATE_CFG_INS ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_CFG_INS Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_CFG_INS  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
 
 fi

 GENERATE_CFG_INI ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_CFG_INI Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_CFG_INI  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log

 fi

 GENERATE_CFG_RCT ;
	if [ $? -ne 0 ];then
	  echo -e "##Erreur : GENERATE_CFG_RCT Not Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log
    else echo -e "##GENERATE_CFG_RCT  Succsusfuly Generated##\n" >> FichierLog.${current_vers}.log

 fi
else echo -e "GENERAT CFG FileS ${Table_File}\n${Table_File} n'existe pas\n" >> FichierLog.${current_vers}.log
fi

done
echo -e "GENERATION DONE : CFG"
