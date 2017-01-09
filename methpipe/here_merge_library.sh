#!/bin/bash
if [ $1 ]
then
  OUTPUT=$1
else
  OUTPUT=${PWD##*/}.mr
fi

tmp_dir=/staging/as/mengzhou
echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N merge_${OUTPUT%.*}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=18:00:00
#PBS -l mem=6000mb
#PBS -l pmem=6000mb
#PBS -l vmem=6000mb
export PATH=/bin:/home/rcf-40/mengzhou/bin/:${PATH}
export LC_ALL=C
" > temp

find $PWD -name "*.mr" | sort > list
STR=""
while read l
do
  #INF=${l##*/}.sorted_start
  INF=${l##*/}
  STR=${l%/*}/${INF}\ $STR
  echo sort -T $tmp_dir -S 4G -k1,1 -k2,2g -k3,3g -k6,6 -o ${l%/*}/${INF} $l >> temp
done < list
rm list

##dont remove duplicates
#echo sort -m -T ${PWD} -S 1G -k1,1 -k2,2g -k3,3g -k6,6 -o ${PWD}/${OUTPUT} $STR >> temp

#do remove duplicates
echo sort -m -T $tmp_dir -S 4G -k1,1 -k2,2g -k3,3g -k6,6 -o ${PWD}/${OUTPUT}.all $STR >> temp
#-D disables the sorting test
echo duplicate-remover -D -s -S ${PWD}/${OUTPUT%.mr}.dupstats -o ${PWD}/${OUTPUT} ${PWD}/${OUTPUT}.all >> temp
#echo duplicate-remover -S ${PWD}/${OUTPUT%.mr}.dup_stats -o ${PWD}/${OUTPUT} ${PWD}/dup_tmp >> temp
#echo rm ${PWD}/dup_tmp >> temp
