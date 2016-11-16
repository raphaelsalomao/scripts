#!/bin/bash
########################
#### Raphael Salomão####
###### 11/11/2016 ######
########################

#find de arquivos vazios (output0.html)
#find de arquivos mp4 (output1.html)
#find de arquivos tmp (output2.html)
cd /data/www/freeboard/scripts
ssh root@10.62.2.27 \
"find /mnt/elemental/elemental/output -type f -empty | wc -l; \
find /mnt/elemental/elemental/output -type f ! -size 0| grep mp4 | grep -v tmp | wc -l; \
find /mnt/elemental/elemental/output -type f ! -size 0| grep tmp | wc -l" > result_find.txt

#split separando os resultados em arquivos diferentes
split -l 1 result_find.txt /data/www/freeboard/elemental_globocom --suffix-length=1 --additional-suffix=.html -d

#find do nome do programa
#vazio
PROGRAM0=$(ssh root@10.62.2.27 find /mnt/elemental/elemental/output -type f -empty | head -n1 | cut -d '_' -f8)
PROGRAM1=$(ssh root@10.62.2.27 find /mnt/elemental/elemental/output -type f ! -size 0| grep mp4 | grep -v tmp | head -n1 | cut -d '_' -f8)
PROGRAM2=$(ssh root@10.62.2.27 find /mnt/elemental/elemental/output -type f ! -size 0| grep tmp | head -n1 | cut -d '_' -f8)

#for i in $PROGRAM0 $PROGRAM1 $PROGRAM2;
#do
if [ -z "$PROGRAM0" ];
then
        PROGRAM0="Nenhum"
fi
if [ -z "$PROGRAM1" ];
then
        PROGRAM1="Nenhum"
fi
if [ -z "$PROGRAM2" ];
then
        PROGRAM2="Nenhum"
fi
#done

#escrevendo o nome do programa em JSON
echo -e "{\"Estado\":\"Vazio\",\"program\":\""$PROGRAM0"\"}" > /data/www/freeboard/elemental_globocom_program0.html
echo -e "{\"Estado\":\"Pronto\",\"program\":\""$PROGRAM1"\"}" > /data/www/freeboard/elemental_globocom_program1.html
echo -e "{\"Estado\":\"Processando\",\"program\":\""$PROGRAM2"\"}" > /data/www/freeboard/elemental_globocom_program2.html

#copiando arquivos com mais de 20 minutos
echo $(date) >> ./move.log
ssh root@10.62.2.27 "find /mnt/elemental/elemental/output/ -type f -mmin +9 ! -size 0| grep mp4 | grep -v tmp | xargs -I {} mv -v '{}' /mnt/incoming/vms/linear/" >> ./move.log
