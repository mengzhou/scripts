#!/bin/bash
if [ $1 ]
then
  NAME=${1%.*}
  REF=/home/rcf-40/mengzhou/panfs/genome/coordinates/hg19.sizes
  CHAIN=/home/rcf-40/mengzhou/panfs/genome/liftover/hg18ToHg19.over.chain
  # 1 for BED format; 0 for methcounts format
  FORMAT=$(head -n 1 $1 | awk '{if($6=="+"||$6=="-")print 1;else print 0}')

  echo "Preprocessing..."
  awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4":"$6":"$7":"$8":"$9,$5,"+"}' $1 > tmp

  echo "Doing liftOver..."
  liftOver tmp $CHAIN tmp.hg19 tmp.un

  echo "Checking and generating results..."
  sort -k1,1 -k2,2n tmp.hg19 | grep -v random | awk 'BEGIN{pc=0;ps=0;pl=0}{if(!($1==pc&&$2==ps)){print $0}pl=$0;ps=$2;pc=$1}' | awk -F "[\t,:]+" 'BEGIN{OFS="\t"}{print $1,$2,$3,"CpG:"$5,$10,$6,$7,$8,$9}' > tmp.filtered
  mv tmp.filtered $1.hg19

  echo "Generating tracks..."
  cut -f 1-3,5 $1.hg19 > tmp
  bedGraphToBigWig tmp $REF $1.bw

  rm tmp*

else
  echo "Usage: $0 <input.allelic>"
  echo "liftOver input.allelic from hg18 to hg19."
fi
