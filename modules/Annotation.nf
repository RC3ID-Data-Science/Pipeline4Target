#!/usr/bin/env nextflow

process Annotation {

    publishDir params.outdir + "/Annotation", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".ann.fixed.vcf")) {"${sampleName}.ann.fixed.vcf"}
                                                             else if (filename.endsWith(".ann.minor.vcf")) {"${sampleName}.ann.minor.vcf"}}

    input:
        val sampleName
        path fixed_vcf
        path minor_vcf

    output:
        path "${fixed_vcf}.ann.fixed.vcf", emit: ann_fixed_vcf
        path "${minor_vcf}.ann.minor.vcf", emit: ann_minor_vcf

    script:
    """
    sed 's/NC_000962.3/Chromosome/' ${fixed_vcf} > ${fixed_vcf}.chr.fixed.vcf
    sed 's/NC_000962.3/Chromosome/' ${minor_vcf} > ${minor_vcf}.chr.minor.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${fixed_vcf}.chr.fixed.vcf > ${fixed_vcf}.ann.fixed.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${minor_vcf}.chr.minor.vcf > ${minor_vcf}.ann.minor.vcf
    """

}
