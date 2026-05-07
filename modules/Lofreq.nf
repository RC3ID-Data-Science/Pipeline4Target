#!/usr/bin/env nextflow

process Lofreq {

    conda 'lofreq'

    /*
     *publishDir params.outdir + "/Lofreq", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".minor.vcf")) {"${sampleName}.minor.vcf"}}
     *
     */

    input:
        val sampleName
        path bam_processed
        path bam_processed_idx
        path ref
        path ref_index
        path ref_dict

    output:
        path "${bam_processed}.minor.vcf", emit: minor_vcf

    script:
    """
    lofreq call --min-cov 20 -q 20 -Q 20 -m 3 -f ${ref} -o ${bam_processed}.raw.minor.vcf ${bam_processed}
    lofreq filter -i ${bam_processed}.minor.raw.vcf -o ${bam_processed}.minor.vcf --cov-min 20 --af-min 0.1 --af-max 0.9 --snvqual-thresh 20
    """

}
