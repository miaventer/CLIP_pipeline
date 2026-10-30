
# get the first 24 nucleotides of each miR-eCLIP read

##############################################################
# user params

INDIR="/home/miav/scratch/Verheyden_GSE242306/2_adapter_removed/"
OUTDIR="/home/miav/scratch/Verheyden_GSE242306/3_miR_reads/"

##############################################################

mkdir -p $OUTDIR
cd $OUTDIR

for fastq_file in $INDIR/*.fastq; do

# extract basename
base_name=$(basename "$fastq_file")
base_name=${base_name%%.*}

echo "Processing sample: ${base_name}"
outfile="${base_name}.miR.24nt.fastq"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
else


cat $fastq_file | fastx_trimmer -l 24  -o $outfile

fi 
done
