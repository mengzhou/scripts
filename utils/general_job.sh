#!/usr/bin/bash
#set file name
if [ $1 ]
then
  FILE=$1
else
  FILE="general.sh"
fi

echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J general_job
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00
#SBATCH --mem=4G
export PATH=$PATH

WD=${PWD}
cd \$WD
" | sed 's/auto/home/g' > $FILE
chmod 775 $FILE
