#!/bin/bash

#SBATCH --job-name=split
#SBATCH --partition=himem
#SBATCH --cpus-per-task=24
#SBATCH --mem=36000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=nuc-%j.out
#SBATCH --error=nuc-%j.err

cat  curated.fasta.fai | cut -f 1|  while read line; do samtools view -@ 24 -h pacbioccs.fq.bam $line -O BAM -o $TMPDIR/pacbioccs.$line.bam; mv $TMPDIR/pacbioccs.$line.bam   pb/split/; samtools index -@ 24  pb/split/pacbioccs.$line.bam; done

cat  curated.fasta.fai | cut -f 1  | while read line; do samtools view -@ 24  -h hic/hic.fix.sort.md.bam $line -O BAM -o $TMPDIR/hic.$line.bam ; mv $TMPDIR/hic.$line.bam hic/split; samtools index -@ 24 hic/split/hic.$line.bam; done

#$HIC/hic.$SCAFFOLDS.bam
