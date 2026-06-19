# Pipeline4Target

![RC3ID Logo](Logos/Pusris.jpg)

This pipeline was written for the TARGET Project for the analysis of Mycobacterium tuberculosis genomes.

### Requirements

- **Conda**
- **Nextflow**
- **R**
- **Python**

## Installation

Clone this repository:

```bash
git clone https://github.com/RC3ID-Data-Science/Pipeline4Target.git
```

## Usage

Running main pipeline:

```bash
nextflow run /PATH/TO/PROJECT/Pipeline4Target/main.nf --raw_read1 /PATH/TO/RAW/READS/<sample_name>_1.fastq.gz --raw_read2 /PATH/TO/RAW/READS/<sample_name>_2.fastq.gz --sample_name <sample_name>
```

## References

MyCodentifier:
> Schildkraut JA, Coolen JPM, Severin H, Koenraad E, Aalders N, Melchers WJG, et al. MGIT Enriched Shotgun Metagenomics for Routine Identification of Nontuberculous Mycobacteria: a Route to Personalized Health Care. J Clin Microbiol. 2023 Mar 23;61(3):e0131822. <https://doi.org/10.1128/jcm.01318-22>

Nextflow:
> Di Tommaso, P., Chatzou, M., Floden, E. et al. Nextflow enables reproducible computational workflows. Nat Biotechnol 35, 316–319 (2017). <https://doi.org/10.1038/nbt.3820>

### Main Pipeline

fastp
> Shifu Chen, Yanqing Zhou, Yaru Chen, Jia Gu, fastp: an ultra-fast all-in-one FASTQ preprocessor, Bioinformatics, Volume 34, Issue 17, September 2018, Pages i884–i890, <https://doi.org/10.1093/bioinformatics/bty560>

bwa-mem
> Li H. Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. arXiv preprint arXiv:1303.3997. 2013. <https://doi.org/10.48550/arXiv.1303.3997>

gatk4
> Van der Auwera GA, O'Connor BD. Genomics in the Cloud: Using Docker, GATK, and WDL in Terra. 1st ed. O'Reilly Media; 2020.

delly
> Rausch T, Zichner T, Schlattl A, Stuetz AM, Benes V, Korbel JO. DELLY: structural variant discovery be integrated paired-end and split-read analysis. Bioinformatics. Volume 28, Issue 18, September 2012, Pages i333-i339. <https://doi.org/10.1093/bioinformatics/bts378>

lofreq
> Wilm A, Aw PPK, Bertrand D, Yeo GHT, Ong SH, Wong CH, Khor CC, Petric R, Hibberd ML, Nagarajan N. Lofreq: a sequence-quality aware, ultra-sensitive variant caller for uncovering cell-population heterogeneity from high-throughput sequencing datasets. Nucleic Acids Research. 2012 Oct 12;40(22):11189-11201. <https://doi.org/10.1093/nar/gks918>

Regions masked according to Marin, et al., (2022)
> Maximillian Marin, Roger Vargas, Michael Harris, Brendan Jeffrey, L Elaine Epperson, David Durbin, Michael Strong, Max Salfinger, Zamin Iqbal, Irada Akhundova, Sergo Vashakidze, Valeriu Crudu, Alex Rosenthal, Maha Reda Farhat, Benchmarking the empirical accuracy of short-read sequencing across the M. tuberculosis genome, Bioinformatics, Volume 38, Issue 7, March 2022, Pages 1781–178. <https://doi.org/10.1093/bioinformatics/btac023>

### Annotation

snpEff
> Cingolani P, Platts A, Wang le L, Coon M, Nguyen T, Wang L, Land SJ, Lu X, Ruden DM. A program for annotating and predicting the effects of single nucleotide polymorphisms, SnpEff: SNPs in the genome of Drosophila melanogaster strain w1118; iso-2; iso-3. Fly (Austin). 2012 Apr-Jun;6(2):80-92. <https://doi.org/10.4161/fly.19695>

tbvcfreport
> <https://github.com/COMBAT-TB/tbvcfreport>
> van Heusden P, Mashologu Z, Lose T, Warren R, Christoffels A. The COMBAT-TB Workbench: Making Powerful Mycobacterium tuberculosis Bioinformatics Accessible. mSphere 7:e00991-21. <https://doi.org/10.1128/msphere.00991-21>






Code for masking fastas was provided by Dr. Philip Ashton, regions masked as per (Holt, et al., 2018):
> Holt, K.E., McAdam, P., Thai, P.V.K. et al. Frequent transmission of the Mycobacterium tuberculosis Beijing lineage and positive selection for the EsxW Beijing variant in Vietnam. Nat Genet 50, 849–856 (2018). <https://doi.org/10.1038/s41588-018-0117-9>

Seqkit
> Shen W, Sipos B, Zhao L. SeqKit2: A Swiss army knife for sequence and alignment processing. iMeta. 2024;3(3):191. <https://doi.org/10.1002/imt2.191.>

Bedtools
> Aaron R. Quinlan, Ira M. Hall, BEDTools: a flexible suite of utilities for comparing genomic features, Bioinformatics, Volume 26, Issue 6, March 2010, Pages 841–842, <https://doi.org/10.1093/bioinformatics/btq033>

### SNP-Distance Analysis

snp-dists
> https://github.com/tseemann/snp-dists.git
