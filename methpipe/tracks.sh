#!/bin/bash
if [ $# == 2 ]
then
  NAME=${1%.}
  GENOME=$HOME/panfs/genome/coordinates/${2}.sizes
  METH=${NAME}.meth
  HMR=${NAME}.hmr
  PMR=${NAME}.pmr
  ALLE=${NAME}.allelic
  AMR=${NAME}.amr
  PMD=${NAME}.pmd

  if [ ! -e $GENOME ]
  then
    echo "[Chromosome sizes file not found!] $GENOME"
    exit 1
  fi

  if [ -e $METH ]
  then
    echo "[$METH found.]"
    FORMAT=$(head -n 1 $METH | awk '{if($6=="+"||$6=="-")print 1;else print 0}')
    if [ $FORMAT -eq 1 ]
    then
      # 1 for BED format; 0 for methcounts format
      # only keep sites that have coverage > 0
      if [ ! -e $METH.bw ]
      then
        echo "Generating $METH.bw..."
        awk -F "[\t,:]+" 'BEGIN{OFS="\t"}$5>0{print $1,$2,$2+1,$6}' ${METH} > temp$$
        bedGraphToBigWig temp$$ ${GENOME} ${METH}.bw
      fi

      if [ ! -e $NAME.read.bw ]
      then
        echo "Generating $NAME.read.bw..."
        awk -F "[\t,:]+" 'BEGIN{OFS="\t"}$5>0{print $1,$2,$2+1,$5}' ${METH} > temp$$
        bedGraphToBigWig temp$$ ${GENOME} ${NAME}.read.bw
      fi

    else
      if [ ! -e $METH.bw ]
      then
        echo "Generating $METH.bw..."
        awk 'BEGIN{OFS="\t"}$6>0{print $1,$2,$2+1,$5}' ${METH} > temp$$
        bedGraphToBigWig temp$$ ${GENOME} ${METH}.bw
      fi

      if [ ! -e $NAME.read.bw ]
      then
        echo "Generating $NAME.read.bw..."
        awk 'BEGIN{OFS="\t"}$6>0{print $1,$2,$2+1,$6}' ${METH} > temp$$
        bedGraphToBigWig temp$$ ${GENOME} ${NAME}.read.bw
      fi
    fi
  fi

  if [ -e $HMR ]
  then
    echo "[$HMR found.]"
    if [ ! -e $HMR.bb ]
    then
      echo "Generating $HMR.bb..."
      awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,0,$6}' ${HMR} | sort -k 1,1 -k 2,2n > temp$$
      bedToBigBed temp$$ ${GENOME} ${HMR}.bb
    fi
  fi

  if [ -e $PMR ]
  then
    echo "[$PMR found.]"
    if [ ! -e $PMR.bb ]
    then
      echo "Generating $PMR.bb..."
      awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,0,$6}' ${PMR} | sort -k 1,1 -k 2,2n > temp$$
      bedToBigBed temp$$ ${GENOME} ${PMR}.bb
    fi
  fi

  if [ -e $PMD ]
  then
    echo "[$PMD found.]"
    if [ ! -e $PMD.bb ]
    then
      echo "Generating $PMD.bb..."
      awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,0,$6}' ${PMD} | sort -k 1,1 -k 2,2n > temp$$
      bedToBigBed temp$$ ${GENOME} ${PMD}.bb
    fi
  fi

  if [ -e $ALLE ]
  then
    echo "[$ALLE found.]"
    if [ ! -e $ALLE.bw ]
    then
      echo "Generating $ALLE.bw..."
      awk 'BEGIN{OFS="\t"}{print $1,$2,$3,1-$5}' ${ALLE} > temp$$
      bedGraphToBigWig temp$$ ${GENOME} ${ALLE}.bw
    fi
  fi

  if [ -e $AMR ]
  then
    echo "[$AMR found.]"
    if [ ! -e $AMR.bb ]
    then
      echo "Generating $AMR.bb..."
      awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,0,$6}' ${AMR} | sort -k 1,1 -k 2,2n > temp$$
      bedToBigBed temp$$ ${GENOME} $AMR.bb
    fi
  fi

  if [ -e temp$$ ]
  then
    rm temp$$
  fi

else
  echo "Usage: $0 <name> <reference_genome>"
  echo "Generate USCS genome browser tracks from given data name."
  echo "Will search for <name>.meth, <name>.hmr and <name>.allelic."
  echo "Example: sh $0 Human_HSC hg19"
  echo " "
fi
