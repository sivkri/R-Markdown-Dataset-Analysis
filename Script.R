---
  title: "R markdown report preparation of two datasets"
author: "sivakumar krishnamoorthy"
date: "`r Sys.Date()`"
output:
  html_document: default
#pdf_document: default
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
# knitr::opts_chunk$set(echo = TRUE, fig.width = 12, fig.height = 12)
```

## Project details

*toy dataset* was used to determine the impact of age, genotype and cell type on the average gene expression in mice. This toy study has 12 mice from **2 genotypes** (KO and Wt) and **2 cell types** (typeA and typeB).

## Setup

### Load Libraries

`knitr` and `ggplot2` are the 2 libraries required to run this report.

```{r load-libraries}

### Bioconductor and CRAN libraries used
library(knitr)
library(ggplot2)
```

### Load data

In addition to the normalized expression data, we need to make sure we have the appropriate metadata information loaded.

```{r load_data}
data <- read.csv("data/counts.rpkm.csv", header=T, row.names=1) 
meta <- read.csv("data/mouse_exp_design.csv", header=T, row.names=1)
kable(meta, format="markdown")
```

### Modify the metadata data frame

The original metadata file did not have the average expression for each sample. So we will use the counts data to generate that information and add it to the metadata data frame along with the age of the mice (in days).

```{r data-ordering}
# Ensure that sample names in data columns are in the same order as the sameple names in the meta rows 
data_ordered <- data[ ,match(rownames(meta), colnames(data))]
```

```{r}
# generate samplemeans for the data 
samplemeans <- apply(data_ordered, 2, mean)

# Create a numeric vector with ages to add to meta (Note that there are 12 elements here)
age_in_days <- c(40, 32, 38, 35, 41, 32, 34, 26, 28, 28, 30, 32)    

# Add samplemeans and age to the meta table
new_meta <- cbind(meta, age_in_days, samplemeans)

# print metadata dataframe
kable(new_meta, format="markdown")
```

## Does average expression change with age of mouse?

```{r scatterplot}
ggplot(new_meta) +
  geom_point(aes(x=age_in_days, y=samplemeans, color=genotype, shape=celltype), size=rel(3.0)) +
  theme_bw() +
  theme(axis.text=element_text(size=rel(1.5)),
        axis.title=element_text(size=rel(1.5)),
        plot.title=element_text(hjust=0.5)) +
  xlab("Age (days)") +
  ylab("Mean expression") +
  ggtitle("Expression with Age")
```

## Distribution of expression in the 2 genotypes

```{r boxplot}
ggplot(new_meta) +
  geom_boxplot(aes(x=genotype, y=samplemeans, fill=celltype)) +
  ggtitle("Genotype differences in average gene expression") +
  theme(axis.text=element_text(size=rel(1.25)),
        axis.title=element_text(size=rel(1.5)),
        plot.title=element_text(hjust=0.5, size=rel(1.25))) +
  xlab("Genotype") +
  ylab("Mean expression")
```

# Set-up libraries for another set of data

## Load libraries

```{r - load the package}
library(tidyverse)
library(pheatmap)
```

## Data cleaning and Wrangling

Load the set of unstructured data in order to convert into structured data to make it easier to analyze further

```{r - load the prepared data}
## Load data
load("Rmarkdown_data.Rdata")
```

## Extract significant genes based on FDR value

Top 20 significant genes

```{r}
## Get names of top 20 genes
top20_sigOE_genes <- res_tableOE_tb %>% 
  arrange(padj) %>% 	#Arrange rows by padj values
  pull(gene) %>% 		#Extract character vector of ordered genes
  head(n=20)

# print top20_sigOE_genes dataframe
kable (top20_sigOE_genes, format="markdown")
```

## Normalized counts for top 20 significant genes

```{r}
top20_sigOE_norm <- normalized_counts %>%
  filter(gene %in% top20_sigOE_genes)

# print top20_sigOE_norm dataframe
kable(top20_sigOE_norm, format="markdown")
```

## Gathering the columns to have normalized counts to a single column

```{r}
gathered_top20_sigOE <- top20_sigOE_norm %>%
  gather(colnames(top20_sigOE_norm)[2:9], key = "samplename", value = "normalized_counts")

gathered_top20_sigOE1 <- inner_join(mov10_meta, gathered_top20_sigOE)

# print gathered_top20_sigOE dataframe before joining the data
kable(head(gathered_top20_sigOE, format="markdown", n=10))
```

```{r}
# print gathered_top20_sigOE1 dataframe after joining the data
kable(head(gathered_top20_sigOE1, format="markdown", n=10))
```

## plot using ggplot2

```{r}
ggplot(gathered_top20_sigOE1) +
  geom_point(aes(x = gene, y = normalized_counts, color = sampletype)) +
  scale_y_log10() +
  xlab("Genes") +
  ylab("log10 Normalized Counts") +
  ggtitle("Top 20 Significant DE Genes") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5))
```

# Create a heatmap of the differentially expressed genes

## Extract normalized expression for significant genes from the OE and control samples (2:4 and 7:9)

```{r}
res_tableOE_tb_sig <- res_tableOE_tb %>%
  filter(padj < 0.05)

# print res_tableOE_tb_sig dataframe
kable(head(res_tableOE_tb_sig, format="markdown", n=10))
```

## Return the normalized counts for the significant DE genes

```{r}
norm_OEsig <- normalized_counts %>% 
  filter(gene %in% res_tableOE_tb_sig$gene) 

meta <- mov10_meta %>%
  column_to_rownames("samplename") %>%
  data.frame()

# print norm_OEsig dataframe
kable(head(norm_OEsig, format="markdown", n=10))
```

## Run pheatmap using the metadata data frame for the annotation

```{r}
pheatmap(norm_OEsig[2:9], 
         cluster_rows = T, 
         show_rownames = F,
         annotation = meta, 
         border_color = NA, 
         fontsize = 10, 
         scale = "row", 
         fontsize_row = 10, 
         height = 20)
```

# Note

## install latex if there is a prerequiste needed, if the output needs to be printed in PDF format

###install.packages("tinytex") ###tinytex::install_tinytex()
