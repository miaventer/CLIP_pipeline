# CLIP_pipeline

Almost entirely based on racoon-clip (https://github.com/ZarnackGroup/racoon_clip/tree/main/racoon_clip), but compatible with Digital Alliance Canada compute nodes. 

The pipeline does the following:
- filter raw fastq reads based on UMI quality
- extract UMIs and remove adapters with Flexbar
- split chimeric and non-chimeric reads based on whether the first 24nt of the read aligned with the miRNA genome (currently from miRGeneDB 3.0)
- alignment of chimeric and non-chimeric reads with STAR
- deduplication based on UMI tags in read header
- filtering of chimeric reads for a specific miRNA (this step is not performed by the original racoon-clip)
- PureClip peak calling on chimeric and non-chimeric reads separately, without a control file included (to do: compare with using a control)

