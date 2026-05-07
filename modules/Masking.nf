#!/usr/bin/env nextflow

process Masking {

    publishDir params.outdir + "/VCF", mode: 'copy', saveAs: { filename -> if (filename.endsWith(".fixed.vcf")) {"${sampleName}.fixed.vcf"}
                                                    else if (filename.endsWith(".fixed.vcf.idx")) {"${sampleName}.fixed.vcf.idx"}}
                                                    else if (filename.endsWith(".minor.vcf")) {"${sampleName}.minor.vcf"}}
                                                    else if (filename.endsWith(".minor.vcf.idx")) {"${sampleName}.minor.vcf.idx"}}
    conda 'gatk4'

    input:
        val sampleName
        path fixed_vcf
        path minor_vcf
        path ref
        path ref_index
        path ref_dict
        path mask
        path mask_index

    output:
        path "${fixed_vcf}.fixed.vcf", emit: fixed_vcf
        path "${fixed_vcf}.fixed.vcf.idx", emit: fixed_idx
        path "${minor_vcf}.minor.vcf", emit: minor_vcf
        path "${minor_vcf}.minor.vcf.idx". emit: minor_idx

    script:
    """
    gatk4 VariantFiltration --R ${ref} --V ${fixed_vcf} --mask ${mask} --O ${fixed_vcf}.fixed.flagged.vcf
    gatk4 VariantFiltration --R ${ref} --V ${minor_vcf} --mask ${mask} --O ${minor_vcf}.minor.flagged.vcf
    gatk4 SelectVariants --R ${ref} --V ${fixed_vcf}.fixed.flagged.vcf --exclude-filtered --O ${fixed_vcf}.fixed.vcf
    gatk4 SelectVariants --R ${ref} --V ${minor_vcf}.minor.flagged.vcf --exclude-filtered --O ${minor_vcf}.minor.vcf
    """

}
