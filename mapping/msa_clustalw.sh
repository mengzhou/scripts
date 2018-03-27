#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J clustalw
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00
#SBATCH --mem=4G
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/java/jdk1.5.0_13/bin:/home/rcf-40/mengzhou/bin:/home/rcf-40/mengzhou/bin/bedtools/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:/home/rcf-40/mengzhou/bin/rmap/bin:/home/rcf-40/mengzhou/bin/methpipe/bin:/home/rcf-40/mengzhou/bin/amrfinder_v1.01/bin

WD=$PWD
cd $WD

#-1. Input file, a consensus .fa file
INPUT_FA=$1
NAME=${INPUT_FA%.*}

#0. Paths
MSA_PROG=/home/rcf-40/mengzhou/bin/clustalw-2.1/clustalw2
HMMER=/home/rcf-40/mengzhou/panfs/tools/hmmer-3.1b1/binaries/
REF=/home/rcf-40/mengzhou/panfs/genome/mm10

#1. MSA
PARS="-INFILE=${INPUT_FA} -ALIGN -TYPE=DNA -DNAMATRIX=IUB -GAPOPEN=10 -GAPEXT=0.2 -GAPDIST=5"

if [ ! -e ${NAME}.aln ]
then
  $MSA_PROG $PARS
fi

#2. HMM and scan
OUTPUT_HMM=${NAME}.hmm
OUTPUT_HITS=${NAME}.hits
OUTPUT_BED=${NAME}_profHMM.bed

#if [ ! -e ${OUTPUT_HMM} ]
#then
#  ${HMMER}/hmmbuild $OUTPUT_HMM ${NAME}.aln
#fi
#if [ ! -e ${OUTPUT_HITS} ]
#then
#  ${HMMER}/nhmmer -o $OUTPUT_HITS $OUTPUT_HMM $REF
#fi
##START=$(grep -n "Scores for complete hits" $OUTPUT_HITS | cut -d ":" -f 1)
#START=13
#END=$(grep -n "Annotation for each hit" $OUTPUT_HITS | cut -d ":" -f 1)
#LINES=$(expr $END - $START)
#
##chr, start, end, score, strand, fdr, bias
##need to check coordinates and decide strand
#tail -n +${START} $OUTPUT_HITS | head -n $LINES | grep chr | sed 's/\s\+/\t/g' | awk 'BEGIN{OFS="\t";count=1}{if($5<$6){print $4,$5,$6,"REGION"count++,$2,"+",$1,$3}else{print $4,$6,$5,"REGION"count++,$2,"-",$1,$3}}' | sort -k1,1 -k2,2g > $OUTPUT_BED
