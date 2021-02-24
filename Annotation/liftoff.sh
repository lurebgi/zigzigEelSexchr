#!/bin/bash

#SBATCH --job-name=liftoff
#SBATCH --partition=basic
#SBATCH --cpus-per-task=16
#SBATCH --mem=6000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=nuc-%j.out
#SBATCH --error=nuc-%j.err


/apps/liftoff/1.2.1/liftoff1.2.1/bin/liftoff -t /proj/luohao/eel/assembly/zigzag.hap-Y.chrPhase.fa.gapclosed -r  /proj/luohao/eel/assembly/zigzag.fa -g zigzag.gff -p 16 -o hap-Y.gff -m /apps/minimap2/2.17/minimap2 -dir $TMPDIR
/apps/liftoff/1.2.1/liftoff1.2.1/bin/liftoff -t /proj/luohao/eel/assembly/zigzag.hap-X.chrPhase.fa.gapclosed -r  /proj/luohao/eel/assembly/zigzag.fa -g zigzag.gff -p 16 -o hap-X.gff -m /apps/minimap2/2.17/minimap2 -dir $TMPDIR
