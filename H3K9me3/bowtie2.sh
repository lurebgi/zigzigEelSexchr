module load samtools
module load bowtie2
module load bedtools

genome0=$1
reads1=$2
reads2=$3
size=$4
dir=`pwd`
win=100k

genome=$(echo ${genome0##*/})

bowtie2-build $genome $genome --threads 8
#bwa index $genome

cp ${genome}.* $TMPDIR

# mapping the reads, select unique reads, and sort the bam file

bowtie2 --local --very-sensitive-local --no-unal --no-mixed --no-discordant -I 10 -X 700  -p 8 -x $TMPDIR/$genome -1 $reads1 -2 $reads2 | samtools view -hS - |  grep -e "^@" -e "XM:i:[012][^0-9]"  |  grep -v "XS:i:" | samtools sort -@ 8 -o $genome.$size.uniq.sorted.bam  - -O BAM

samtools rmdup  $genome.$size.uniq.sorted.bam $genome.$size.uniq.sorted.rmdup.bam

samtools index $genome.$size.uniq.sorted.rmdup.bam

# count reads
bedtools genomecov -ibam $genome.$size.uniq.sorted.rmdup.bam -d  -pc > $genome.$size.uniq.sorted.rmdup.bam.count
