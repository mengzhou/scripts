if [ $# -lt 1 ]
then
  echo "Usage: $0 <.mr file>"
  exit
fi
tmp_dir=/staging/as/mengzhou
i=${1##*/}
NAME=${i%.*}
echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J sort_${NAME}
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=100:00:00
#SBATCH --mem=50G
export PATH=$PATH
export LC_ALL=C

cd $PWD
sort --parallel=8 -T \$PWD -S 32G -k1,1 -k2,2n -k3,3n -k6,6 -o $1 $1
" > qsub_sort_${NAME}.sh
