# Methods for Integrative Multi-Omics Framework Long COVID

The file **"SM_Methods_Integrative_Multi_Omics_Framework_Long_COVID.pdf"** provides supplementary materials and detailed explanations of the datasets, methods, and frameworks used in the study. Below is a summary of the content included in the document, organized by tables, figures, and sections.

---

## Overview of the PDF Content

### 1. **Datasets**
This section describes the datasets used in the study, focusing on Genome-wide Association Studies (GWAS), RNA-seq gene expression, and Protein-Protein Interaction (PPI) networks.

- **Tables:**
  - **Table 1 (Genome-wide Association Studies):** A summary of the GWAS datasets, including the number of cases, controls, and SNPs for each dataset. It highlights why GWAS1 was chosen for the analysis.
  - **Table 2 (GWAS Dataset Example):** Top 5 rows from one of the original GWAS datasets, showing genetic variant details (chromosome, position, allele information, and effect size).

- **Figures:**
  - **Figure 1 (GWAS Cases and Controls):** A visual representation of the distribution of cases and controls across the GWAS datasets, emphasizing the differences between "Broad" and "Strict" definitions.

### 2. **Symptoms and Ancestries**
This subsection highlights the diversity in clinical symptoms and ancestries within the GWAS1 dataset.

- **Content:**
  - A comprehensive list of symptoms commonly reported in Long COVID patients.
  - Ancestral representation covering Admixed American, African, East Asian, European, Middle Eastern, and South Asian populations.

### 3. **Expression Quantitative Trait Loci (eQTL)**
This section provides details about the eQTL datasets sourced from the GTEx project, focusing on tissue-specific gene expression regulation.

- **Table 3 (eQTL Summary):** A summary of the eQTL data across 49 tissues, including sample size, number of genes, and gene-SNP associations.

### 4. **Whole Genome Sequence (WGS) Data for Linkage Disequilibrium (LD) Analysis**
This section explains how the WGS data were used to calculate the LD matrix.

- **Tables:**
  - **Table 4 (WGS BIM File):** Top 5 rows of the WGS BIM file, showing the structure and content used for LD matrix calculation.
  - **Table 5 (WGS FAM File):** Top 5 rows of the FAM file, which contains metadata for 836 European individuals.

### 5. **RNA-sequencing Gene Expression (RNA-seq)**
This section focuses on the RNA-seq dataset, describing its structure and how missing values were handled.

- **Table 6 (RNA-seq Dataset):** Top 5 rows and columns of the RNA-seq dataset, showing Ensembl Gene IDs and gene expression values for selected samples. It explains how rows and columns with all missing values were removed, and the remaining missing values were imputed with the mean.

### 6. **Protein-Protein Interaction (PPI)**
This section describes the PPI dataset used to construct the Long COVID network.

- **Table 7 (PPI Dataset):** Top 5 rows of the PPI dataset, highlighting gene names and their classification into Type-I (robust) and Type-II (vulnerable) nodes.

### 7. **Framework**
This section outlines the integrative multi-omics framework employed in the study.

- **Figures:**
  - **Figure 2 (Framework Part I):** Mendelian Randomization framework, showing the relationship between genetic variants (IVs), gene expression (eQTL), and Long COVID outcomes.
  - **Figure 3 (Framework Part II):** Integrative multi-omics framework, combining Mendelian Randomization with RNA-seq and PPI data to identify causal and critical genes for Long COVID.

---

## Reference
- All tables and figures are sourced from the corresponding datasets and methods detailed in the study. Refer to **Lammi et al., 2023**, **GTEx Project**, and **Vinayagam et al., 2011** for dataset-specific information.