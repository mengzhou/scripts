#PBS -S /bin/bash
#PBS -q cmb
#PBS -N clip_PROJ
#PBS -e ProjWD
#PBS -o ProjWD
#PBS -l nodes=1:ppn=1
#PBS -l walltime=24:00:00
#PBS -l mem=2000mb
#PBS -l pmem=2000mb
#PBS -l vmem=2000mb
export PATH=/home/rcf-40/mengzhou/bin/methpipe/bin:${PATH}

WD=ProjWD
cd $WD

for i in *_1.*mr
do
  LIB=${i%%_1.*}
  SFX=${i##*_1.}
  j=${LIB}_2.${SFX}
  sort -k 4 -o ${i}.name_srtd $i
  sort -k 4 -o ${j}.name_srtd $j
  clipmates -L 1000 -S ${LIB}.${SFX}.clipstats -o ${LIB}.${SFX} -T ${i}.name_srtd -A ${j}.name_srtd
done
