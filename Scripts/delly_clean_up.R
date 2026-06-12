library(dplyr)
library(readr)

args <- commandArgs(trailingOnly = TRUE)

vcf_table_file <- args[1]

vcf_table <- read.table(vcf_table_file, sep = '\t', header = TRUE, check.names = FALSE, quote = "")

vcf_table <- subset(vcf_table, select = -PATHWAY)

indel_type <- c(rep("FIXED_INDEL_DELLY", length.out = nrow(vcf_table)))
vcf_table <- cbind(indel_type, vcf_table)

write.table(vcf_table, row.names = FALSE, col.names = FALSE, sep = "\t", quote = FALSE)
