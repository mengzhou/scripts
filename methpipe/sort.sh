if [ $# -lt 1 ]
then
  echo "Usage: $0 <.mr file>"
  exit
fi
tmp_dir=/staging/as/mengzhou
i=${1##*/}
NAME=${i%.*}
echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N sort_${NAME}
#PBS -e ${PWD}
#PBS -o ${PWD}
#PBS -l nodes=1:ppn=8
#PBS -l walltime=100:00:00
#PBS -l mem=42000mb
export PATH=${PATH}

cd $PWD
LC_ALL=C sort --parallel=8 -T \$PWD -S 32G -k1,1 -k2,2n -k3,3n -k6,6 -o $1 $1
" > qsub_sort_${NAME}.sh
