#!/usr/bin/env nextflow

process FastaConversion {

    conda 'gatk4'

    publishDir params.outdir + "/VCF", mode: 'copy', saveAs: { filename -> "${sampleName}.fasta"}

    input:
        val sampleName
        path fixed_vcf
        path fixed_idx
        path clean_indels
        path indels_idx
        path filtered_delly

    output:
        path "${fixed_vcf}_full.vcf", emit: full_vcf
        path "${fixed_vcf}_full.vcf.idx", emit: full_idx

    script:
    """
    gatk SelectVariants --V ${filtered_delly} --exlude-filtered --O ${filtered_delly}_clean_delly.vcf
    gatk MergeVcfs --I ${fixed_vcf} --I ${clean_indels} --I ${filtered_delly}_clean_delly.vcf --O ${fixed_vcf}_full.vcf
    """

}
