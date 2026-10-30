# make fastq file for non-chimeric reads
# each adapter removed file from Flexbar dir will have non-chimeric reads,
# determined with the non.chimeric.list

##############################################################
# user params

LIST_INDIR="/home/miav/scratch/Verheyden_GSE242306/5_split_chimeric/"
FASTQ_INDIR="/home/miav/scratch/Verheyden_GSE242306/2_adapter_removed/" 
OUTDIR="/home/miav/scratch/Verheyden_GSE242306/6_fastq_nonchimeric/"

##############################################################

mkdir -p $OUTDIR
cd $OUTDIR

for i in $LIST_INDIR/*non.chimeric.list; do

base_name=$(basename "$i")
base_name=${base_name%%.*}
echo "Processing file: $base_name"

outfile="$base_name.nonchimeric.sorted.fastq"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
else


seqkit grep -n --quiet -f $i  $FASTQ_INDIR/"${base_name}.adapterRemoved.fastq" > "$base_name.nonchimeric.fastq" && \
seqkit sort -n "$base_name.nonchimeric.fastq" > $outfile
#rm "$base_name.nonchimeric.fastq" # to save space

fi
done
