if [ $# -lt 2 ]
then
  echo "Usage: $0 <mm10 or hg19> <.mr file>"
  exit
fi
NAME=${2%.*}
echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J pipe_${NAME}
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=100:00:00
#SBATCH --mem=16G
export PATH=$PATH
export LC_All=C

WD=$PWD
REF=/home/rcf-40/mengzhou/panfs/genome/$1

cd \$WD
duplicate-remover -o ${2}.nodup -S ${NAME}.dup_stats $2
bsrate -c \${REF} -o ${NAME}.bsrate ${2}.nodup
methcounts -c \${REF} -o ${NAME}.all.meth ${NAME}.mr.nodup
symmetric-cpgs -m -o ${NAME}.meth ${NAME}.all.meth
levels -o ${NAME}.levels ${NAME}.all.meth
hmr -o ${NAME}.hmr ${NAME}.meth
pmd -o ${NAME}.pmd ${NAME}.meth
methstates -c \${REF} -o ${NAME}.epiread ${NAME}.mr.nodup
allelicmeth -o ${NAME}.allelic -c \${REF} ${NAME}.epiread
amrfinder -c \${REF} -o ${NAME}.amr ${NAME}.epiread
#awk '{if (\$2 > 1000) {\$2 -= 1000} else {\$2 = 0} print \$1,\$2,\$3 + 1000,\$4,\$5,\$6}' ${NAME}.pamr | sortbed -c /dev/stdin | awk '{print \$1,\$2+1000,\$3-1000,\$4,\$5,\$6}' | awk '\$3-\$2 >= 200 && \$3-\$2 < 50000{print}' > ${NAME}.amr" > qsub_pipe_${NAME}.sh
