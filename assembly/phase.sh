#!/bin/bash

#SBATCH --job-name=phasing
#SBATCH --partition=basic
#SBATCH --cpus-per-task=1
#SBATCH --mem=12000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=log/nuc-%j.out
#SBATCH --error=log/nuc-%j.err

HIC=alignment/hic/split
VCF=alignment/pb/vcf/
REF=$1
SAMPLE=$2
#SCAFFOLDS=$(sed -n ${SLURM_ARRAY_TASK_ID}p alignment/50k.scf-list | cut -f 1)
SCAFFOLDS=$(sed -n ${SLURM_ARRAY_TASK_ID}p alignment/curated.fasta.fai.50k | cut -f 1)
export HIC
export VCF
export SAMPLE
export REF

[ -d hapcut2 ] || mkdir -p hapcut2
[ -d whatshap ] || mkdir -p whatshap
[ -d haplotag ] || mkdir -p haplotag
echo HapCUT2 phasing

bcftools view  $VCF/$SCAFFOLDS.final.vcf.gz  > $TMPDIR/$SCAFFOLDS.final.vcf
/scratch/luohao/software/hapcut2/build/extractHAIRS --bam $HIC/hic.$SCAFFOLDS.bam --hic 1 --VCF $TMPDIR/$SCAFFOLDS.final.vcf --out hapcut2/hic.$SCAFFOLDS.frag --maxIS 30000000 2> hapcut2/extractHAIRS.$SCAFFOLDS.log 
/scratch/luohao/software/hapcut2/build/HAPCUT2 --fragments hapcut2/hic.$SCAFFOLDS.frag --VCF $TMPDIR/$SCAFFOLDS.final.vcf --output hapcut2/hic.$SCAFFOLDS.hap --hic 1 2> hapcut2/HAPCUT2.$SCAFFOLDS.log
cut -d$'\t' -f1-11 hapcut2/hic.$SCAFFOLDS.hap > hapcut2/hic.$SCAFFOLDS.hap.cut
~/miniconda2/envs/phasing/bin/whatshap hapcut2vcf $TMPDIR/$SCAFFOLDS.final.vcf hapcut2/hic.$SCAFFOLDS.hap.cut -o hapcut2/hic.$SCAFFOLDS.phased.vcf

echo WhatsHap phasing

~/miniconda2/envs/phasing/bin/whatshap phase --reference $REF $TMPDIR/$SCAFFOLDS.final.vcf hapcut2/hic.$SCAFFOLDS.phased.vcf alignment/pb/split/pacbioccs.$SCAFFOLDS.bam -o whatshap/pacbioccs.hic.$SCAFFOLDS.whatshap.phased.vcf 2> whatshap/whatshap.$SCAFFOLDS.log

module load htslib
bgzip -c whatshap/pacbioccs.hic.$SCAFFOLDS.whatshap.phased.vcf > whatshap/pacbioccs.hic.$SCAFFOLDS.whatshap.phased.vcf.gz
tabix -p vcf whatshap/pacbioccs.hic.$SCAFFOLDS.whatshap.phased.vcf.gz

~/miniconda2/envs/phasing/bin/whatshap haplotag --reference $REF whatshap/pacbioccs.hic.$SCAFFOLDS.whatshap.phased.vcf.gz alignment/pb/split/pacbioccs.$SCAFFOLDS.bam -o haplotag/$SAMPLE.pacbioccs.hic.$SCAFFOLDS.haplotag.bam 2> haplotag/haplotag.$SCAFFOLDS.log

[ -d largestBlock_vcf ] || mkdir -p largestBlock_vcf
[ -d largestBlock_haplotagBAM ] || mkdir -p largestBlock_haplotagBAM

CHR=$SCAFFOLDS
  PS=`grep -v '^#' whatshap/pacbioccs.hic.${CHR}.whatshap.phased.vcf | grep 'PS' | cut -d':' -f11 | sort | uniq -cd | sort -k1nr | head -1 | awk '{print $2}'`
  grep -E "^#|$PS$" whatshap/pacbioccs.hic.${CHR}.whatshap.phased.vcf > largestBlock_vcf/pacbioccs.hic.${CHR}.phased.largestBlock.vcf


bgzip -c largestBlock_vcf/pacbioccs.hic.$SCAFFOLDS.phased.largestBlock.vcf > largestBlock_vcf/pacbioccs.hic.$SCAFFOLDS.phased.largestBlock.vcf.gz
tabix -p vcf largestBlock_vcf/pacbioccs.hic.$SCAFFOLDS.phased.largestBlock.vcf.gz
~/miniconda2/envs/phasing/bin/whatshap haplotag --reference $REF largestBlock_vcf/pacbioccs.hic.$SCAFFOLDS.phased.largestBlock.vcf.gz alignment/pb/split/pacbioccs.$SCAFFOLDS.bam -o largestBlock_haplotagBAM/${SAMPLE}.pacbioccs.hic.$SCAFFOLDS.largestBlock.haplotag.bam 2> largestBlock_haplotagBAM/haplotag.$SCAFFOLDS.log
