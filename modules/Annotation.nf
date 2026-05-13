#!/usr/bin/env nextflow

process Annotation {

    publishDir params.outdir + "/Annotation", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".ann.full.vcf")) {"${sampleName}.ann.full.vcf"}
                                                             else if (filename.endsWith(".ann.minor.vcf")) {"${sampleName}.ann.minor.vcf"}}

    input:
        val sampleName
        path full_vcf
        path minor_vcf

    output:
        path "${full_vcf}.ann.full.vcf", emit: ann_full_vcf
        path "${minor_vcf}.ann.minor.vcf", emit: ann_minor_vcf

    script:
    """
    sed 's/NC_000962.3/Chromosome/' ${full_vcf} > ${full_vcf}.chr.full.vcf
    sed 's/NC_000962.3/Chromosome/' ${minor_vcf} > ${minor_vcf}.chr.minor.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${full_vcf}.chr.full.vcf > ${full_vcf}.ann.full.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${minor_vcf}.chr.minor.vcf > ${minor_vcf}.ann.minor.vcf
    """

}
