# deduplicate aligned reads

##############################################################
# user params
experiment="miR-eCLIP" # either miR-eCLIP or eCLIP
base_directory="/home/miav/scratch/Verheyden_GSE242306"

##############################################################

if [ "$experiment" = "miR-eCLIP" ]; then
    CHIM_OUTDIR="9_chimeric_dedup"
    NONCHIM_OUTDIR="9_nonchimeric_dedup"
    CHIM_INDIR="8_chimeric_aligned"
    NONCHIM_INDIR="8_nonchimeric_aligned"

    mkdir -p $base_directory/$CHIM_OUTDIR
    mkdir -p $base_directory/$NONCHIM_OUTDIR

   # chimeric
   cd $base_directory/$CHIM_OUTDIR
   for bam_file in $base_directory/$CHIM_INDIR/*Aligned.sortedByCoord.out.bam; do

file_name="${bam_file##*/}"
base_name="${file_name%%.Aligned*}"
   
   outfile="${base_name}.dedup.bam"

   if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
   else

echo "Processing sample: $base_name"

umi_tools dedup -I $bam_file -L "$base_name.dedup.log" -S "$base_name.dedup.bam" --extract-umi-method read_id --method unique
fi
done

   # non-chimeric
   cd $base_directory/$NONCHIM_OUTDIR
   for bam_file in $base_directory/$NONCHIM_INDIR/*Aligned.sortedByCoord.out.bam; do

file_name="${bam_file##*/}"
base_name="${file_name%%.Aligned*}"

   outfile="${base_name}.dedup.bam"

   if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
   else
echo "Processing sample: $base_name"

umi_tools dedup -I $bam_file -L "$base_name.dedup.log" -S "$base_name.dedup.bam" --extract-umi-method read_id --method unique
fi
done

else
    OUTDIR="5_dedup"
    mkdir -p  $base_directory/$OUTDIR

    INDIR="4_aligned"

    cd  $base_directory/$OUTDIR

   for bam_file in $base_directory/$INDIR/*Aligned.sortedByCoord.out.bam; do

file_name="${bam_file##*/}"
base_name="${file_name%%.Aligned*}"

   outfile="${base_name}.dedup.bam"

   if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
   else

   echo "Processing sample: $base_name"

umi_tools dedup -I $bam_file -L "$base_name.dedup.log" -S "$base_name.dedup.bam" --extract-umi-method read_id --method unique

fi
done

fi















