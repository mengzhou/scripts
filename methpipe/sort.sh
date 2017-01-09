tmp_dir=/staging/as/mengzhou
echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N sort_${PWD##*/}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=8
#PBS -l walltime=100:00:00
#PBS -l mem=32000mb
#PBS -l pmem=4000mb
#PBS -l vmem=32000mb
export PATH=${PATH}

cd $PWD

for i in *.mr
do
  LC_ALL=C sort --parallel=8 -T \$PWD -S 28G -k1,1 -k2,2n -k3,3n -k6,6 -o \$i \$i
done" > temp
