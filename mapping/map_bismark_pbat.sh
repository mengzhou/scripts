#!/bin/bash
BISMARK=/home/rcf-40/mengzhou/panfs/tools/bismark_v0.18.1/bismark
BT2=/home/rcf-40/mengzhou/panfs/tools/bowtie2-2.3.3
if [ $# -lt 2 ]
then
  echo "Usage: $0 <mm10 or hg19> <se_or_mate1_read_files> [mate2_read_files]"
  exit
fi
# get genome index
if [ $1 == "mm10" ]
then
  REF=/home/rcf-40/mengzhou/panfs/genome/mapping_index/bismark/bt2/mm10
elif [ $1 == "hg19" ]
then
  REF=/home/rcf-40/mengzhou/panfs/genome/mapping_index/bismark/bt2/hg19
else
  echo "$1 is not a supported genome index for Bismark!"
  exit
fi

if [ $# == 2 ]
then
  # single-end
  NAME=${PWD##*/}
  echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J bismark_se_${NAME#*_}
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=200:00:00
#SBATCH --mem=40G
export PATH=$PATH

WD=${PWD}
cd \$WD

$BISMARK --pbat --path_to_bowtie=$BT2 --parallel 4 -p 4 $REF $2
" > qsub_bismark_se_${NAME%.*}.sh
else
  # pair-end
  echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J bismark_pe_${NAME#*_}
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=200:00:00
#SBATCH --mem=40G
export PATH=$PATH

WD=${PWD}
cd \$WD

$BISMARK --pbat --path_to_bowtie=$BT2 -X 1000 --parallel 4 -p 4 $REF -1 $2 -2 $3
" > qsub_bismark_pe_${NAME%.*}.sh
fi
