#!/bin/bash

#SBATCH --job-name=hicmap
#SBATCH --partition=himem
#SBATCH --cpus-per-task=24
#SBATCH --mem=36000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=nuc-%j.out
#SBATCH --error=nuc-%j.err

REF=$1
SAMPLE=$2
read1=$3
read2=$4
#source activate pipeline
export REF
export SAMPLE


echo Hi-C data aligning.....
[ -d hic ] || mkdir -p hic

bwa index $REF -p $REF.idx
cp $REF.idx* $TMPDIR

cpu=24
bwa mem -t $cpu -R '@RG\tSM:$SAMPLE\tID:$SAMPLE' -B 8 -M $TMPDIR/$REF.idx $read1 | samtools sort -@ $cpu -m2g -O BAM -n > $TMPDIR/read1.nsort.bam
mv $TMPDIR/read1.nsort.bam .
bwa mem -t $cpu -R '@RG\tSM:$SAMPLE\tID:$SAMPLE' -B 8 -M $TMPDIR/$REF.idx $read2 | samtools sort -@ $cpu -m2g -O BAM -n > $TMPDIR/read2.nsort.bam
mv $TMPDIR/read2.nsort.bam .
module load hapcut2
/apps/python2/2.7.15/bin/python /scratch/luohao/software/hapcut2/utilities/HiC_repair.py -b1 read1.nsort.bam -b2 read2.nsort.bam  -o $TMPDIR/repaired.bam -m 10
samtools fixmate -@ $cpu  $TMPDIR/repaired.bam - | samtools sort -@ $cpu -m 2G - > hic/hic.fix.sort.bam
samtools index -@ $cpu hic/hic.fix.sort.bam


# For HiC_repair.py, manually change line:229, output str to 'wb', for compressed BAM output.
\time /scratch/luohao/software//biobambam2/2.0.87-release-20180301132713/x86_64-etch-linux-gnu/bin/bammarkduplicates  I=hic/hic.fix.sort.bam  O=hic/hic.fix.sort.md.bam  M=markdup.metrics markthreads=$cpu rmdup=1 index=1 tmpfile=$TMPDIR 2> hic.markdup.log

#parallel -j7 'samtools view -b -@10 hic/hic.fix.sort.md.bam {} > hic/split/hic.{}.bam' ::: `cut -d$'\t' -f1 ${REF}.fai`
