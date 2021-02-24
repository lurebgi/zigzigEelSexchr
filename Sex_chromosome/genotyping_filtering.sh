module load htslib
module load gatk/4.1.4.0
cat  sample.list |  while read line; do tabix -p vcf /scratch/luohao/eel/pop_gen/gvcf.out/$line.gvcf.gz;done
chr=$1

gatk --java-options -Xmx12G CombineGVCFs  -R hap-Y.fa --variant gvcf.out/C10.$chr.g.vcf.gz --variant gvcf.out/C1.$chr.g.vcf.gz --variant gvcf.out/C2.$chr.g.vcf.gz --variant gvcf.out/C3.$chr.g.vcf.gz --variant gvcf.out/C4.$chr.g.vcf.gz --variant gvcf.out/C5.$chr.g.vcf.gz --variant gvcf.out/C6.$chr.g.vcf.gz --variant gvcf.out/C7.$chr.g.vcf.gz --variant gvcf.out/C8.$chr.g.vcf.gz --variant gvcf.out/C9.$chr.g.vcf.gz --variant gvcf.out/X10.$chr.g.vcf.gz --variant gvcf.out/X1.$chr.g.vcf.gz --variant gvcf.out/X2.$chr.g.vcf.gz --variant gvcf.out/X3.$chr.g.vcf.gz --variant gvcf.out/X4.$chr.g.vcf.gz --variant gvcf.out/X5.$chr.g.vcf.gz --variant gvcf.out/X6.$chr.g.vcf.gz --variant gvcf.out/X7.$chr.g.vcf.gz --variant gvcf.out/X8.$chr.g.vcf.gz --variant gvcf.out/X9.$chr.g.vcf.gz  -O $TMPDIR/combined.$chr.vcf.gz
mv $TMPDIR/combined.$chr.vcf.gz* split.chr
gatk --java-options -Xmx12G GenotypeGVCFs  -R hap-Y.fa --variant  split.chr/combined.$chr.vcf.gz -O $TMPDIR/genotyped.$chr.vcf.gz -L $chr
mv $TMPDIR/genotyped.$chr.vcf.gz* split.chr


/apps/java/1.8u152/bin/java -jar /apps/gatk/3.8.0/GenomeAnalysisTK.jar -R hap-Y.fa -T SelectVariants -V split.chr/genotyped.$chr.vcf.gz -selectType SNP -o $TMPDIR/ZW.snp.vcf
/apps/java/1.8u152/bin/java -jar /apps/gatk/3.8.0/GenomeAnalysisTK.jar -R hap-Y.fa -T VariantFiltration -V $TMPDIR/ZW.snp.vcf --logging_level ERROR -window 10 -cluster 3  --filterExpression " QD < 2.0 || FS > 60.0 || MQRankSum < -12.5 || RedPosRankSum < -8.0 || SOR > 3.0 || MQ < 40.0 " --filterName "my_snp_filter" -o $TMPDIR/ZW.snp.filter.vcf
/apps/java/1.8u152/bin/java -jar /apps/gatk/3.8.0/GenomeAnalysisTK.jar -R hap-Y.fa -T SelectVariants -V $TMPDIR/ZW.snp.filter.vcf --excludeFiltered -o $TMPDIR/ZW.snp.zw15.final.vcf.gz
mv $TMPDIR/ZW.snp.zw15.final.vcf.gz split.chr/hap-Y.fa.$chr.final.vcf.gz
mv $TMPDIR/ZW.snp.zw15.final.vcf.gz.tbi split.chr/hap-Y.fa.$chr.final.vcf.gz.tbi
