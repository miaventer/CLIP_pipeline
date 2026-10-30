# split chimeric vs non-chimeric reads


##############################################################
# user params

INDIR="/home/miav/scratch/Verheyden_GSE242306/4_miR_aligned/"
OUTDIR="/home/miav/scratch/Verheyden_GSE242306/5_split_chimeric/"

##############################################################

mkdir -p $OUTDIR
cd $OUTDIR

for sam_file in $INDIR/*.sam; do

# extract basename
base_name=$(basename "$sam_file")
base_name=${base_name%%.*}

echo "Processing sample: ${base_name}"

outfile="${base_name}.chimeric.bam"

if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
else

samtools view -F 4 -b $sam_file > $base_name.chimeric.bam && \
samtools view -f 4 $sam_file | awk -v FS='\t' -v OFS='\t' '{ print $1 > "'"$base_name"'.non.chimeric.list" }'

fi
done



