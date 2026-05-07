#!/usr/bin/env nextflow

process ReportCleanup {

    conda 'r-dplyr r-readr'

    publishDir params.outdir + "/FULL_REPORT", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".complete_report.tsv")) {"${sampleName}.complete_report.tsv"}}

    input:
        val sampleName
        path fixed_report
        path minor_report
        path fixed_snpstats
        path minor_snpstats

    output:
        path "${fixed_report}.complete_report.tsv", emit: complete_report

    script:
    """
    tail -n +3 ${fixed_report} | sed 's/#//' > ${fixed_report}.fixed.tsv
    tail -n +3 ${minor_report} | sed 's/#//' > ${minor_report}.minor.tsv

    Rscript ${projectDir}/Scripts/merge_fixed.R ${fixed_snpstats} ${fixed_report}.fixed.tsv > ${fixed_report}.fixed.final.tsv
    Rscript ${projectDir}/Scripts/merge_minor.R ${minor_snpstats} ${minor_report}.minor.tsv > ${minor_report}.minor.final.tsv

    cat ${fixed_report}.fixed.final.tsv ${minor_report}.minor.final.tsv > ${fixed_report}.complete_report.tsv
    """

}
