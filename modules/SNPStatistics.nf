#!/usr/bin/env nextflow

process SNPStatistics {

    conda 'gatk4'

    publishDir params.outdir + "/SNPStats", mode: 'copy', saveAs: {filename -> if (filename.endsWith("_fixed_snpstats.tsv")) {"${sampleName}_fixed_snpstats.tsv"}
                                                                  else if (filename.endsWith("_minor_snpstats.tsv")) {"${sampleName}_minor_snpstats.tsv"}}

    input:
        val sampleName
        path fixed_snps
        path minor_snps

    output:
        path "${fixed_snps}_fixed_snpstats.tsv", emit: fixed_snpstats
        path "${minor_snps}_minor_snpstats.tsv", emit: minor_snpstats

    script:
    """
    gatk VariantsToTable --V ${fixed_snps} --F POS --F AF --F DP --O ${fixed_snps}_fixed_snpstats.tsv
    gatk VariantsToTable --V ${minor_snps} --F POS --F AF --F DP --O ${minor_snps}_minor_snpstats.tsv
    """

}
