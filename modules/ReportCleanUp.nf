#!/usr/bin/env nextflow

process ReportCleanUp {

    conda 'r-dplyr r-readr'

    publishDir params.outdir + "/FULL_REPORT", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".complete_report.tsv")) {"${sampleName}.complete_report.tsv"}}

    input:
        val sampleName
        path fixed_snps_report
        path fixed_indels_report
        path minor_snps_report
        path minor_indels_report
        path delly_report
        path fixed_snpstats
        path minor_snpstats

    output:
        path "${fixed_snps_report}.complete_report.tsv", emit: complete_report

    script:
    """
    tail -n +3 ${fixed_snps_report} | sed 's/#//' > ${fixed_snps_report}.fixed.snps.tsv
    tail -n +3 ${fixed_indels_report} | sed 's/#//' > ${fixed_indels_report}.fixed.indels.tsv
    tail -n +3 ${minor_snps_report} | sed 's/#//' > ${minor_snps_report}.minor.snps.tsv
    tail -n +3 ${minor_indels_report} | sed 's/#//' > ${minor_indels_report}.minor.indels.tsv
    tail -n +3 ${delly_report} | sed 's/#//' > ${delly_report}.delly.tsv

    Rscript ${projectDir}/Scripts/merge_fixed_snps.R ${fixed_snpstats} ${fixed_snps_report}.fixed.snps.tsv > ${fixed_snps_report}.fixed.snps.final.tsv
    Rscript ${projectDir}/Scripts/merge_minor_snps.R ${minor_snpstats} ${minor_snps_report}.minor.snps.tsv > ${minor_snps_report}.minor.snps.final.tsv

    Rscript ${projectDir}/Scripts/fixed_indels_clean_up.R ${fixed_indels_report}.fixed.indels.tsv > ${fixed_indels_report}.fixed.indels.final.tsv
    Rscript ${projectDir}/Scripts/minor_indels_clean_up.R ${minor_indels_report}.minor.indels.tsv > ${minor_indels_report}.minor.indels.final.tsv
    Rscript ${projectDir}/Scripts/delly_clean_up.R ${delly_report}.delly.tsv > ${delly_report}.delly.final.tsv

    cat ${fixed_snps_report}.fixed.snps.final.tsv ${minor_snps_report}.minor.snps.final.tsv ${fixed_indels_report}.fixed.indels.final.tsv ${minor_indels_report}.minor.indels.final.tsv ${delly_report}.delly.final.tsv > ${fixed_snps_report}.complete_report.tsv
    """

}
