## filter raw fastq reads based on the quality of their barcodes

##############################################################
# user params
INDIR="/home/miav/scratch/Verheyden_GSE242306/raw_fastq/"
OUTDIR="/home/miav/scratch/Verheyden_GSE242306/1_filtered_fastq/"

barcode_length=10 # 10 for Verheyden (miR-eCLIP), 6 for Zhang (eCLIP where first 6 nt are the barcode)
min_base_quality=10
##############################################################

mkdir -p $OUTDIR
cd $OUTDIR

for fastq_file in $INDIR/*.fastq; do

# extract basename
base_name=$(basename "$fastq_file")
base_name=${base_name%%.*}

echo "Processing sample: ${base_name}"

outfile="${base_name}.data.qualFilteredIDs.list"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
else

cat ${fastq_file} | fastx_trimmer -Q33 -l $barcode_length | fastq_quality_filter -Q33 -q $min_base_quality -p 100 | awk 'FNR%4==1 { print $1 }' | sed 's/^@//' > "$outfile"

fi
done
