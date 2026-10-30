# this part is a bit tricky
# Infer the canonical miRNA start from Bowtie2 trim5, leading CIGAR soft
# clipping, and the reference start. Trim after the full canonical length of
# the aligned miRNA, accounting for insertions and deletions in the CIGAR.
# (taken straight from racoon-clip; I'm still not sure exactly how this works)

##############################################################
# user params

SAM_INDIR="/home/miav/scratch/Verheyden_GSE242306/4_miR_aligned/" # SAM files are the aligned miR files
FASTQ_INDIR="/home/miav/scratch/Verheyden_GSE242306/2_adapter_removed/" # FASTQ file are from the flexbar step
MIR_FASTA="/home/miav/scratch/genomes/mouse_mir/mmu_mature_miR_miRGeneDB3.0.fasta" # MIR is the MIR genome fasta
OUTDIR="/home/miav/scratch/Verheyden_GSE242306/7_trimmed_miRs/"

##############################################################

mkdir -p $OUTDIR
cd $OUTDIR

for i in $SAM_INDIR/*sam; do

base_name=$(basename "$i")
base_name=${base_name%%.*}

outfile="$base_name.chim.trim.fastq.gz"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
else

python /home/miav/clip_pipeline/trim_mir_from_chimeric_reads.py \
            --sam $i \
            --fastq $FASTQ_INDIR/"$base_name.adapterRemoved.fastq" \
            --mir-fasta $MIR_FASTA \
            --output $outfile \
            --mir-starts-allowed "1 2 3 4" \
            --mir-5prime-missing-allowed "0 1 2 3" \
            --trim5 2
fi
done
