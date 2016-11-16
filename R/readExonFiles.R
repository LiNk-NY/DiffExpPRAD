library(BiocInterfaces)
library(readr)

exonFiles <- list.files("/data/exon/", recursive = TRUE,
                        pattern = "tion.txt$", full.names = TRUE)
exonFiles

TCGAexonToGRangesList(exonFiles)
