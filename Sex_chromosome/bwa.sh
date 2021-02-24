module unload java
genome0=$1
read1=$2
read2=$3
size=$4
cpu=8

genome=$(echo ${genome0##*/})

## preparation for the reference
samtools faidx $genome0

#mkdir index
# alignment
if [ ! -f index/${genome}.bwt ] ; then
bwa index $genome0 -p index/$genome
fi
cp index/$genome* $TMPDIR

bwa mem -t $cpu -R $(echo "@RG\tID:$size\tSM:$size\tLB:$size"_"$size\tPL:ILLUMINA")   $TMPDIR/$genome $read1 $read2  |  samtools sort -@ $cpu -O BAM -o $TMPDIR/$genome.$size.sorted.bam  -
samtools index -@ $cpu $TMPDIR/$genome.$size.sorted.bam
mv $TMPDIR/$genome.$size.sorted.bam $TMPDIR/$genome.$size.sorted.bam.bai .


java -Xmx68g -jar /apps/picard/2.21.4/picard.jar  MarkDuplicates I=$TMPDIR/$genome.$size.sorted.bam O=$TMPDIR/$genome.$size.dedup.bam M=$TMPDIR/$size.m
samtools index -@ 8  $TMPDIR/$genome.$size.dedup.bam
mv $TMPDIR/$genome.$size.dedup.bam $TMPDIR/$genome.$size.dedup.bam.bai .
