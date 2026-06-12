#!/usr/bin/env nextflow

process Masking {

    conda 'gatk4'

    publishDir params.outdir + "/VCF", mode: 'copy', saveAs: { filename -> if (filename.endsWith(".fixed.snps.vcf")) {"${sampleName}.fixed.snps.vcf"}
                                                    else if (filename.endsWith(".fixed.snps.vcf.idx") {"${sampleName}.fixed.snps.vcf.idx"}
                                                    else if (filename.endsWith(".fixed.indels.vcf")) {"${sampleName}.fixed.indels.vcf"}
                                                    else if (filename.endsWith(".fixed.indels.vcf.idx")) {"${sampleName}.fixed.indels.vcf.idx"}
                                                    else if (filename.endsWith(".minor.snps.vcf")) {"${sampleName}.minor.snps.vcf"}
                                                    else if (filename.endsWith(".minor.snps.vcf.idx")) {"${sampleName}.minor.snps.vcf.idx"}
                                                    else if (filename.endsWith(".minor.indels.vcf")) {"${sampleName}.minor.indels.vcf"}
                                                    else if (filename.endsWith(".minor.indels.vcf.idx")) {"${sampleName}.minor.indels.vcf.idx"}}

    input:
        val sampleName
        path flagged_snps
        path flagged_snps_idx
        path flagged_indels
        path flagged_indels_idx
        path lofreq_vcf
        path ref
        path ref_index
        path ref_dict
        path mask
        path mask_index

    output:
        path "${flagged_snps}.fixed.snps.vcf", emit: fixed_snps
        path "${flagged_snps}.fixed.snps.vcf.idx", emit: fixed_snps_idx
        path "${flagged_indels}.fixed.indels.vcf", emit: fixed_indels
        path "${flagged_indels}.fixed.indels.vcf.idx", emit: fixed_indels_idx
        path "${lofreq_vcf}.minor.snps.vcf", emit: minor_snps
        path "${lofreq_vcf}.minor.snps.vcf.idx", emit: minor_snps_idx
        path "${lofreq_vcf}.minor.indels.vcf", emit: minor_indels
        path "${lofreq_vcf}.minor.indels.vcf.idx", emit: minor_indels_idx

    script:
    """
    gatk SelectVariants --R ${ref} --V ${flagged_snps} --select-type-to-include SNP --O ${flagged_snps}.fixed.snps.vcf
    gatk SelectVariants --R ${ref} --V ${flagged_indels} --select-type-to-include INDEL --O ${flagged_indels}.fixed.indels.vcf

    gatk IndexFeatureFile --I ${lofreq_vcf}
    gatk SelectVariants --R ${ref} --V ${lofreq_vcf} --select-type-to-include INDEL --O ${lofreq_vcf}.minor.indels.vcf
    gatk SelectVariants --R ${ref} --V ${lofreq_vcf} --select-type-to-include SNP --O ${lofreq_vcf}.minor.raw.snps.vcf
    gatk VariantFiltration --R ${ref} --V ${lofreq_vcf}.minor.raw.snps.vcf --mask ${mask} --O ${lofreq_vcf}.minor.flagged.snps.vcf
    gatk SelectVariants --R ${ref} --V ${lofreq_vcf}.minor.flagged.snps.vcf --exclude-filtered --O ${lofreq_vcf}.minor.snps.vcf
    """

}
