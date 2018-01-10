#!/bin/bash
WALT=/home/rcf-40/mengzhou/bin/walt/bin/walt
if [ $# -lt 2 ]
then
  echo "Usage: $0 <mm10 or hg19> <se_or_mate1_read_files> [mate2_read_files]"
  exit
fi
# get genome index
REF=/home/rcf-40/mengzhou/panfs/genome/mapping_index/walt/${1}/${1}.dbindex
if [ ! -e $REF ]
then
  echo "$1 is not a supported genome index for WALT!"
  exit
fi
# get fastq files
if [ $# == 2 ]
then
  NAME=${2%%_trimmed*}
  echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N walt_${NAME}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=16
#PBS -l walltime=100:00:00
#PBS -l mem=48000mb
export PATH=$PATH

WD=${PWD}
cd \$WD

$WALT -t 16 -N 100000 -i $REF -r $2 -o ${NAME}.mr
" > qsub_walt_${NAME}.sh
else
  # pair-end
  NAME=${2%%_1_val_1.*}
  echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N walt_${NAME}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=16
#PBS -l walltime=100:00:00
#PBS -l mem=50000mb
export PATH=$PATH

WD=${PWD}
cd \$WD

$WALT -t 16 -N 100000 -i $REF -1 $2 -2 $3 -o ${NAME}.mr
" > qsub_walt_${NAME}.sh
fi
