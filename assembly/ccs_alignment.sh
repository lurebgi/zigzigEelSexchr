#!/bin/bash

#SBATCH --job-name=nucmer
#SBATCH --partition=himem
#SBATCH --cpus-per-task=24
#SBATCH --mem=36000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=nuc-%j.out
#SBATCH --error=nuc-%j.err

REF=$1
SAMPLE=$2
PWD=`pwd`
#source activate pipeline
export PWD
cpu=24
samtools faidx $REF
echo Minimap2

\time -v minimap2 -a -k 19 -O 5,56 -E 4,1 -B 5 -z 400,50 -r 2k -t $cpu -R "@RG\tSM:$SAMPLE\tID:$SAMPLE" --eqx --secondary=no $REF <(zcat dcq.ccs.part_*.fastq.gz)  2> minimap2.pacbioccs.log | samtools sort -@ $cpu -m2g --output-fmt BAM -o pacbioccs.fq.bam
samtools index -@ $cpu pacbioccs.fq.bam

#[ -d pb/split ] || mkdir -p pb/split
#cut -d$'\t' -f1 ${REF}.fai | parallel -j2 'samtools view -@10 -b pacbioccs.bam {} > pb/split/pacbioccs.{}.bam'
#cut -d$'\t' -f1 ${REF}.fai | parallel -j2 'samtools index -@10 pb/split/pacbioccs.{}.bam'

[ -d pb/vcf/ ] || mkdir -p pb/vcf

#echo DeepVariant.....
#cut -d$'\t' -f1 ${REF}.fai | parallel -j5 'sh dv.sh $PWD {} ${REF}'

#ls alignment/pacbioccs/vcf/*gz | parallel 'bgzip -cd {} > {.}'
#ls alignment/pacbioccs/vcf/*vcf | parallel "grep -E '^#|0/0|1/1|0/1|1/0|0/2|2/0' {} > {.}.filtered.vcf"
