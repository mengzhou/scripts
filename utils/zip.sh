#!/bin/bash
ppn=16
FILE=qsub_zip.sh

echo "#!/usr/bin/bash
#SBATCH -p cmb
#SBATCH -J zip_${PWD##*/}
#SBATCH -e ${PWD}/%x.e%j
#SBATCH -o ${PWD}/%x.o%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=$ppn
#SBATCH --time=48:00:00
#SBATCH --mem=15G
export PATH=$PATH
export PATH=$PATH

WD=\"${PWD}\"
cd \$WD

for i in \$(find . -name \"*.$1\")
do
  ~mengzhou/bin/pbzip2 \$i
done" | sed 's/auto/home/g' > $FILE
chmod 775 $FILE
