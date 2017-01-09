#!/bin/bash
#set file name
if [ $1 ]
then
  FILE=$1
else
  FILE="general.sh"
fi

echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N general_job
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=1
#PBS -l walltime=24:00:00
#PBS -l mem=4000mb
#PBS -l pmem=4000mb
#PBS -l vmem=4000mb
export PATH=$PATH

WD=${PWD}
cd \$WD
" | sed 's/auto/home/g' > $FILE
chmod 775 $FILE
