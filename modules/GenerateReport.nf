#!/usr/bin/env nextflow

process GenerateReport {

    conda 'tbvcfreport'

    publishDir params.outdir + "/tbvcfreport", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".minor_variants_report.txt")) {"${sampleName}.minor_variants_report.txt"}
                                                                     else if (filename.endsWith(".fixed_variants_report.txt")) {"${sampleName}.fixed_variants_report.txt"}}

    input:
        val sampleName
        path ann_fixed_vcf
        path ann_minor_vcf

    output:
        path "*.fixed_variants_report.txt", emit: fixed_report
        path "*.minor_variants_report.txt", emit: minor_report

    script:
    """
    tbvcfreport generate ${ann_fixed_vcf}
    tbvcfreport generate ${ann_minor_vcf}
    """

}
