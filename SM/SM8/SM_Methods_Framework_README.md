# Methods for Integrative Multi-Omics Framework for Long COVID

The document **"SM_Methods_Integrative_Multi_Omics_Framework_Long_COVID.pdf"** provides comprehensive details of datasets, methodologies, and frameworks used to identify causal and critical genes for Long COVID research. This README summarizes the content, including key sections, tables, and figures.

---

## Overview of the Document

### **1. Datasets**
This section explains the datasets integrated into the study and their significance in constructing the framework.

- **Subsections:**
  - **Genome-wide Association Studies (GWAS):**
    - Description of GWAS datasets, emphasizing the selection of GWAS1 for its strict case definitions.
    - **Table 1:** Summary of GWAS datasets with details on cases, controls, and SNPs.
    - **Figure 1:** Visual representation of cases and controls in GWAS datasets.
    - **Table 2:** Sample rows from GWAS datasets showing variant details.

  - **Expression Quantitative Trait Loci (eQTL):**
    - Summary of eQTL data from GTEx, covering 49 tissues.
    - **Table 3:** Details on sample size, genes, and SNPs for each tissue.

  - **Whole Genome Sequence (WGS) Data:**
    - Description of WGS datasets for Linkage Disequilibrium (LD) analysis.
    - **Table 4:** Sample rows from the BIM file with variant information.
    - **Table 5:** Metadata from the FAM file for LD matrix computation.

  - **RNA-seq Gene Expression Data:**
    - Description of RNA-seq data for 567 participants, covering 58,884 unique genes.
    - Explanation of missing value imputation methods.
    - **Table 6:** Example of RNA-seq gene expression data.

  - **Protein-Protein Interaction (PPI):**
    - Summary of PPI networks used to identify critical genes.
    - **Table 7:** Sample rows showing gene IDs, names, and node subtypes.

---

### **2. Framework**
This section describes the integrative framework developed for causal gene discovery.

- **Subsections:**
  - **Overview:** Explanation of key framework components: instrumental variables (SNPs), exposure (gene expression), and outcome (Long COVID phenotypes).
  - **Mendelian Randomization (MR):**
    - Implementation using the Mt-Robin method.
    - Steps include data pre-processing, forward selection analysis, mixed model setup, statistical validation, and output processing.
    - Formulas for key metrics (e.g., MR score normalization).

  - **Control Theory (CT):**
    - Application of Controllability Analysis (CA) to identify critical genes.
    - Node classification (Type I and Type II) and network metrics.
    - Integration of MR and CT results to prioritize genes.

  - **Figures:**
    - **Figure 2:** Mendelian Randomization framework.
    - **Figure 3:** Multi-omics framework integrating MR, RNA-seq, and PPI data.

---

### **3. Integration and Enrichment Analysis**
- **Integration:** Methods for combining MR and CT scores, exploration of alpha values, and final result generation.
- **Enrichment Analysis:** Functional annotation of identified genes using ontologies (Biological Process, Molecular Function, Cellular Component) and pathways (KEGG, Reactome, WikiPathways).

---

### **4. Gene Expression Clustering**
This section details the clustering methodology applied to gene expression data.
- **Steps:**
  - Preprocessing, scaling, and parameter optimization.
  - Use of hierarchical clustering (hc) and Partitioning Around Medoids (PAM).
  - Output generation, including cluster assignments and visualization.
- **Statistical Tests:**
  - Chi-squared test for large samples.
  - Fisher’s Exact Test for small samples.

---

### **5. References**
The document cites datasets and tools, including Lammi et al., GTEx, and Vinayagam et al.

---

This document serves as a valuable resource for researchers and practitioners, providing detailed methodologies and insights into the integrative framework applied to Long COVID research. For more information, refer to the PDF.
