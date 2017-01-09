#!/bin/bash
WD=$PWD
for i in $(find . -name "*.fastq" | sort)
do
  t=${i#./}
  P=$PWD/${t%/*}
  FILE=${t##*/}.qsub

  echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N split_${t##*/}
#PBS -e ${WD}
#PBS -o ${WD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=24:00:00
#PBS -l mem=1000mb
#PBS -l pmem=1000mb
#PBS -l vmem=1000mb
WD=${P}
cd \$WD
for i in \$(ls *fastq)
do
split -a 3 -d -l 16000000 \$i \$(basename \$i)
done
" > $FILE

done
