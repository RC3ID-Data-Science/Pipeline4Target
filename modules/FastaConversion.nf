#!/usr/bin/env nextflow

process FastaConversion {

    conda 'gatk4'

    publishDir params.outdir + "/FASTA", mode: 'copy', saveAs: { filename -> "${sampleName}.fasta"}

    input:
        val sampleName
        path fixed_snps
        path fixed_snps_idx
        path ref
        path ref_index
        path ref_dict

    output:
        path "${fixed_snps}_clean.fasta"

    script:
    """
    gatk FastaAlternateReferenceMaker --R ${ref} --V ${fixed_snps} --O ${fixed_snps}_raw.fasta
    sed 's/1 NC_000962.3:1-4411532/'${sampleName}'/' ${fixed_snps}_raw.fasta > ${fixed_snps}_clean.fasta
    """

}
