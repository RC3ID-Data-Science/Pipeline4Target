#!/usr/bin/env nextflow

process Masking {

    conda 'gatk4'

    publishDir params.outdir + "/VCF", mode: 'copy', saveAs: { filename -> if (filename.endsWith(".fixed.vcf")) {"${sampleName}.fixed.vcf"}
                                                    else if (filename.endsWith(".fixed.vcf.idx")) {"${sampleName}.fixed.vcf.idx"}
                                                    else if (filename.endsWith(".minor.vcf")) {"${sampleName}.minor.vcf"}
                                                    else if (filename.endsWith(".minor.vcf.idx")) {"${sampleName}.minor.vcf.idx"}}

    input:
        val sampleName
        path clean_vcf
        path clean_idx
        path lofreq_vcf
        path ref
        path ref_index
        path ref_dict
        path mask
        path mask_index

    output:
        path "${clean_vcf}.fixed.vcf", emit: fixed_vcf
        path "${clean_vcf}.fixed.vcf.idx", emit: fixed_idx
        path "${lofreq_vcf}.minor.vcf", emit: minor_vcf
        path "${lofreq_vcf}.minor.vcf.idx", emit: minor_idx

    script:
    """
    gatk IndexFeatureFile --I ${lofreq_vcf}
    gatk VariantFiltration --R ${ref} --V ${clean_vcf} --mask ${mask} --O ${clean_vcf}.fixed.flagged.vcf
    gatk VariantFiltration --R ${ref} --V ${lofreq_vcf} --mask ${mask} --O ${lofreq_vcf}.minor.flagged.vcf
    gatk SelectVariants --R ${ref} --V ${clean_vcf}.fixed.flagged.vcf --exclude-filtered --O ${clean_vcf}.fixed.vcf
    gatk SelectVariants --R ${ref} --V ${lofreq_vcf}.minor.flagged.vcf --exclude-filtered --O ${lofreq_vcf}.minor.vcf
    """

}
