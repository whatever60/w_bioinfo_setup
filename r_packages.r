options(needs.promptUser = FALSE)

# CRAN packages
cran_packages <- c(
  "tidyverse",
  "dplyr",
  "ggplot2",
  "pheatmap",
  "hexbin",
  "devtools",
  "languageserver",
  "Seurat",
  "blockmodeling"
)
install.packages(cran_packages, quiet = TRUE)

# Bioconductor packages
bioc_packages <- c(
  "DESeq2",
  "edgeR",
  "limma",
  "gplots",
  "RNAseq123",
  "Mus.musculus",
  "Glimma",
  "vsn",
  "DiffBind",
  "BiocParallel",
  "genefilter"
)
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager", quiet = TRUE)
BiocManager::install(bioc_packages, quiet = TRUE)

# Other packages
other_packages <- c(
  "devtools",
  "Signac",
  "IRkernel",
  "languageserver"
)
install.packages(other_packages, quiet = TRUE)

# GitHub package
library(devtools)
install_github("stephens999/ashr", quiet = TRUE)

# IRkernel installation
install.packages("IRkernel", quiet = TRUE)
IRkernel::installspec()
