# R Markdown Report Preparation of Two Datasets

This repository contains an R Markdown report that analyzes two datasets and generates visualizations and summaries based on the data. This R markdown notebook serve as a template to prepare output in the form of HTML of two different datasets

## Project Details

The analysis focuses on a "toy dataset" that examines the impact of age, genotype, and cell type on the average gene expression in mice. The dataset includes 12 mice from two genotypes (KO and Wt) and two cell types (typeA and typeB).

## Setup

### Load Libraries

To run the report, you need to have the following libraries installed: `knitr` and `ggplot2`. These libraries are responsible for generating the visualizations and processing the data.

### Load Data

The report requires two data files: `counts.rpkm.csv` and `mouse_exp_design.csv`. The former contains the normalized expression data, while the latter provides the metadata information. The code loads both data files into the R environment.

### Modify the Metadata Data Frame

The original metadata file is modified to include additional information. The code calculates the average expression for each sample using the counts data and adds it to the metadata data frame. Additionally, the age of the mice (in days) is appended to the metadata table.

## Analysis

The report includes two main analysis sections: "Does average expression change with age of mouse?" and "Distribution of expression in the 2 genotypes." Each section contains visualizations generated using the `ggplot2` library.

## Second Dataset Analysis

The report also includes an analysis of a second dataset. This section requires additional libraries: `tidyverse` and `pheatmap`. The code loads the necessary libraries and performs data cleaning and wrangling on the unstructured data to convert it into a structured format for analysis.

## Conclusion

The R Markdown report provides an overview of the two datasets and performs various analyses, including visualizations and summaries. The report can be executed to generate an HTML output. If the intention is to generate a PDF output, additional prerequisites may be required, such as installing the "tinytex" package.

Please refer to the repository files for the complete R code and data files used in the report.
