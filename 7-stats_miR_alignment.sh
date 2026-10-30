# get stats on chimeric vs non-chimeric reads

##############################################################
# user params

INDIR="/home/miav/scratch/Verheyden_GSE242306/5_split_chimeric/"

##############################################################

cd $INDIR

for i in $INDIR/*chimeric.bam; do
base_name=$(basename "$i")
base_name=${base_name%%.*}

samtools view $i | wc -l >> $base_name.chimeric.stats.txt 

done

for i in *non.chimeric.list; do
base_name=$(basename "$i")
base_name=${base_name%%.*}

wc $i -l >> $base_name.non.chimeric.stats.txt

done



