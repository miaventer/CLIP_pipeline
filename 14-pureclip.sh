# merge bam files according to biological group
# if miR-eCLIP, then chimeric bams will be in 11_chimeric_dedup
# and nonchimeric reads will be in 11_nonchimeric_dedup
# If regular eCLIP, then reads will be in 5_dedup

##############################################################
# user params

experiment="miR-eCLIP"
base_directory="/home/miav/scratch/Verheyden_GSE242306"
group_file="/home/miav/clip_pipeline/merge_groups.txt"
GENOME_DIR="/home/miav/scratch/genomes/mm39/GRCm39.primary_assembly.genome.fa"

##############################################################

if [ "$experiment" = "miR-eCLIP" ]; then
    CHIM_INDIR="9_chimeric_dedup"
    NONCHIM_INDIR="9_nonchimeric_dedup"
    OUTDIR="10_pureclip"
    mkdir -p $base_directory/$OUTDIR

   cd $base_directory/$OUTDIR

CONDITIONS=$(awk -F',' '{print $1}' "$group_file" | sort -u)

for COND in $CONDITIONS; do
    OUTFILE="$COND.merged.bam"

s="$(awk -F',' -v cond="$COND" -v dir="$base_directory/$CHIM_INDIR" '$1==cond {print dir "/" "chimeric." $2 ".dedup.bam"}' "$group_file")"

samtools merge -f "chimeric.$OUTFILE" $s
samtools index "chimeric.$OUTFILE"

s="$(awk -F',' -v cond="$COND" -v dir="$base_directory/$NONCHIM_INDIR" '$1==cond {print dir "/" "non.chimeric." $2 ".dedup.bam"}' "$group_file")"

samtools merge -f "non.chimeric.$OUTFILE" $s
samtools index "non.chimeric.$OUTFILE"

done


else # regular eCLIP

INDIR="5_dedup"
OUTDIR="10_pureclip"
mkdir -p $base_directory/$OUTDIR

cd $base_directory/$OUTDIR

CONDITIONS=$(awk -F',' '{print $1}' "$group_file" | sort -u)

for COND in $CONDITIONS; do
    OUTFILE="$COND.merged.bam"

s="$(awk -F',' -v cond="$COND" -v dir="$base_directory/$INDIR" '$1==cond {print dir "/" $2 ".dedup.bam"}' "$group_file")"

samtools merge -f "$OUTFILE" $s
samtools index "$OUTFILE"

done
fi

# pureclip on whatever is in the pureclip directory
for bam_file in $base_directory/"10_pureclip"/*bam; do

file_name="${bam_file##*/}"
base_name="${file_name%%.merged*}"

echo "Performing PureClip on $base_name"

/home/miav/PureCLIP/build/pureclip -i $bam_file -bai $bam_file.bai -g $GENOME_DIR -iv 'chr1;chr2;chr3;' -nt 16 -o $base_name.crosslink_sites.bed -or $base_name.crosslink_regions.bed 

done





















