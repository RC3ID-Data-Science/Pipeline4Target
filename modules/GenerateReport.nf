#!/usr/bin/env nextflow

process GenerateReport {

    conda 'tbvcfreport'

    publishDir params.outdir + "/tbvcfreport", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".ann.fixed.snps_variants_report.txt")) {"${sampleName}.ann.fixed.snps_variants_report.txt"}
                                                                     else if (filename.endsWith(".ann.fixed.indels_variants_report.txt")) {"${sampleName}.ann.fixed.indels_variants_report.txt"}
                                                                     else if (filename.endsWith(".ann.minor.snps_variants_report.txt")) {"${sampleName}.ann.minor.snps_variants_report.txt"}
                                                                     else if (filename.endsWith(".ann.minor.indels_variants_report.txt")) {"${sampleName}.ann.minor.indels_variants_report.txt"}
                                                                     else if (filename.endsWith(".ann.delly_variants_report.txt")) {"${sampleName}.ann.delly_variants_report.txt"}}

    input:
        val sampleName
        ann_fixed_snps
        ann_fixed_indels
        ann_minor_snps
        ann_minor_indels
        ann_delly

    output:
        path "*.ann.fixed.snps_variants_report.txt", emit: fixed_snps_report
        path "*.ann.fixed.indels_variants_report.txt", emit: fixed_indels_report
        path "*.ann.minor.snps_variants_report.txt", emit: minor_snps_report
        path "*.ann.minor.indels_variants_report.txt", emit: minor_indels_report
        path "*.ann.delly_variants_report.txt", emit: delly_report

    script:
    """
    tbvcfreport generate ${ann_fixed_snps}
    tbvcfreport generate ${ann_fixed_indels}
    tbvcfreport generate ${ann_minor_snps}
    tbvcfreport generate ${ann_minor_indels}
    tbvcfreport generate ${ann_delly}
    """

}
