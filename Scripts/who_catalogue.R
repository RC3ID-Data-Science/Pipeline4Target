library(dplyr)
library(readr)

args <- commandArgs(trailingOnly = TRUE)

sample_file <- args[1]
who_file <- args[2]

sample_table <- read.table(sample_file, sep = '\t', header = TRUE, check.names = FALSE, quote = "")
who_table <- read.table(who_file, sep = ',', header = TRUE, check.names = FALSE, quote = "")




snp_stats_file <- args[1]
vcf_table_file <- args[2]

snp_stats <- read.table(snp_stats_file, sep = '\t', header = TRUE, check.names = FALSE, quote = "")
vcf_table <- read.table(vcf_table_file, sep = '\t', header = TRUE, check.names = FALSE, quote = "")

vcf_table <- subset(vcf_table, select = -PATHWAY)

snp_type <- c(rep("FIXED_SNP", length.out = nrow(vcf_table)))
vcf_table <- cbind(snp_type, vcf_table)

merged_table <- left_join(vcf_table, snp_stats, by = c("POS"))

write.table(merged_table, row.names = FALSE, sep = "\t", quote = FALSE)
