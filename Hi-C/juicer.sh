module unload perl java
module load juicer bwa

spe=$1
chr=$1
bwa index $spe.fa
samtools faidx $spe.fa; cut -f 1,2 $spe.fa.fai > $spe.fa.sizes
cp $spe.fa  $spe.fa.* /apps/juicer/1.7.6/references/
juicer.sh -t 8 -g $spe -s MboI  -D /apps/juicer/1.7.6 -y $spe.fa_MboI.txt  -z /apps/juicer/1.7.6/references/$spe.fa -p $spe.fa.sizes


java -jar /scratch/luohao/software/3d-dna/visualize/juicebox_tools.jar pre aligned/merged_nodups.txt $chr.hic hap-Y.fa.sizes  -d true -f hap-Y.fa_MboI.txt -c $chr
java -jar /scratch/luohao/software/3d-dna/visualize/juicebox_tools.jar dump observed KR $chr.hic $chr $chr BP 50000 $chr.hic.50k
java -jar /scratch/luohao/software/3d-dna/visualize/juicebox_tools.jar eigenvector KR $chr.hic $chr BP 250000 $chr.50k.hic.AB-250k
