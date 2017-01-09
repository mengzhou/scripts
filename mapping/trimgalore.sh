#!/usr/bin/bash
TRIM=/home/rcf-40/dolzhenk/panasas/trim_galore/trim_galore
CUTADAPT=/home/rcf-40/mengzhou/bin/cutadapt-1.3/bin/cutadapt
if [ $# -lt 1 ]
then
  echo "Usage: $0 <input_fastq_1> [input_fastq_2]"
  exit
fi
if [ $# == 1 ]
then
  # single-end
  READ1=$(realpath -s $1)
  NAME=$(basename $READ1)
  echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N trim_${NAME%.*}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=12:00:00
#PBS -l mem=4000mb
#PBS -l pmem=4000mb
#PBS -l vmem=4000mb
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/java/jdk1.5.0_13/bin:/home/rcf-40/mengzhou/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:/home/rcf-40/mengzhou/bin/rmap/bin:/home/rcf-40/mengzhou/bin/methpipe/bin

source /usr/usc/java/default/setup.sh
WD=$(dirname $READ1)
cd \$WD

$TRIM --path_to_cutadapt=$CUTADAPT --fastqc --dont_gzip $READ1
" | sed 's/\/auto/\/home/g' > qsub_trim_${NAME%.*}.sh
else
  # pair-end
  READ1=$(realpath -s $1)
  READ2=$(realpath -s $2)
  NAME=$(basename $READ1)
  echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N trim_${NAME%_1.fastq}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=12:00:00
#PBS -l mem=4000mb
#PBS -l pmem=4000mb
#PBS -l vmem=4000mb
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/java/jdk1.5.0_13/bin:/home/rcf-40/mengzhou/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:/home/rcf-40/mengzhou/bin/rmap/bin:/home/rcf-40/mengzhou/bin/methpipe/bin

source /usr/usc/java/default/setup.sh
WD=$(dirname $READ1)
cd \$WD

$TRIM --path_to_cutadapt=$CUTADAPT --fastqc --dont_gzip --paired $READ1 $READ2
" | sed 's/\/auto/\/home/g' > qsub_trim_${NAME%_1.fastq}.sh
fi
