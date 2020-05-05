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
scf=$(sed -n ${SLURM_ARRAY_TASK_ID}p 50k.scf-list | cut -f 1)
#scf=$2
#scf=$(sed -n ${SLURM_ARRAY_TASK_ID}p 50k.scf-list.unfinished | cut -f 1)
#scf=$2
/apps/java/1.8u152/bin/java -jar /apps/picard/2.21.4/picard.jar  CreateSequenceDictionary R=zigzag.fa O=zigzag.dict

#gatk --java-options -Xmx12G SelectVariants  -R $REF  -V pb/vcf/$scf.vcf -select-type  SNP -O $TMPDIR/ZW.snp.vcf.gz
gatk --java-options -Xmx12G VariantFiltration  -R $REF  -V pb/vcf/$scf.vcf  --filter-name "my_filter1" --filter-expression  " QD < 2.0 || FS > 60.0 || MQRankSum < -12.5 || RedPosRankSum < -8.0 || SOR > 3.0 || MQ < 40.0 " -O $TMPDIR/ZW.snp.filter.vcf
gatk --java-options -Xmx12G SelectVariants  -R $REF -V $TMPDIR/ZW.snp.filter.vcf --exclude-filtered  -O $TMPDIR/ZW.snp.zw15.final.vcf.gz
mv $TMPDIR/ZW.snp.zw15.final.vcf.gz pb/vcf/$scf.final.vcf.gz
mv $TMPDIR/ZW.snp.zw15.final.vcf.gz.tbi pb/vcf/$scf.final.vcf.gz.tbi
