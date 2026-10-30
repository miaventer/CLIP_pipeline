# align fastq reads with STAR
# if the reads come from regular eCLIP, they will be stored in 2_adapter_removed
# if the reads are from miR-eCLIP, the chimeric ones will be in 7_trimmed_miRs
# and the non-chimeric ones will be in 6_fastq_non_chimeric

##############################################################
# user params
experiment="miR-eCLIP" # either miR-eCLIP or eCLIP
base_directory="/home/miav/scratch/Verheyden_GSE242306"

GENOME_INDEX_DIR="/home/miav/scratch/genomes/mm39/"
GTF_FILE="/home/miav/scratch/genomes/mm39/gencode.vM39.basic.annotation.gtf"

##############################################################

if [ "$experiment" = "miR-eCLIP" ]; then
    CHIM_OUTDIR="8_chimeric_aligned"
    NONCHIM_OUTDIR="8_nonchimeric_aligned"
    CHIM_INDIR="7_trimmed_miRs"
    NONCHIM_INDIR="6_fastq_nonchimeric"

    mkdir -p $base_directory/$CHIM_OUTDIR
    mkdir -p $base_directory/$NONCHIM_OUTDIR

   # chimeric
   cd $base_directory/$CHIM_OUTDIR

   for fastq_file in $base_directory/$CHIM_INDIR/*fastq.gz; do

base_name=$(basename "$fastq_file")
base_name=${base_name%%.*}

   outfile="chimeric.${base_name}.Aligned.sortedByCoord.out.bam"

   if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
   else

echo "Processing sample: $base_name"

STAR --runMode alignReads \
        --genomeDir $GENOME_INDEX_DIR \
        --outFileNamePrefix "chimeric.${base_name}." \
        --outFilterMismatchNoverReadLmax 0.04 \
        --outFilterMismatchNmax 999 \
        --outFilterMultimapNmax 1 \
        --alignEndsType "Extend5pOfRead1" \
        --sjdbGTFfile $GTF_FILE \
        --outReadsUnmapped "Fastx" \
        --outSJfilterReads "Unique" \
        --outSAMtype BAM SortedByCoordinate \
	--readFilesCommand zcat \
        --readFilesIn $fastq_file \
        --runThreadN 16
fi
done # chimeric star


# non-chimeric
cd $base_directory/$NONCHIM_OUTDIR

for fastq_file in $base_directory/$NONCHIM_INDIR/*.fastq; do

base_name=$(basename "$fastq_file")
base_name=${base_name%%.*}

   outfile="non.chimeric.${base_name}.Aligned.sortedByCoord.out.bam"

   if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
   else

echo "Processing sample: $base_name"

	STAR --runMode alignReads \
        --genomeDir $GENOME_INDEX_DIR \
        --outFileNamePrefix "non.chimeric.${base_name}." \
        --outFilterMismatchNoverReadLmax 0.04 \
        --outFilterMismatchNmax 999 \
        --outFilterMultimapNmax 1 \
        --alignEndsType "Extend5pOfRead1" \
        --sjdbGTFfile $GTF_FILE \
        --outReadsUnmapped "Fastx" \
        --outSJfilterReads "Unique" \
        --outSAMtype BAM SortedByCoordinate \
        --readFilesIn $fastq_file \
        --runThreadN 16

fi
done # end of chimeric star loop

else
    OUTDIR="4_aligned"
    mkdir -p  $base_directory/$OUTDIR
    
    INDIR="2_adapter_removed"

    cd  $base_directory/$OUTDIR

for fastq_file in $base_directory/$INDIR/*fastq; do

base_name=$(basename "$fastq_file")
base_name=${base_name%%.*}

   outfile="${base_name}.Aligned.sortedByCoord.out.bam"

   if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
   else

echo "Processing sample: $base_name"

        STAR --runMode alignReads \
        --genomeDir $GENOME_INDEX_DIR \
        --outFileNamePrefix "${base_name}." \
        --outFilterMismatchNoverReadLmax 0.04 \
        --outFilterMismatchNmax 999 \
        --outFilterMultimapNmax 1 \
        --alignEndsType "Extend5pOfRead1" \
        --sjdbGTFfile $GTF_FILE \
        --outReadsUnmapped "Fastx" \
        --outSJfilterReads "Unique" \
        --outSAMtype BAM SortedByCoordinate \
        --readFilesIn $fastq_file \
        --runThreadN 16

fi
done # end of regular clip star loop

fi


