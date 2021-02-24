module load vcftools shapeit4 htslib

chr=$(sed -n ${SLURM_ARRAY_TASK_ID}p chr.list | cut -f 1)
bcftools view -m2 -M2 split.chr/hap-Y.fa.$chr.final.vcf.gz | sed "s#\t\.|\.#\t./.#g" | vcftools --vcf - --max-missing 0.9 --maf 0.05 --min-meanDP 4 --recode --recode-INFO-all --out $TMPDIR/m2.filt

/apps/java/1.8u152/bin/java -Xmx80g -jar /scratch/luohao/software/beagle.28Sep18.793.jar  gt=$TMPDIR/m2.filt.recode.vcf  out=$TMPDIR/snp.IM.$chr nthreads=1
mv $TMPDIR/snp.IM.$chr.* .

~/miniconda2/envs/phasing/bin/whatshap phase --max-coverage 16 --chromosome $chr -r hap-Y.fa -o snp.IM.Phase.$chr.vcf.gz snp.IM.$chr.vcf.gz  hap-Y.fa.*.dedup.bam
gunzip snp.IM.Phase.$chr.vcf.gz; bgzip snp.IM.Phase.$chr.vcf
tabix -p vcf snp.IM.Phase.$chr.vcf.gz
shapeit4 --input snp.IM.Phase.$chr.vcf.gz --output snp.IM.Phase.$chr.phase.vcf.gz --region $chr
