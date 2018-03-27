#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J PROJ
#SBATCH -e ProjWD/%x.e%j
#SBATCH -o ProjWD/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=200:00:00
#SBATCH --mem=40G
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/java/jdk1.5.0_13/bin:/home/rcf-40/mengzhou/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:/home/rcf-40/mengzhou/bin/rmap/bin:/home/rcf-40/mengzhou/bin/methpipe/bin

WD=ProjWD
cd $WD

BOWTIE=/home/rcf-40/mengzhou/bin/bowtie-1.0.0/bowtie
REF=/home/rcf-40/mengzhou/panfs/genome/mapping_index/bowtie/bt1/mm10/mm10
FA=
OUT=

OPTIONS="-p 16 -S --best"
# End to end mapping for smRNA, with all ambiguous alignments reported (-a)
$BOWTIE $OPTIONS -v 3 -a $REF $FA $OUT

# default mapping parameters
#$BOWTIE $OPTIONS $REF $FA $OUT
