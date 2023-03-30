options(needs.promptUser = FALSE)
install.packages(c("tidyverse", "dplyr", "ggplot2", "pheatmap", "hexbin", "devtools", "languageserver", "Seurat", "blockmodeling"))

if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install(c("DESeq2", "edgeR", "limma", "gplots", "RNAseq123", "Mus.musculus", "Glimma", "vsn", "DiffBind"))

library(devtools)
install_github("stephens999/ashr")

setRepositories(ind=1:3)
install.packages("Signac")

install.packages("IRkernel")
IRkernel::installspec()
install.packages("languageserver")
