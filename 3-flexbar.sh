
# 1) moves UMIs to the header and 2) removes adapters

##############################################################
# user params
INDIR="/home/miav/scratch/Verheyden_GSE242306/1_filtered_fastq"
OUTDIR="/home/miav/scratch/Verheyden_GSE242306/2_adapter_removed/"
FLEXBAR_DIR="/home/miav/flexbar-3.5.0-linux"
BARCODES="/home/miav/Verheyden_GSE242306/barcodes_10nt.fa"

ADAPTER_CYCLES=2 # 2 for eCLIP, 1 for iCLIP
ADAPTERS="/home/miav/Verheyden_GSE242306/adapters.fa"
minReadLength=15 # default of racoon-clip

# NOTE: FOR ICLIP3, ADDITIONAL TRIMMING AT 3' END IS REQUIRED
##############################################################

mkdir -p $OUTDIR
cd $OUTDIR

export LD_LIBRARY_PATH="${FLEXBAR_DIR}:${LD_LIBRARY_PATH}"

for fastq_file in $INDIR/*.fastq; do

# extract basename
base_name=$(basename "$fastq_file")
base_name=${base_name%%.*}

echo "Processing sample: ${base_name}"

outfile="${base_name}.adapterRemoved.fastq"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
else

/home/miav/flexbar-3.5.0-linux/flexbar -r $fastq_file \
--threads 16 \
            --barcodes  $BARCODES \
            --barcode-unassigned \
            --barcode-trim-end LTAIL \
            --barcode-error-rate 0 \
            --adapters $ADAPTERS \
            --adapter-trim-end RIGHT \
            --adapter-error-rate 0.1 \
            --adapter-min-overlap 1 \
            --adapter-cycles $ADAPTER_CYCLES \
            --min-read-length $minReadLength \
            --umi-tags \
	    -t "$base_name"


mv "${base_name}_barcode_barcode.fastq" $outfile

fi
done
