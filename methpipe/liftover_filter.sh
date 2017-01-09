#!/bin/bash
if [ $1 ]
then
  NAME=${1%.*}
  REF=$HOME/panfs/genome/coordinates/hg19.sizes
  # 1 for BED format; 0 for methcounts format
  FORMAT=$(head -n 1 $1 | awk '{if($6=="+"||$6=="-")print 1;else print 0}')
  echo "Sorting..."
  sort -k1,1 -k2,2n $1 | grep -v random | awk 'BEGIN{pc=0;ps=0;pl=0}{if(!($1==pc&&$2==ps)){print $0}pl=$0;ps=$2;pc=$1}' > tmp
  mv tmp $1

  echo "Converting to $1.bw..."
  if [ $FORMAT -eq 1 ]
  then
    cut -f 1-3,5 $1 > tmp
  else
    awk 'BEGIN{OFS="\t"}{print $1,$2,$2+1,$5}' $1 > tmp
  fi
  bedGraphToBigWig tmp $REF ${1}.bw

  echo "Converting to ${1%.*}.read.bw..."
  if [ $FORMAT -eq 1 ]
  then
    awk -F "[\t,:]+" 'BEGIN{OFS="\t"}{print $1,$2,$3,$5}' $1 > tmp
  else
    awk 'BEGIN{OFS="\t"}{print $1,$2,$2+1,$6}' $1 > tmp
  fi
  bedGraphToBigWig tmp $REF ${1%.*}.read.bw
  rm tmp
else
  echo "Usage: $0 <input.meth>"
  echo "Check and convert .meth file (liftover from hg18 to hg19) to .meth.bw and .read.bw"
fi
