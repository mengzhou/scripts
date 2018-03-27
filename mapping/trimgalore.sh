#!/usr/bin/bash
TRIM=/home/rcf-40/mengzhou/panfs/tools/trim_galore.0.4.1/trim_galore
CUTADAPT=/home/rcf-40/mengzhou/panfs/tools/cutadapt-1.3/bin/cutadapt
if [ $# -lt 1 ]
then
  echo "Usage: $0 <input_fastq_1> [input_fastq_2]"
  exit
fi
if [ $# == 1 ]
then
  # single-end
  READ1=$(realpath -s $1)
  NAME=$(basename $READ1)
  echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J trim_${NAME%.*}
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=200:00:00
#SBATCH --mem=5G
export PATH=$PATH

source /usr/usc/java/default/setup.sh
WD=$(dirname $READ1)
cd \$WD

$TRIM --path_to_cutadapt=$CUTADAPT --fastqc --dont_gzip $READ1
" | sed 's/\/auto/\/home/g' > qsub_trim_${NAME%.*}.sh
else
  # pair-end
  READ1=$(realpath -s $1)
  READ2=$(realpath -s $2)
  NAME=$(basename $READ1)
  echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J trim_${NAME%_1.fastq}
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=200:00:00
#SBATCH --mem=5G
export PATH=$PATH

source /usr/usc/java/default/setup.sh
WD=$(dirname $READ1)
cd \$WD

$TRIM --path_to_cutadapt=$CUTADAPT --fastqc --dont_gzip --paired $READ1 $READ2
" | sed 's/\/auto/\/home/g' > qsub_trim_${NAME%_1.fastq}.sh
fi
