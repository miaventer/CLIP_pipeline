# get the first 24 nucleotides of each miR-eCLIP read

##############################################################
# user params

INDIR="/home/miav/scratch/Verheyden_GSE242306/3_miR_reads/"
OUTDIR="/home/miav/scratch/Verheyden_GSE242306/4_miR_aligned/"
MIR_INDEX_DIR="/home/miav/scratch/genomes/mouse_mir/mouse_index"

##############################################################

mkdir -p $OUTDIR
cd $OUTDIR

for fastq_file in $INDIR/*.fastq; do

# extract basename
base_name=$(basename "$fastq_file")
base_name=${base_name%%.*}

echo "Processing sample: ${base_name}"

outfile="${base_name}.miR.aligned.sam"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
else


bowtie2 -x $MIR_INDEX_DIR \
        -q $fastq_file \
        --local \
        -D 20 \
        -R 3 \
        -L 10 \
        -i S,1,0.50 \
        -k 20 \
        --norc \
        --trim5 2 \
        -S $outfile \
        --quiet \
        --sam-no-qname-trunc \
        --threads 16
fi
done
