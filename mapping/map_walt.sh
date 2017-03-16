#!/bin/bash
WALT=/home/rcf-40/mengzhou/bin/walt/bin/walt
if [ $# -lt 2 ]
then
  echo "Usage: $0 <mm10 or hg38>\
  [1 for single-end; 2 for pair-end]"
  exit
fi
# get genome index
if [ $1 == "mm10" ]
then
  REF=/home/rcf-40/mengzhou/panfs/genome/mapping_index/walt/mm10/mm10.dbindex
  #REF=/home/rcf-40/mengzhou/panfs/genome/walt_indices/seed3/mm10/mm10.dbindex
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
if [ $2 == "1" ]
then
  # single-end
  #1. raw
  #for READ1 in $(find $PWD -name "*.fastq")
  #2. sra
  #for SRA in $(find $PWD -name "*.sra")
  #3. trim-galore processed fq
  for READ1 in $(find $PWD -name "*.fq")
  do
    #1.
    #NAME=${READ1##*/}
    #2.
    #NAME=${SRA##*/}
    #READ1=${SRA%.*}.fastq
    #3.
    NAME=${READ1##*/}
    echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N walt_${NAME%.*}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=72:00:00
#PBS -l mem=30000mb
#PBS -l pmem=30000mb
#PBS -l vmem=30000mb
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/java/jdk1.5.0_13/bin:/home/rcf-40/mengzhou/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:/home/rcf-40/mengzhou/bin/rmap/bin:/home/rcf-40/mengzhou/bin/methpipe/bin

WD=${PWD}
cd \$WD

#$WALT -i $REF -r $READ1 -o ${READ1%.*}.mr -C AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
#$WALT -i $REF -r $READ1 -o ${READ1%.*}.mr -C AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
$WALT -i $REF -r $READ1 -o ${READ1%_trimmed.fq}.mr
" > qsub_walt_${NAME%.*}.sh
done
else
  # pair-end
  #1. raw
  #for READ1 in $(find $PWD -name "*_1.fastq")
  #2. sra
  #for SRA in $(find $PWD -name "*.sra")
  #3. trim-galore
  for READ1 in $(find $PWD -name "*_1_val_1.fq")
  do
    #1. raw
    #READ2=${READ1/%_1.fastq/_2.fastq}
    #NAME=${READ1##*/}
    #2. sra
    #READ1=${SRA%.*}_1.fastq
    #READ2=${SRA%.*}_2.fastq
    #NAME=${SRA##*/}
    #3. trim-galore
    READ2=${READ1/%_1_val_1.fq/_2_val_2.fq}
    NAME=${READ1##*/}
    echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N walt_${NAME%.*}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=72:00:00
#PBS -l mem=40000mb
#PBS -l pmem=40000mb
#PBS -l vmem=40000mb
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/java/jdk1.5.0_13/bin:/home/rcf-40/mengzhou/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin/methpipe/bin

WD=${PWD}
cd \$WD

#$WALT -i $REF -1 $READ1 -2 $READ2 -o ${READ1%_1.fastq}.mr -C AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT:CAAGCAGAAGACGGCATACGAGCTCTTCCGATCT
#$WALT -i $REF -1 $READ1 -2 $READ2 -o ${READ1%_1.fastq}.mr -C AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT:CAAGCAGAAGACGGCATACGAGCTCTTCCGATCT
$WALT -N 500000 -i $REF -1 $READ1 -2 $READ2 -o ${READ1%_1_val_1.fq}.mr
" > qsub_walt_${NAME%.*}.sh
done
fi
