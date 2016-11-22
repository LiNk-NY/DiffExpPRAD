library(BiocInterfaces)
library(readr)

source("R/parsePRADmetadata.R")

exonFiles <- list.files("/data/exon/", recursive = TRUE, pattern = "tion.txt$", full.names = TRUE)
folders <- basename(dirname(exonFiles))

validIdx <- match(validMap$file_id, folders)

validFoldersOnDisk <- folders[validIdx]
exonFiles <- exonFiles[validIdx]

orderIdx <- order(validFoldersOnDisk)

validFoldersOnDisk <- validFoldersOnDisk[orderIdx]
exonFiles <- exonFiles[orderIdx]


validMap <- validMap[order(validMap$file_id),]

stopifnot(identical(validMap$file_id, validFoldersOnDisk))
stopifnot(identical(basename(dirname(exonFiles)), validMap$file_id))

grl <- TCGAexonToGRangesList(exonFiles, filenames = validMap$barcode)

Exon9s <- lapply(grl, function(sample) {
    sample[overlapsAny(sample, exon9, type = "any")]
})

saveRDS(Exon9s, file = "data-raw/exon9grl.rds")

rm(grl)
gc()
