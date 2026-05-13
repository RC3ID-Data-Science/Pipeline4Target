#!/usr/bin/env nextflow

process GenerateReport {

    conda 'tbvcfreport'

    publishDir params.outdir + "/tbvcfreport", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".minor_variants_report.txt")) {"${sampleName}.minor_variants_report.txt"}
                                                                     else if (filename.endsWith(".full_variants_report.txt")) {"${sampleName}.full_variants_report.txt"}}

    input:
        val sampleName
        path ann_full_vcf
        path ann_minor_vcf

    output:
        path "*.full_variants_report.txt", emit: full_report
        path "*.minor_variants_report.txt", emit: minor_report

    script:
    """
    tbvcfreport generate ${ann_full_vcf}
    tbvcfreport generate ${ann_minor_vcf}
    """

}
