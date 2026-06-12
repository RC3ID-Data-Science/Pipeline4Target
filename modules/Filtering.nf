#!/usr/bin/env nextflow

process Filtering {

    conda 'gatk4'

    publishDir params.outdir + "/Filtered", mode: 'copy'

    input:
        val sampleName
        path called_vcf
        path called_idx
        path ref
        path ref_index
        path ref_dict
        path mask
        path mask_index

    output:
        path "${called_vcf}_flagged.snps.vcf", emit: flagged_snps
        path "${called_vcf}_flagged.snps.vcf.idx", emit: flagged_snps_idx
        path "${called_vcf}_flagged.indels.vcf", emit: flagged_indels
        path "${called_vcf}_flagged.indels.vcf.idx", emit: flagged_indels_idx

    script:
    """
    gatk SelectVariants --R ${ref} --V ${called_vcf} --select-type-to-include SNP --O ${called_vcf}_raw.snps.vcf
    gatk VariantFiltration --R ${ref} --mask ${mask} --V ${called_vcf}_raw.snps.vcf --filter-expression "QUAL < 30.0 || QD < 2.0 || FS > 60.0 || MQ < 40.0 || DP < 12" --filter-name "FAILED" --O ${called_vcf}_flagged.snps.vcf

    gatk SelectVariants --R ${ref} --V ${called_vcf} --select-type-to-include INDEL --O ${called_vcf}_raw.indels.vcf
    gatk VariantFiltration --R ${ref} --V ${called_vcf}_raw.indels.vcf --filter-expression "QUAL < 30.0 || QD < 2.0 || FS > 60.0 || MQ < 40.0" --filter-name "FAILED" --O ${called_vcf}_flagged.indels.vcf
    """

}
