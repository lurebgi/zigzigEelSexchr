#!/bin/bash

#SBATCH --job-name=gatk
#SBATCH --partition=basic
#SBATCH --cpus-per-task=1
#SBATCH --mem=12000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=log/nuc-%j.out
#SBATCH --error=log/nuc-%j.err

module load gatk/4.1.3.0

REF=$1
scf=$(sed -n ${SLURM_ARRAY_TASK_ID}p curated.fasta.fai.50k | cut -f 1)
scf=$(sed -n ${SLURM_ARRAY_TASK_ID}p unfinished | cut -f 1)
#scf=$2
#scf=$2
#/scratch/luohao/software/biobambam2/2.0.87-release-20180301132713/x86_64-etch-linux-gnu/bin/bammarkduplicates2  I=pb/split/pacbioccs.$scf.bam  O=pb/split/pacbioccs.$scf.rmdup.bam M=markdup.metrics markthreads=4 index=1 tmpfile=$TMPDIR
#java -Xmx88g -jar /apps/picard/2.21.4/picard.jar  MarkDuplicates I=pb/split/pacbioccs.$scf.bam O=pb/split/pacbioccs.$scf.rmdup.bam M=$size.m use_jdk_deflater=true use_jdk_inflater=true

#/apps/java/1.8u152/bin/java -jar /apps/picard/2.21.4/picard.jar  CreateSequenceDictionary R=zigzag.fa O=zigzag.dict

gatk --java-options -Xmx12G HaplotypeCaller \
        --native-pair-hmm-threads 4 \
        --reference ${REF} \
        --input pb/split/pacbioccs.$scf.bam  \
        --output pb/vcf/$scf.vcf \
        --pcr-indel-model AGGRESSIVE \
        --minimum-mapping-quality 60 \
        --intervals $scf #--disable-read-filter WellformedReadFilter --disable-read-filter MappingQualityReadFilter

#AS_QD < 2.0 
