#!/usr/bin/env nextflow

process SNPStatistics {

    conda 'gatk4'

    publishDir params.outdir + "/SNPStats", mode: 'copy', saveAs: {filename -> if (filename.endsWith("_full_snpstats.tsv")) {"${sampleName}_full_snpstats.tsv"}
                                                                  else if (filename.endsWith("_minor_snpstats.tsv")) {"${sampleName}_minor_snpstats.tsv"}}

    input:
        val sampleName
        path full_vcf
        path minor_vcf

    output:
        path "${full_vcf}_full_snpstats.tsv", emit: full_snpstats
        path "${minor_vcf}_minor_snpstats.tsv", emit: minor_snpstats

    script:
    """
    gatk VariantsToTable --V ${full_vcf} --F POS --F AF --F DP --O ${full_vcf}_full_snpstats.tsv
    gatk VariantsToTable --V ${minor_vcf} --F POS --F AF --F DP --O ${minor_vcf}_minor_snpstats.tsv
    """

}
