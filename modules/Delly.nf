#!/usr/bin/env nextflow

process Delly {

    conda 'delly bcftools'

    input:
        val sampleName
        path bam_processed
        path bam_processed_idx
        path ref
        path ref_index
        path ref_dict

    output:
        path "${bam_processed}_filtered_delly.vcf", emit: filtered_delly

    script:
    """
    delly call -g ${ref} -t DEL ${bam_processed} -o ${bam_processed}_raw_delly.bcf
    bcftools view ${bam_processed}_raw_delly.bcf > ${bam_processed}_raw_delly.vcf
    bcftools filter -i 'GT="1/1"' ${bam_processed}_raw_delly.vcf > ${bam_processed}_filtered_delly.vcf
    """

}
