module unload python3
module unload tensorflow/2.3.0
module load relernn

ReLERNN_SIMULATE  -v zigzag.fa.final.filt.vcf -g genome.bed -d out --unphased -t 8
ReLERNN_TRAIN -t 8 --nEpochs 1000 --nEpochs 20 -d out
ReLERNN_PREDICT  -v zigzag.fa.final.filt.vcf -d out --unphased
