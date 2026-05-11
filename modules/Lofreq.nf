#!/usr/bin/env nextflow

process Lofreq {

    conda 'lofreq'

    publishDir params.outdir + "/Lofreq", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".lofreq.vcf")) {"${sampleName}.lofreq.vcf"}}



    input:
        val sampleName
        path bam_processed
        path bam_processed_idx
        path ref
        path ref_index
        path ref_dict

    output:
        path "${bam_processed}.lofreq.vcf", emit: lofreq_vcf

    script:
    """
    lofreq indelqual --dindel -f ${ref} -o ${processed_bam}.indelq.bam ${processed_bam}
    lofreq call --min-cov 20 -q 20 -Q 20 -m 3 -f ${ref} -o ${bam_processed}.lofreq.raw.vcf ${bam_processed}.indelq.bam
    lofreq filter -i ${bam_processed}.lofreq.raw.vcf -o ${bam_processed}.lofreq.vcf --cov-min 20 --af-min 0.1 --af-max 0.9 --snvqual-thresh 20
    """

}
