#!/bin/bash
for i in $(find $PWD -name "*.sra" | sort)
do
  j=${i##*/}
  NAME=${j%.*}
  FILE=qsub_dump_${NAME}.sh
echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N dump_${NAME}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=24:00:00
#PBS -l mem=1000mb
#PBS -l pmem=1000mb
#PBS -l vmem=1000mb
cd ${i%/*}
/home/rcf-40/mengzhou/panfs/tools/sratoolkit.2.4.3-ubuntu64/bin/fastq-dump --split-3 $i
" > $FILE
done
