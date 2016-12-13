## Differential Expression Analysis using TCGA PRAD (Prostate Adenocarcinoma)

This repository holds scripts for conducting differential expression analyses using
R and Bioconductor. The data comes from The Cancer Genome Atlas (TCGA), a
multi-center collaboration between the National Cancer Institute (NCI), and the National
Human Genome Research Institute (NHGRI) aimed at understanding 33 types of cancer.
The data has been made publicly available at the Genomic Data Commons Data Portal (*see link below*).

### Downloading data from the Genomic Data Commons

* Download the [Data Transfer Tool](https://gdc.cancer.gov/access-data/gdc-data-transfer-tool)
for your operating system
* Unzip the file
* The manifest file can be obtained from the [GDC website](https://gdc-portal.nci.nih.gov/)
by adding items to the cart and downloading the manifest instead of the raw data files. 
* Run the client and manifest file from the command line: `gdc-client download -m manifest_file_here.txt`
