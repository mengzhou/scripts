#!/bin/bash
# pair end
WD=
REF=/home/rcf-40/mengzhou/panfs/genome/
cd $WD
for i in $(find $WD -name "*_1.fastq???")
do
  j=$(echo $i | sed 's/_1\.fastq/_2.fastq/g')
  k=$(echo $i | sed 's/_1\.fastq/.fastq/g')
  python /home/rcf-40/mengzhou/bin/quick-rmapbs.py -o ${k}.mr -c $REF -r ${i},${j} -p -m 5000mb
done
