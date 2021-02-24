module load hisat2

spe=$1
read1=$2
read2=$3
sample=$4

#mkdir index
hisat2-build $spe.fa index/$spe.fa.idx

cp index/$spe.fa.idx* $TMPDIR

hisat2 -x $TMPDIR/$spe.fa.idx -p 8 -1 $read1 -2 $read2 -S $TMPDIR/$sample.sam -k 4
samtools sort  $TMPDIR/$sample.sam  -@ 8 -O BAM -o $TMPDIR/$sample.sort.bam

mv $TMPDIR/$sample.sort.bam .
samtools index -@ 4 $sample.sort.bam
