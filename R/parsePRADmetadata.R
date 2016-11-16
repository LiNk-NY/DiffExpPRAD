library(tidyjson)
metadatas <- tidyjson::read_json("data-raw/metadata.cart.2016-11-10T23-36-01.808261_ALL.json")

# unlist(attributes(metadatas)$JSON[[1]][[1]])
cases <- names(grep("^TCGA", unlist(attributes(metadatas)$JSON[[1]][[1]]), value = TRUE))[[9]]
type <- grep("file_id", names(unlist(attributes(metadatas)$JSON[[1]][[1]])), value = TRUE)[[2]]
idx <- match(c(cases, type), names(unlist(attributes(metadatas)$JSON[[1]][[1]])))

metaList <- attributes(metadatas)[["JSON"]][[1L]]
IDS <- lapply(seq_along(metaList), function(i) {
    bcodeIdx <- match("cases.samples.portions.analytes.aliquots.submitter_id",
          names(unlist(metaList[i])))
    fileIdx <- match("file_id", names(unlist(metaList[i])))
    unlist(metaList[i])[c(bcodeIdx, fileIdx)]
})

bcodeFileID <- data.frame(do.call(rbind, IDS), stringsAsFactors = FALSE)

## Read the race variable
racevar <- read_csv("https://raw.githubusercontent.com/lwaldron/tcga_prad/master/racevariable.csv")
names(racevar) <- c("patientID", "race")
racevar$patientID <- toupper(gsub("\\.", "-", racevar$patientID))

match(racevar$patientID,
      TCGAbarcode(bcodeFileID$cases.samples.portions.analytes.aliquots.submitter_id))

