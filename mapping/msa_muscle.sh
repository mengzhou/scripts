if [ ! -e $1 ]
then
  echo "Input file $1 not found!"
  exit 1
fi
#-1. Input file, a consensus .fa file
INPUT_FA=$1
NAME=${INPUT_FA%.*}

#0. Paths
MSA_PROG=/home/rcf-40/mengzhou/panfs/tools/muscle3.8.31_i86linux64

$MSA_PROG -in $INPUT_FA -clw > ${NAME}.aln
