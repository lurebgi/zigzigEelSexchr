module unload java
module load java/1.8u152
module load gatk/4.1.4.0

sample=$(sed -n ${SLURM_ARRAY_TASK_ID}p $sample_list)
chr=$(sed -n ${SLURM_ARRAY_TASK_ID}p chr.list | cut -f 1)
#sample=$1
mkdir gvcf.out
/apps/java/1.8u152/bin/java -jar /apps/picard_tools/2.14.0/picard.jar CreateSequenceDictionary R=ZZ.fa O=ZZ.dict
#gatk --java-options -Xmx12G HaplotypeCaller --reference hap-Y.fa --input hap-Y.fa.$sample.dedup.bam --output $TMPDIR/$sample.$chr.g.vcf.gz --native-pair-hmm-threads 8 -L $chr -ERC GVCF
/apps/java/1.8u152/bin/java -jar /apps/gatk/nightly-2017-12-12/GenomeAnalysisTK.jar  -R zigzag.fa -T HaplotypeCaller -ERC GVCF -I bams/zigzag.fa.$sample.dedup.bam  -o $TMPDIR/$sample.$chr.g.vcf.gz -nct 4 -L $chr

mv $TMPDIR/$sample.$chr.g.vcf.gz* gvcf.out
