#!/bin/bash
#SBATCH --account=def-lkmahal
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16      # Number of MPI processes on this node
#SBATCH --mem=128G                # Total memory for the node
#SBATCH --time=10:00:00           # Time limit (HH:MM:SS)
#SBATCH --mail-type=END,FAIL     # Notifications for job success (END) and failure (FAIL)
#SBATCH --mail-user=mia.venter@ualberta.ca
#SBATCH --job-name=Verheyden

chimeric="true" # if true, run miR-eCLIP, if false, run regular eCLIP

#module load sra-toolkit/3.0.9
#./1-download_data.sh

#module load star/2.7.11b
#./2-star_index.sh

# QUALITY FILTER ON BARCODE
#module purge
#module load StdEnv/2020
#module load fastx-toolkit
#./1-quality_filter_barcode.sh

#module swap StdEnv/2020 StdEnv/2023

#module purge
#module load seqkit
#./2-quality_filter_barcode.sh

# FLEXBAR
#./3-flexbar.sh

# SHORTEN MIR
#module purge
#module load StdEnv/2020
#module load fastx-toolkit
#./4-shorten_reads.sh
#module swap StdEnv/2020 StdEnv/2023

# ALIGN MIRS
#module purge
#module load bowtie2
#module load samtools
#./5-align_miRs.sh

# SPLIT CHIMERIC VS NON-CHIMERIC
#module purge
#module load samtools
#./6-split_chimeric.sh

# GET STATS ON CHIMERIC VS NON-CHIMERIC
#./7-stats_miR_alignment.sh 

# GET NON-CHIMERIC FASTQ FILES FOR ALIGNMENT (BECOMES REGULAR CLIP)
#module load seqkit
#./8-fastq_nonchimeric.sh

# TRIM CANONICAL MIRS (PYTHON)
#module purge
#module load StdEnv/2020
#module load python/3.9

#./9-trim_canonical_miRs.sh

#module swap StdEnv/2020 StdEnv/2023

# ALIGNMENT WITH STAR
module purge
module load star/2.7.11b
module load samtools
./10-align_star.sh
./11-index_bam.sh

# DEDUP
module purge
module load python/3.11
virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
pip install --no-index --upgrade pip

pip install --no-index -r /home/miav/umi_req.txt

./12-dedup.sh

deactivate

# GET CROSSLINKS	
module purge
module load samtools
module load bedtools
module load kent_tools/486
./13-get_crosslinks.sh

# PURECLIP
./14-pureclip.sh










