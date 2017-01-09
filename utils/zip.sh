#!/bin/bash
#set ppn
if [ $1 ]
then
  ppn=$1
else
  ppn=4
fi
FILE=qsub_zip.sh

echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N zip_job
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=$ppn
#PBS -l walltime=24:00:00
#PBS -l mem=2000mb
#PBS -l pmem=$(expr 2000 / $ppn)mb
#PBS -l vmem=2000mb
export PATH=$PATH

WD=\"${PWD}\"
cd \$WD

for i in \$(find . -name \"*.mr\")
do
  ~mengzhou/bin/pbzip2 \$i
done" | sed 's/auto/home/g' > $FILE
chmod 775 $FILE
