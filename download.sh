
while IFS= read -r sra || [ -n "$sra" ]; do
    # Ignore empty lines
    [ -z "$sra" ] && continue
    
    # Clean up hidden Windows characters just in case
    sra=$(echo "$sra" | tr -d '\r')
    
    echo "Downloading: $sra"
    
    fasterq-dump "$sra" \
      --outdir /home/miav/scratch/Verheyden_GSE242306/tmp_fastq \
      --threads 16 \
      --progress \
      --split-files \
      -t /home/miav/scratch/Verheyden_GSE242306/tmp

done < /home/miav/Verheyden_GSE242306/tmp_SRR_Acc_List.txt
