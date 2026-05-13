#!/usr/bin/env nextflow

process Filtering {

    conda 'gatk4'

    publishDir params.outdir + "/Filtered", mode: 'copy', saveAs: {filename -> if (filename.endsWith("_clean.snps.vcf")) {"${sampleName}.vcf"}
                                                             else if (filename.endsWith("_clean.snps.vcf.idx")) {"${sampleName}.vcf.idx"}}

    input:
        val sampleName
        path called_vcf
        path called_idx
        path ref
        path ref_index
        path ref_dict

    output:
        path "${called_vcf}_clean.snps.vcf", emit: clean_vcf
        path "${called_vcf}_clean.snps.vcf.idx", emit: clean_idx
        path "${called_vcf}_clean.indels.vcf", emit: clean_indels
        path "${called_vcf}_clean.indels.vcf.idx", emit: indels_idx

    script:
    """
    gatk SelectVariants --R ${ref} --V ${called_vcf} --select-type-to-include SNP --O ${called_vcf}_raw.snps.vcf
    gatk VariantFiltration --R ${ref} --V ${called_vcf}_raw.snps.vcf --filter-expression "QUAL < 30.0 || QD < 2.0 || FS > 60.0 || MQ < 40.0 || DP < 12" --filter-name "FAILED" --O ${called_vcf}_flagged.snps.vcf
    gatk SelectVariants --R ${ref} --V ${called_vcf}_flagged.snps.vcf --exclude-filtered --O ${called_vcf}_clean.snps.vcf

    gatk SelectVariants --R ${ref} --V ${called_vcf} --select-type-to-include INDEL --O ${called_vcf}_raw.indels.vcf
    gatk VariantFiltration --R ${ref} --V ${called_vcf}_raw.indels.vcf --filter-expression "QUAL < 30.0 || QD < 2.0 || FS > 60.0 || MQ < 40.0" --filter-name "FAILED" --O ${called_vcf}_flagged.indels.vcf
    gatk SelectVariants --R ${ref} --V ${called_vcf}_flagged.indels.vcf --exclude-filtered --O ${called_vcf}_clean.indels.vcf
    """

}
