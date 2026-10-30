# index bam files created by alignment with STAR

##############################################################
# user params
experiment="miR-eCLIP" # either miR-eCLIP or eCLIP
base_directory="/home/miav/scratch/Verheyden_GSE242306"

##############################################################

if [ "$experiment" = "miR-eCLIP" ]; then
    CHIM_INDIR="8_chimeric_aligned"
    NONCHIM_INDIR="8_nonchimeric_aligned"

   # chimeric
   cd $base_directory/$CHIM_INDIR
   for bam_file in $base_directory/$CHIM_INDIR/*Aligned.sortedByCoord.out.bam; do

samtools index $bam_file
done

   # non-chimeric
   cd $base_directory/$NONCHIM_INDIR
   for bam_file in $base_directory/$NONCHIM_INDIR/*Aligned.sortedByCoord.out.bam; do

samtools index $bam_file
done

else
    INDIR="4_aligned"

    cd  $base_directory/$INDIR

   for bam_file in $base_directory/$INDIR/*Aligned.sortedByCoord.out.bam; do
samtools index $bam_file
done

fi















