#!/bin/bash
## 4 april 2026, version 1.0, GAPP

echo -e "Running LoFreq and annotations \n\n"

## 2 Pre-processing LoFreq
##echo -e "\n=== Preprocess BAM Files: Realign indels and recalibrate base qualities ===\n"
## sources: https://csb5.github.io/lofreq/commands/
## A. Since the dedup.nf (pipeline_11) only process BAM files until mark and remove duplicates
# lofreq indelqual --dindel -f ../../../Pipeline_11/Reference/NC_000962.3.fasta -o BM_291.indelq.bam wgs_1-01-BM_291_S1_L001_dedup.bam 
## B. Because lofreq indelqual can break BAM sorting order and invalidates the index, then again proceed into sorting again
# samtools sort -o BM_291_sorted_indelq.bam BM_291.indelq.bam
# samtools index BM_291_sorted_indelq.bam 
# 3 Processing LoFreq
## A. Calling the minor variant (~filter in read level)
# lofreq call --call-indels --min-cov 20 -q 20 -Q 20 -m 3 --verbose -f ../../../Pipeline_11/Reference/NC_000962.3.fasta -o BM_291_lofreq_indelq_call.vcf BM_291_sorted_indelq.bam
## B. Filter the variant results (~filter in variant level)
# lofreq filter \
#   -i BM_291_lofreq_indelq_call.vcf \
#   -o BM_291_lofreq_minor.vcf \
#   --cov-min 20 \
#   --af-min 0.05 \
#   --af-max 0.25 \
#   --snvqual-thresh 20 \
#   --indelqual-thresh 20
## C. Rename the chromosome name in the final minor.VCF so snpeff can detect them
# sed 's/NC_000962.3/Chromosome/g' \
#   ../../project_wgs_tb/outputs/Results_pipeline_11/Dedup/BM_291_lofreq_minor.vcf \
#   > BM_291_lofreq_minor.edit.vcf
# 4 Annotation gene using SnpEff
## make sure the java version is suitable.
## makes sure already download Mycobacterium tuberculosis h37rv (NC_000962.3) database
## run the annotation
#java -Xmx3g -jar snpEff.jar -v Mycobacterium_tuberculosis_h37rv BM_291_lofreq_minor.edit.vcf > BM_291_minor_variants.ann.vcf

#!/bin/bash
set -euo pipefail

echo -e "Running LoFreq + SnpEff pipeline\n"

# 1. PATH SETUP
# ==============================================================================================================
BASE_OUT="/home/target_vm/outputs/Batch03_Results/lofreqRun01"
INPUT_FOLDER="/home/target_vm/outputs/Batch03_Results/Pipeline11Run01/Dedup"

REF="/home/target_vm/script/Pipeline_11/Reference/NC_000962.3.fasta"
SNPEFF_JAR="/home/target_vm/script/Pipeline_12/snpEff/snpEff.jar"
SNPEFF_DB="Mycobacterium_tuberculosis_h37rv"

mkdir -p $BASE_OUT

# 2. LOOP SAMPLE
# ==============================================================================================================
for BAM in ${INPUT_FOLDER}/*dedup.bam
do
    SAMPLE=$(basename $BAM | cut -d'_' -f1-3)
    OUTDIR=${BASE_OUT}/${SAMPLE}

    mkdir -p ${OUTDIR}/{bam,vcf,snpeff}

    echo "Processing: $SAMPLE"

    
    # 3. LOFREQ PREPROCESS
    # ==============================================================================================================
    echo "Processing indelqual lofreq"
    lofreq indelqual --dindel \
        -f $REF \
        -o ${OUTDIR}/bam/${SAMPLE}.indelq.bam \
        $BAM
    
    echo "Processing sort and indexing indelqual lofreq"
    samtools sort \
        -o ${OUTDIR}/bam/${SAMPLE}.sorted.indelq.bam \
        ${OUTDIR}/bam/${SAMPLE}.indelq.bam

    samtools index ${OUTDIR}/bam/${SAMPLE}.sorted.indelq.bam

    
    # 4. VARIANT CALLING
    # ==============================================================================================================
    echo "Processing minor calling"
    lofreq call \
        --call-indels \
        --min-cov 20 -q 20 -Q 20 -m 3 \
        -f $REF \
        -o ${OUTDIR}/vcf/${SAMPLE}.raw.vcf \
        ${OUTDIR}/bam/${SAMPLE}.sorted.indelq.bam
    
    echo "Processing filter minor calling"
    lofreq filter \
        -i ${OUTDIR}/vcf/${SAMPLE}.raw.vcf \
        -o ${OUTDIR}/vcf/${SAMPLE}.minor.vcf \
        --cov-min 20 \
        --af-min 0.05 \
        --af-max 0.25 \
        --snvqual-thresh 20 \
        --indelqual-thresh 20

    
    # 5. CHROM FIX (IMPORTANT FOR SNPEFF)
    # ==============================================================================================================
    echo "Processing rename Chromosomes name"
    sed 's/NC_000962.3/Chromosome/g' \
        ${OUTDIR}/vcf/${SAMPLE}.minor.vcf \
        > ${OUTDIR}/vcf/${SAMPLE}.minor.fix.vcf

    # 6. SNPEFF ANNOTATION
    # =========================
    echo "Processing Annotation Snpeff"
    java -Xmx3g -jar $SNPEFF_JAR -v $SNPEFF_DB \
        ${OUTDIR}/vcf/${SAMPLE}.minor.fix.vcf \
        > ${OUTDIR}/snpeff/${SAMPLE}.snpeff.vcf

done

echo -e "\nPipeline done!"

