#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J PROJ
#SBATCH -e ProjWD/%x.e%j
#SBATCH -o ProjWD/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=48:00:00
#SBATCH --mem=60G
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/java/jdk1.5.0_13/bin:/home/rcf-40/mengzhou/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:/home/rcf-40/mengzhou/bin/rmap/bin:/home/rcf-40/mengzhou/bin/methpipe/bin

WD=ProjWD
cd $WD

STAR=/home/rcf-40/mengzhou/bin/STAR/bin/Linux_x86_64/STAR
GENOME_INDEX=/home/rcf-40/mengzhou/panfs/genome/mapping_index/star/mm10
THREAD=16
ADAPTER=

PREFIX=${PROJ}.
READ1=
READ2=

$STAR --outFileNamePrefix $PREFIX --outFilterIntronMotifs RemoveNoncanonical \
  --outSAMstrandField intronMotif --clip3pAdapterSeq $ADAPTER \
  --outSAMtype BAM Unsorted --runThreadN $THREAD --genomeDir $GENOME_INDEX\
  --readFilesIn $READ1 $READ2
