if [ $# -lt 2 ]
then
  echo "Usage: $0 <mm10 or hg19> <.mr file>"
  exit
fi
NAME=${2%.*}
echo "#PBS -S /bin/bash
#PBS -q cmb
#PBS -N pipe_${NAME}
#PBS -e $PWD
#PBS -o $PWD
#PBS -l nodes=1:ppn=1
#PBS -l walltime=100:00:00
#PBS -l mem=16000mb
#PBS -l pmem=16000mb
#PBS -l vmem=16000mb

export PATH=/home/rcf-40/mengzhou/bin/rmap/bin:/home/rcf-40/mengzhou/panfs/tools/methpipe/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin:/usr/usc/R/2.13.0/bin:/usr/bin:/usr/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin
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
