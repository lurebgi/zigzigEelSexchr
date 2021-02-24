#!/bin/bash

#SBATCH --job-name=hisat2_monk
#SBATCH --partition=basic
#SBATCH --cpus-per-task=16
#SBATCH --mem=38000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=hisat2-%j.out
#SBATCH --error=hisat2-%j.err

module load hisat2

hisat2-build zigzag.chrX.fa zigzag.chrX.fa

cp zigzag.chrX.fa* $TMPDIR

hisat2 -x $TMPDIR/zigzag.chrX.fa -p 10 -5 5 -3 5 -1 ../../transcriptome/link/blood_R1.fq.gz,../../transcriptome/link/brain_R1.fq.gz,../../transcriptome/link/eye_R1.fq.gz,../../transcriptome/link/fin_R1.fq.gz,../../transcriptome/link/gill_R1.fq.gz,../../transcriptome/link/gut_R1.fq.gz,../../transcriptome/link/heart_R1.fq.gz,../../transcriptome/link/liver_R1.fq.gz,../../transcriptome/link/muscle_R1.fq.gz,../../transcriptome/link/skin_R1.fq.gz,../../transcriptome/link/spleen_R1.fq.gz,../../transcriptome/link/testis_R1.fq.gz  -2 ../../transcriptome/link/blood_R2.fq.gz,../../transcriptome/link/brain_R2.fq.gz,../../transcriptome/link/eye_R2.fq.gz,../../transcriptome/link/fin_R2.fq.gz,../../transcriptome/link/gill_R2.fq.gz,../../transcriptome/link/gut_R2.fq.gz,../../transcriptome/link/heart_R2.fq.gz,../../transcriptome/link/liver_R2.fq.gz,../../transcriptome/link/muscle_R2.fq.gz,../../transcriptome/link/skin_R2.fq.gz,../../transcriptome/link/spleen_R2.fq.gz,../../transcriptome/link/testis_R2.fq.gz -S $TMPDIR/monk.sam -k 4 --max-intronlen 100000 --min-intronlen 20


samtools sort $TMPDIR/monk.sam   -@ 10 -O BAM -o $TMPDIR/hap-X.sort.bam

mv $TMPDIR/hap-X.sort.bam .
samtools index -@ 10 hap-X.sort.bam
 
