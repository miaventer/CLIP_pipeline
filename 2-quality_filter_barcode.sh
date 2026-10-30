## filter raw fastq reads based on the quality of their barcodes

##############################################################
# user params
INDIR="/home/miav/scratch/Verheyden_GSE242306/raw_fastq/"
OUTDIR="/home/miav/scratch/Verheyden_GSE242306/1_filtered_fastq/"

##############################################################

cd $OUTDIR

for i in $INDIR/*; do

# extract basename
base_name=$(basename "$i")
base_name=${base_name%%.*}

echo "Processing sample: ${base_name}"

inlist="${base_name}.data.qualFilteredIDs.list"
outfile="${base_name}.filtered.fastq"

seqkit grep -f $inlist $i > "$base_name.tmp"

# process headers to include # instead of space in header
# e.g. @SRR25792439.1#VH00700:1:AAAJJTMHV:1:1101:57201:1000#length=150 becomes @SRR25792439.1#VH00700:1:AAAJJTMHV:1:1101:57201:1000 length=150 
# I'm not sure why this step is necessary, but included here anyway

cat "$base_name.tmp" | awk '{if(FNR%4==1){gsub(" |/", "#", $0)} print }' > $outfile
rm "$base_name.tmp"

done
