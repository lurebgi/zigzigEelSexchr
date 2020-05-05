
cat alignment/50k.scf-list | while read line; do samtools view largestBlock_haplotagBAM/hic.pacbioccs.hic.$line.largestBlock.haplotag.bam |  grep 'HP:i:1' | awk '{print ">"$1"\n"$10}' ;done > partition_1/hp1.fa
cat alignment/50k.scf-list | while read line; do samtools view largestBlock_haplotagBAM/hic.pacbioccs.hic.$line.largestBlock.haplotag.bam |  grep 'HP:i:2' | awk '{print ">"$1"\n"$10}' ;done > partition_2/hp2.fa
