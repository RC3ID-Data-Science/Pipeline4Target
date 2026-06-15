#!/usr/bin/env nextflow

process ReportCleanUp {

    conda 'r-dplyr r-readr'

    publishDir params.outdir + "/FULL_REPORT", mode: 'copy', saveAs: {filename -> "${sampleName}.dr.report.tsv"}

    input:
        val sampleName
        path complete_report

    output:
        path "${complete_report}.dr.report.tsv", emit: dr_report

    script:
    """
    Rscript ${projectDir}/Scripts/who-catalogue.R ${complete_report} ${projectDir}/References/who-catalogue.csv > ${complete_report}.dr.report.tsv
    """

}
