#!/usr/bin/env nextflow

process Annotation {

    publishDir params.outdir + "/Annotation", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".ann.fixed.snps.vcf")) {"${sampleName}.ann.fixed.snps.vcf"}
                                                             else if (filename.endsWith(".ann.fixed.indels.vcf")) {"${sampleName}.ann.fixed.indels.vcf"}
                                                             else if (filename.endsWith(".ann.minor.snps.vcf")) {"${sampleName}.ann.minor.snps.vcf"}
                                                             else if (filename.endsWith(".ann.minor.indels.vcf")) {"${sampleName}.ann.minor.indels.vcf"}
                                                             else if (filename.endsWith(".ann.delly.vcf")) {"${sampleName}.ann.delly.vcf"}}

    input:
        val sampleName
        path fixed_snps
        path fixed_snps_idx
        path fixed_indels
        path fixed_indels_idx
        path minor_snps
        path minor_snps_idx
        path minor_indels
        path minor_indels_idx
        path filtered_delly

    output:
        path "${fixed_snps}.ann.fixed.snps.vcf", emit: ann_fixed_snps
        path "${fixed_indels}.ann.fixed.indels.vcf", emit: ann_fixed_indels
        path "${minor_snps}.ann.minor.snps.vcf", emit: ann_minor_snps
        path "${minor_indels}.ann.minor.indels.vcf", emit: ann_minor_indels
        path "${filtered_delly}.ann.delly.vcf", emit: ann_delly

    script:
    """
    sed 's/NC_000962.3/Chromosome/' ${fixed_snps} > ${fixed_snps}.chr.fixed.snps.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${fixed_snps}.chr.fixed.snps.vcf > ${fixed_snps}.ann.fixed.snps.vcf

    sed 's/NC_000962.3/Chromosome/' ${fixed_indels} > ${fixed_indels}.chr.fixed.indels.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${fixed_indels}.chr.fixed.indels.vcf > ${fixed_indels}.ann.fixed.indels.vcf

    sed 's/NC_000962.3/Chromosome/' ${minor_snps} > ${minor_snps}.chr.minor.snps.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${minor_snps}.chr.minor.snps.vcf > ${minor_snps}.ann.minor.snps.vcf

    sed 's/NC_000962.3/Chromosome/' ${minor_indels} > ${minor_indels}.chr.minor.indels.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${minor_indels}.chr.minor.indels.vcf > ${minor_indels}.ann.minor.indels.vcf

    sed 's/NC_000962.3/Chromosome/' ${filtered_delly} > ${filtered_delly}.chr.delly.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${filtered_delly}.chr.delly.vcf > ${filtered_delly}.ann.delly.vcf
    """

}
