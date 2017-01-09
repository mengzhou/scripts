#!/bin/bash
if [ $# -lt 3 ]
then
  echo "Usage: $0 <mm10 or hg19> <name of job>\
  [1 for single-end; 2 for pair-end]"
  exit
fi
# get genome index
if [ $1 == "mm10" ]
then
  REF=/home/rcf-40/mengzhou/panfs/genome/walt_indices/mm10/mm10.dbindex
elif [ $1 == "hg19" ]
then
  REF=/home/rcf-40/mengzhou/panfs/genome/walt_indices/hg19/hg19.dbindex
else
  echo "$1 is not a supported genome index for WALT!"
  exit
fi
# get fastq files
if [ $3 == "1" ]
then
  # single-end
  READ1=$(find $PWD -name "*.fastq" -print0 | sed 's/\x0/,/g')
  echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N walt_$2
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=48:00:00
#PBS -l mem=32000mb
#PBS -l pmem=32000mb
#PBS -l vmem=32000mb
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/java/jdk1.5.0_13/bin:/home/rcf-40/mengzhou/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:/home/rcf-40/mengzhou/bin/rmap/bin:/home/rcf-40/mengzhou/bin/methpipe/bin

WD=${PWD}
cd \$WD

/home/rcf-40/mengzhou/bin/walt/bin/walt -i $REF -r $READ1 -o ${2}.mr -C AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
" > qsub_walt_${2}.sh
else
  # pair-end
  READ1=$(find $PWD -name "*_1.fastq" -print0 | sed 's/\x0/,/g')
  READ2=$(find $PWD -name "*_2.fastq" -print0 | sed 's/\x0/,/g')
  echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N walt_$2
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=48:00:00
#PBS -l mem=32000mb
#PBS -l pmem=32000mb
#PBS -l vmem=32000mb
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/java/jdk1.5.0_13/bin:/home/rcf-40/mengzhou/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:/home/rcf-40/mengzhou/bin/rmap/bin:/home/rcf-40/mengzhou/bin/methpipe/bin

WD=${PWD}
cd \$WD

/home/rcf-40/mengzhou/bin/walt/bin/walt -i $REF -1 $READ1 -2 $READ2 -o ${2}.mr -C AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT:CAAGCAGAAGACGGCATACGAGCTCTTCCGATCT
" > qsub_walt_${2}.sh
fi
