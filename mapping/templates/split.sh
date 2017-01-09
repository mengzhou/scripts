#PBS -S /bin/bash
#PBS -q cmb
#PBS -N split_
#PBS -e 
#PBS -o 
#PBS -l nodes=1:ppn=1
#PBS -l walltime=24:00:00
#PBS -l mem=1000mb
#PBS -l pmem=1000mb
#PBS -l vmem=1000mb
WD=
cd $WD
for i in $(find $WD -name "*fastq")
do
split -a 3 -d -l 16000000 $i $i
done
