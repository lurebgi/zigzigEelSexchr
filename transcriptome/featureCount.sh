module load subread

bam=$1
ls *.bam | while read bam; do
cat sample.list  |  cut -f 2 | while read line; do
/apps/subread/1.6.2/bin/featureCounts -C --tmpDir $TMPDIR -M  -F GTF -p  -a zigzag.XY.gtf  -T 8 -o $bam.M.count  $bam

done
