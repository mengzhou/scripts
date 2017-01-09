#PBS -S /bin/bash
#PBS -q cmb
#PBS -N PROJ
#PBS -e ProjWD
#PBS -o ProjWD
#PBS -l nodes=1:ppn=10
#PBS -l walltime=200:00:00
#PBS -l mem=64000mb
#PBS -l pmem=6400mb
#PBS -l vmem=64000mb
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/java/jdk1.5.0_13/bin:/home/rcf-40/mengzhou/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:/home/rcf-40/mengzhou/bin/rmap/bin:/home/rcf-40/mengzhou/bin/methpipe/bin

WD=ProjWD
cd $WD

BOWTIE=/home/rcf-40/mengzhou/bin/bowtie-1.0.0/bowtie
REF=/home/rcf-40/mengzhou/panfs/genome/mapping_index/bowtie/bt1/mm10/mm10
FA=
OUT=

OPTIONS="-p 10 -S --best"
# End to end mapping for smRNA, with all ambiguous alignments reported (-a)
$BOWTIE $OPTIONS -v 3 -a $REF $FA $OUT

# default mapping parameters
#$BOWTIE $OPTIONS $REF $FA $OUT
