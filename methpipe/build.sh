#PBS -S /bin/bash
#PBS -q cmb
#PBS -N build_PROJ
#PBS -e ProjWD
#PBS -o ProjWD
#PBS -l nodes=1:ppn=1
#PBS -l walltime=24:00:00
#PBS -l mem=4000mb
#PBS -l pmem=4000mb
#PBS -l vmem=4000mb
export PATH=/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:${PATH}
export LC_ALL=C

WD="ProjWD"
for i in $( find $WD -name *start)
do
echo ${i%/*} >> temp
done
sort temp | uniq > list
rm temp

while read l
do
ls ${l}/*start > ${l}/lib
cd $l
python /home/rcf-40/mengzhou/bin/methpipe/src/pipeline/build_methylome.py -L lib -T $l -B /home/rcf-40/mengzhou/bin/methpipe/bin -S 8 -N ${l##*/} -o $l -A
done < list
