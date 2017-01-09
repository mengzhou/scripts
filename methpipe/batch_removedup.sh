#!/bin/bash
ls -l | egrep "^d" | sed 's/\s\s\+/ /g' | cut -d " " -f 9 > list
while read l
do
FILE=removedup_${l}.qsub
echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N dump_${l}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=24:00:00
#PBS -l mem=2000mb
#PBS -l pmem=2000mb
#PBS -l vmem=2000mb
cd ${PWD}/$l
for i in \$(ls *mr)
do
  duplicate-remover -o \${i}.dup -S \${i%.*}.dup_stats \$i
done
" > $FILE
done < list
rm list
