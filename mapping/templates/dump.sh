#PBS -S /bin/bash
#PBS -q cmb
#PBS -N dump_PROJ
#PBS -e ProjWD
#PBS -o ProjWD
#PBS -l nodes=1:ppn=1
#PBS -l walltime=24:00:00
#PBS -l mem=2000mb
#PBS -l pmem=2000mb
#PBS -l vmem=2000mb

WD=ProjWD
cd $WD
for i in $(find $WD -name "*sra")
do
  NAME=${i##*/}
  FILE=${NAME%.*}
  /home/rcf-40/mengzhou/bin/sratool/bin/fastq-dump --split-3 $i
done
