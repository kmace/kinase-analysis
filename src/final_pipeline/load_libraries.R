# Load library without messages
message("\nLoading required R packages ....")
#suppressMessages(library(DESeq2))

library(Biobase)
library(GEOquery)
library(impute)

library(biomaRt)
library(DESeq2)
library(plyr)
library(dplyr)
library(genefilter)
#library(ggbiplot)
library(ggplot2)
#library(ggrepel)
library(ggrepel)
#library(Glimma)
library(gplots)
library(lattice)
library(mclust)
library(pheatmap)
#library(plotly)
#Poisson Distance (Witten 2011), implemented in the PoiClaClu package. This measure of dissimilarity between counts also takes the inherent variance structure of counts into consideration when calculating the distances between samples
#library(PoiClaClu)
library(RColorBrewer)
library(reshape2)
library(rhdf5)
library(sleuth)
library(tidyr)
library(UpSetR)
library(viridis)
library(vsn)

library(ggvis)
library(plotly)
rename = dplyr::rename
select = dplyr::select
