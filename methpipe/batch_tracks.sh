#PBS -S /bin/bash
#PBS -q cmb
#PBS -N track_PROJ
#PBS -e ProjWD
#PBS -o ProjWD
#PBS -l nodes=1:ppn=1
#PBS -l walltime=8:00:00
#PBS -l mem=4000mb
#PBS -l pmem=4000mb
#PBS -l vmem=4000mb
ROOT="ProjWD"
GENOME="/home/rcf-40/mengzhou/panfs/genome/coordinates/"
export PATH=/bin:/home/rcf-40/mengzhou/bin/:${PATH}
cd $ROOT

for i in $(find $ROOT -name *Meth.bed)
do
  WD=${i%/*}  
  cd $WD
  METH=${i##*/}
  NAME=${METH%Meth*}
  METH_TRACK=${NAME}Meth.bw
  READS_TRACK=${NAME}Reads.bw
  HMR=${NAME}HMR.bed
  HMR_TRACK=${NAME}HMR.bb
  cut -f 1-3,5 ${METH} > temp
  bedGraphToBigWig temp ${GENOME} ${METH_TRACK}
  awk -F "[\t,:]+" 'BEGIN{OFS="\t"}{print $1,$2,$3,$5}' ${METH} > temp
  bedGraphToBigWig temp ${GENOME} ${READS_TRACK}
  awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,0,$6}' ${HMR} | sort -k 1,1 -k 2,2n > temp
  bedToBigBed temp ${GENOME} ${HMR_TRACK}
  rm temp
  cd $ROOT
done
