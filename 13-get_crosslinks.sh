# get crosslinks by converting aligned bam files to bed files
# then shift 1 nt upstream
# split into plus and minus bed files
# and create bigwig files

##############################################################
# user params
base_directory="/home/miav/scratch/Verheyden_GSE242306"
GENOME_INDEX="/home/miav/scratch/genomes/mm39/GRCm39.primary_assembly.genome.fa.fai"
experiment="miR-eCLIP"
mir="Mmu-Mir-181-P1a_5p" # what it's called in miRbase
##############################################################

if [ "$experiment" = "miR-eCLIP" ]; then
    CHIM_OUTDIR="10_chimeric_crosslinks"
    NONCHIM_OUTDIR="10_nonchimeric_crosslinks"
    CHIM_INDIR="9_chimeric_dedup"
    NONCHIM_INDIR="9_nonchimeric_dedup"

    mkdir -p $base_directory/$CHIM_OUTDIR
    mkdir -p $base_directory/$NONCHIM_OUTDIR

   # chimeric
   cd $base_directory/$CHIM_OUTDIR

   for bam_file in $base_directory/$CHIM_INDIR/*bam; do

file_name="${bam_file##*/}"
base_name="${file_name%%.dedup*}"
   outfile="${base_name}.bed"

   if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
   else

echo "Processing sample: $base_name"

# Convert all read locations to intervals in bed file format using BEDTools
bedtools bamtobed -i $bam_file > "$base_name.bed"

# optional but preferred: filter only for the miR that you want
grep -E "\b${mir}_" "$base_name.bed" > "$base_name.$mir.bed"

# Filter out reads at chromosome boundaries (first nt on + strand, last nt on - strand)
awk 'BEGIN{OFS="\t"} FNR==NR{chr_len[$1]=$2; next} !(($6=="+" && $2==0) || ($6=="-" && $3==chr_len[$1]))' $GENOME_INDEX	"$base_name.$mir.bed">  "$base_name.$mir.bed.tmp" && mv  "$base_name.$mir.bed.tmp"  "$base_name.$mir.bed"
        
# Shift intervals depending on the strand by 1 bp upstream using BEDTools
bedtools shift -m 1 -p -1 -i "$base_name.$mir.bed" -g $GENOME_INDEX | sort -k1,1 -k2,2n -k3,3n > "$base_name.$mir.shifted.bed"
      
# Extract the 5' end of the shifted intervals and pile up into coverage track in bedgraph file format (separately for each strand) using BEDTools (in case of RPM-normalised coverage tracks, use additional parameter -scale with 1,000,000/#mappedReads)
bedtools genomecov -bg -strand + -5 -i "$base_name.$mir.shifted.bed" -g $GENOME_INDEX | LC_COLLATE=C sort -k1,1 -k2,2n -k3,3n > "$base_name.$mir.shifted.plus.bed"
bedtools genomecov -bg -strand - -5 -i "$base_name.$mir.shifted.bed" -g $GENOME_INDEX | LC_COLLATE=C sort -k1,1 -k2,2n -k3,3n > "$base_name.$mir.shifted.minus.bed"

bedGraphToBigWig "$base_name.$mir.shifted.plus.bed" $GENOME_INDEX "$base_name.$mir.shifted.plus.bw" 
bedGraphToBigWig "$base_name.$mir.shifted.minus.bed" $GENOME_INDEX "$base_name.$mir.shifted.minus.bw"

fi
done

    # non-chimeric
   cd $base_directory/$NONCHIM_OUTDIR

   for bam_file in $base_directory/$NONCHIM_INDIR/*bam; do

file_name="${bam_file##*/}"
base_name="${file_name%%.dedup*}"

   outfile="${base_name}.bed"

   if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
   else

echo "Processing sample: $base_name"

# Convert all read locations to intervals in bed file format using BEDTools
bedtools bamtobed -i $bam_file > "$base_name.bed"

#Filter out reads at chromosome boundaries (first nt on + strand, last nt on - strand)
awk 'BEGIN{OFS="\t"} FNR==NR{chr_len[$1]=$2; next} !(($6=="+" && $2==0) || ($6=="-" && $3==chr_len[$1]))' $GENOME_INDEX "$base_name.bed">  "$base_name.bed.tmp" && mv  "$base_name.bed.tmp"  "$base_name.bed"  

# Shift intervals depending on the strand by 1 bp upstream using BEDTools
bedtools shift -m 1 -p -1 -i "$base_name.bed" -g $GENOME_INDEX | sort -k1,1 -k2,2n -k3,3n > "$base_name.shifted.bed"          

# Extract the 5' end of the shifted intervals and pile up into coverage track in bedgraph file format (separately for each strand) using BEDTools (in case of RPM-normalised coverage tracks, use additional parameter -scale with 1,000,000/#mappedReads)
bedtools genomecov -bg -strand + -5 -i "$base_name.shifted.bed" -g $GENOME_INDEX | LC_COLLATE=C sort -k1,1 -k2,2n -k3,3n > "$base_name.shifted.plus.bed"
bedtools genomecov -bg -strand - -5 -i "$base_name.shifted.bed" -g $GENOME_INDEX | LC_COLLATE=C sort -k1,1 -k2,2n -k3,3n > "$base_name.shifted.minus.bed"

bedGraphToBigWig "$base_name.shifted.plus.bed" $GENOME_INDEX "$base_name.shifted.plus.bw"
bedGraphToBigWig "$base_name.shifted.minus.bed" $GENOME_INDEX "$base_name.shifted.minus.bw"

fi
done
 
    else
    OUTDIR="6_crosslinks"
    mkdir -p  $base_directory/$OUTDIR

    INDIR="5_dedup"

    cd  $base_directory/$OUTDIR

for bam_file in $base_directory/$INDIR/*bam; do 

file_name="${bam_file##*/}"

base_name="${file_name%%.dedup*}" 

outfile="${base_name}.bed" 

if [ -f "${outfile}" ]; then
    echo "[SKIPPING]: File already exists."
    continue
   else

echo "Processing sample: $base_name"

# Convert all read locations to intervals in bed file format using BEDTools
bedtools bamtobed -i $bam_file > "$base_name.bed"

#Filter out reads at chromosome boundaries (first nt on + strand, last nt on - strand)

awk 'BEGIN{OFS="\t"} FNR==NR{chr_len[$1]=$2; next} !(($6=="+" && $2==0) || ($6=="-" && $3==chr_len[$1]))' $GENOME_INDEX "$base_name.bed">  "$base_name.bed.tmp" && mv  "$base_name.bed.tmp"  "$base_name.bed"

# Shift intervals depending on the strand by 1 bp upstream using BEDTools 
bedtools shift -m 1 -p -1 -i "$base_name.bed" -g $GENOME_INDEX | sort -k1,1 -k2,2n -k3,3n > "$base_name.shifted.bed"

# Extract the 5' end of the shifted intervals and pile up into coverage track in bedgraph file format (separately for each strand) using BEDTools (in case of RPM-normalised coverage tracks, use additional parameter -scale with 1,000,000/#mappedReads) 

bedtools genomecov -bg -strand + -5 -i "$base_name.shifted.bed" -g $GENOME_INDEX | LC_COLLATE=C sort -k1,1 -k2,2n -k3,3n > "$base_name.shifted.plus.bed"
bedtools genomecov -bg -strand - -5 -i "$base_name.shifted.bed" -g $GENOME_INDEX | LC_COLLATE=C sort -k1,1 -k2,2n -k3,3n > "$base_name.shifted.minus.bed"

bedGraphToBigWig "$base_name.shifted.plus.bed" $GENOME_INDEX "$base_name.shifted.plus.bw"
bedGraphToBigWig "$base_name.shifted.minus.bed" $GENOME_INDEX "$base_name.shifted.minus.bw"

fi
done
fi 
















