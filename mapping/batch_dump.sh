#!/bin/bash
for i in $(find $PWD -name "*.sra" | sort)
do
  j=${i##*/}
  NAME=${j%.*}
  FILE=qsub_dump_${NAME}.sh
echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J dump_${NAME}
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=200:00:00
#SBATCH --mem=5G
export PATH=$PATH

cd ${i%/*}
/home/rcf-40/mengzhou/panfs/tools/sratoolkit.2.4.3-ubuntu64/bin/fastq-dump --split-3 $i
" > $FILE
done
