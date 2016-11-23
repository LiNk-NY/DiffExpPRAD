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

## Read files from disk
grl <- TCGAexonToGRangesList(exonFiles, sampleNames = validMap$barcode)

Exon9s <- lapply(grl, function(sample) {
    sample[overlapsAny(sample, exon9, type = "any")]
})

bcodes <- names(Exon9s)

# saveRDS(Exon9s, file = "data-raw/exon9grl.rds")
# rm(grl)
# gc()
# Exon9s <- readRDS("data-raw/exon9grl.rds")

stopifnot(identical(validMap$barcode, names(Exon9s)))

rpkm <- vapply(Exon9s, FUN = function(samp) mcols(samp)$RPKM,
               FUN.VALUE = numeric(1L))

fullDF <- cbind.data.frame(validMap, rpkm)
fullDF$rpkm100 <- fullDF$rpkm*100
fullDF$rpkm100W <- round(fullDF$rpkm100, digits = 0)

expd <- MASS::glm.nb(rpkm100W ~ race, data = fullDF)
summary(expd)
caucasian <- exp(c(estimate = coef(expd)[[2]], confint(expd)[2, ]))
