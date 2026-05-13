#!/usr/bin/env nextflow

process ReportCleanUp {

    conda 'r-dplyr r-readr'

    publishDir params.outdir + "/FULL_REPORT", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".complete_report.tsv")) {"${sampleName}.complete_report.tsv"}}

    input:
        val sampleName
        path full_report
        path minor_report
        path full_snpstats
        path minor_snpstats

    output:
        path "${full_report}.complete_report.tsv", emit: complete_report

    script:
    """
    tail -n +3 ${full_report} | sed 's/#//' > ${full_report}.full.tsv
    tail -n +3 ${minor_report} | sed 's/#//' > ${minor_report}.minor.tsv

    Rscript ${projectDir}/Scripts/merge_full.R ${full_snpstats} ${full_report}.full.tsv > ${full_report}.full.final.tsv
    Rscript ${projectDir}/Scripts/merge_minor.R ${minor_snpstats} ${minor_report}.minor.tsv > ${minor_report}.minor.final.tsv

    cat ${full_report}.full.final.tsv ${minor_report}.minor.final.tsv > ${full_report}.complete_report.tsv
    """

}
