module load vcftools


bcftools view -M2 -m2  split.chr/hap-Y.fa.merge.vcf.gz |  vcftools  --vcf - --maf 0.05 --min-meanDP 4 --max-missing 0.9  --recode --recode-INFO-all --out temp &
vcftools --vcf temp.recode.vcf  --weir-fst-pop sample.list.female --weir-fst-pop sample.list.male  --fst-window-size 10000 --fst-window-step 5000 --out fst.v2
