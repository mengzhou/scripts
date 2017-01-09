#!/bin/bash
if [ $# == 3 ]
then
  OUTFILE=$3
  if [ -e $OUTFILE ]
  then
    rm $OUTFILE
  fi
  NF=$(head -1 $2 | awk '{print NF}')
  if [ $NF != 6 ]
  then
    echo "Input file format is not correct!"
    exit
  fi
  TOTAL=$(cat $2 | wc -l)
  COUNT=1
  while read chr start end name score strand
    do
      echo "${COUNT}/${TOTAL}"
      COUNT=$(expr $COUNT + 1)
      echo ">"$name >> $OUTFILE
      if [ $strand == "+" ]
      then
        python ~/bin/get_seq_from_fasta.py ${1%/}/$chr.fa $start $end \
          | fold -w 50 >> $OUTFILE
      else
        python ~/bin/get_seq_from_fasta.py ${1%/}/$chr.fa $start $end \
          | python ~/bin/get_revcomp.py | fold -w 50 >> $OUTFILE
      fi
  done < $2
else
  echo "Usage: $0 <path_to_genome> <input.bed> <output.fa>"
  echo ""
  echo "Input BED must have the following columns:"
  echo "chr start end name score strand"
fi
