source("R/parsePRADmetadata.R")

library(GenomicRanges)
library(BiocInterfaces)

dataLocation <- "~/data/exon"

exonFiles <- list.files(dataLocation, recursive = TRUE, pattern = "tion.txt$", full.names = TRUE)
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

names(exonFiles) <- validMap$barcode

## Read files from disk
sampleList <- lapply(exonFiles, function(file) {
    readr::read_delim(file, delim = "\t")
})

sampleList <- lapply(sampleList, function(element) {
    element <- element[, c("exon", "RPKM")]
    element
})
if (!dir.exists("data"))
    dir.create("data")
saveRDS(sampleList, file = "data/rangeRPKM.rds")

## Take only the tumor samples
full_barcodes <- names(sampleList)
sampleType <- TCGAbarcode(full_barcodes, sample = TRUE, participant = FALSE)

## Load table of sample code types
data(sampleTypes)
sampleType

tumors <- grepl("01", sampleType, fixed = TRUE)

tumorList <- sampleList[tumors]

## Data integrity checks
## 1. Check that all samples have the same number of ranges
numRanges <- lapply(tumorList, function(element) {
    length(element[["exon"]])
})
stopifnot(all(unlist(numRanges) == 239322))

## 2. Check that all ranges are the same across samples
listRanges <- lapply(tumorList, function(element) {
    GRanges(element[["exon"]])
})
unionRanges <- Reduce(union, listRanges)

stopifnot(length(unionRanges) == 239322)

saveRDS(reducedRanges, file = "data/reducedRanges.rds")



## Use RangedSummarizedExperiment class


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
