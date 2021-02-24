module load plink
##Convert to plink input format
perl getSnpPlink.pl all.sample all.haps  All.snp.map All.snp.ped
plink --file All.snp --out All.snp --make-bed --allow-extra-chr --allow-no-sex

##generate tped/tfam
plink --bfile All.snp --chr-set 24 --allow-extra-chr --allow-no-sex --recode 12 transpose --output-missing-genotype 0 --out All.snp
plink --bfile All.snp --chr-set 24 --allow-extra-chr --pca --out All.snp

sed -i 's/Chr//' All.snp.tped

##make phenotype file
awk '{print $1,$2,$6}' All.snp.tfam > All.snp.pheno

#ibs-kinship
/scratch/luohao/software/./emmax-kin-intel64 -v  -s -d 10 All.snp
/scratch/luohao/software/./emmax-kin-intel64 -v  -d 10 All.snp
awk 'BEGIN{a=1}{printf("%s %s ",$1,$2);printf("%s ",a);for(i=3;i<6;i++){printf("%s ",$i)}printf("%s","\n")}' All.snp.eigenvec > All.snp.cov
##run emmax
/scratch/luohao/software/./emmax-intel64 -v -d 10 -t All.snp -p All.snp.pheno -c All.snp.cov -k All.snp.aIBS.kinf  -o All.snp.hIBS
/scratch/luohao/software/./emmax-intel64 -v -d 10 -t All.snp -p All.snp.pheno -c All.snp.cov -k All.snp.aBN.kinf  -o All.snp.hBN
