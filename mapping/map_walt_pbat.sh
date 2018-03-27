#!/bin/bash
WALT=/home/rcf-40/mengzhou/bin/walt/bin/walt
if [ $# -lt 2 ]
then
  echo "Usage: $0 <mm10 or hg19> <se_or_mate1_read_files> [mate2_read_files]"
  exit
fi
# get genome index
if [ $1 == "mm10" ]
then
  REF=/home/rcf-40/mengzhou/panfs/genome/mapping_index/walt/mm10/mm10.dbindex
#elif [ $1 == "hg19" ]
#then
#  REF=/home/rcf-40/mengzhou/panfs/genome/walt_indices/hg19/hg19.dbindex
#  #REF=/home/rcf-40/mengzhou/panfs/genome/walt_indices/seed3/hg19/hg19.dbindex
elif [ $1 == "hg38" ]
then
  REF=/home/rcf-40/mengzhou/panfs/genome/mapping_index/walt/hg38/hg38.dbindex
else
  echo "$1 is not a supported genome index for WALT!"
  exit
fi
# get fastq files
if [ $# == 2 ]
then
  NAME=${2%%_trimmed*}
  echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J walt_${NAME}
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=200:00:00
#SBATCH --mem=50G
export PATH=$PATH

WD=${PWD}
cd \$WD

$WALT -P -t 16 -i $REF -r $2 -o ${NAME}.mr" > qsub_walt_${NAME}.sh
else
  # pair-end
  NAME=${2%%_1_val_1.*}
  echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J walt_${NAME}
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=200:00:00
#SBATCH --mem=50G
export PATH=$PATH

WD=${PWD}
cd \$WD

$WALT -P -t 16 -N 500000 -i $REF -1 $2 -2 $3 -o ${NAME}.mr" > qsub_walt_${NAME}.sh
fi
