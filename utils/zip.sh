#!/bin/bash
ppn=16
FILE=qsub_zip.sh

echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N zip_${PWD##*/}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=$ppn
#PBS -l walltime=24:00:00
#PBS -l mem=12000mb
export PATH=$PATH

WD=\"${PWD}\"
cd \$WD

for i in \$(find . -name \"*.$1\")
do
  ~mengzhou/bin/pbzip2 \$i
done" | sed 's/auto/home/g' > $FILE
chmod 775 $FILE
