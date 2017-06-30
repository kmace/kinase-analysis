rm(list=ls())

load('../../input/images/normalized_data.RData')

library(tidyr)
library(dplyr)
library(broom)
library(tibble)
library(heatmap3)
library(ggplot2)

vlog = vlog - rowMeans(vlog)
row_sd = apply(vlog,1,sd)
vlog = apply(vlog,2,function(x) x / row_sd)

vlog = as.data.frame(vlog)
vlog$Gene = rownames(vlog)
measurements = gather(vlog, Sample_Name, Expression, -Gene)
# should be a left join on the meta subsetted
meta_sub = as.data.frame(meta) %>% select(Sample_Name, Condition, Strain)

measurements = left_join(measurements, meta_sub)

measurements = measurements %>%
  group_by(Gene) %>%
  mutate(Gene_range = diff(range(Expression)),
         Gene_sd = sd(Expression),
         Gene_mean = mean(Expression),
         Norm_Expression = (Expression - Gene_mean) / Gene_sd) %>%
  ungroup() %>%
  arrange(Gene)

measurements = measurements %>% filter(Gene_range > 1)

fits = measurements %>%
  dplyr::group_by(Gene) %>%
  dplyr::do(fitGene = lm(Expression ~ Strain + Condition, data = .)) %>%
  broom::tidy(fitGene)

fits %>% dplyr::filter(abs(estimate)>1 & p.value < 0.01) %>% group_by(term) %>% summarise(num_genes = n())

fits %>% dplyr::filter(abs(estimate)>1 & p.value < 0.01) %>% spread(Gene,term,estimate)

good_fits = fits %>% dplyr::filter(abs(estimate)>1 & p.value < 0.01)
lists = sapply(terms, function(x) select(filter(good_fits,term==x),Gene))

parameters = fits %>% select(Gene, term, estimate) %>% spread(term, estimate) %>% ungroup()
rownames(parameters) = parameters$Gene

parameter_matrix = as.matrix(select(parameters, -Gene))
col_mean = apply(parameter_matrix,2,mean)
#m = apply(parameter_matrix,1,function(x) x - col_m)
#m = t(m)
#heatmap3(m[m[,10]>1,-10], labRow = NA, scale='none')
heatmap3(parameter_matrix, labRow = NA, scale='none')


library(heatmaply)
library(d3heatmap)

shrink_large = function(data, max, min = -max){
data[data>max] = max
data[data<min] = min
return(data)
}

d3heatmap(a[str_length(rownames(a)) < 7,grep('Cond', colnames(a))], Rowv = NA, Colv=NA)

heatmaply(shrink_large(a[str_length(rownames(a)) < 7,
          grep('Cond', colnames(a))], 2),
          Rowv = NA,
          Colv=NA,
          scale_fill_gradient_fun= scale_fill_gradient2())