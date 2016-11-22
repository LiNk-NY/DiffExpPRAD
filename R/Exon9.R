# BiocInstaller::biocLite(c("GenomicFeatures", "TxDb.Hsapiens.UCSC.hg19.knownGene"))
library("GenomicFeatures")
## Exon data must coincide with build version

library(TxDb.Hsapiens.UCSC.hg19.knownGene) # database package
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene # shorthand (for convenience)
txdb

seqlevels(txdb) <- "chr8"
# seqlevels(txdb) <- seqlevels0(txdb)
exon <- exonsBy(txdb, by="gene")

## Entrez GeneID for PVT1 = 5820
allExons <- exon$`5820`

exon9 <- exon$`5820`[10]
