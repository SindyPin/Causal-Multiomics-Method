# Long-COVID Causal Gene Identification Framework

## Overview

This repository contains the code and necessary datasets for a novel bioinformatics framework that employs causality to identify genes potentially driving Long-COVID. Our approach integrates multi-omics data to find causal genes that influence the risk and prevention of Long-COVID, as well as the stability of its associated biological networks.

## Purpose

The goal of this project is to develop an advanced causal inference framework for multi-omics data in order to:
- Identify genes that may increase or decrease the risk of developing Long-COVID.
- Determine the role of these genes in maintaining the stability of biological networks affected by Long-COVID.
- Provide a ranked list of candidate genes that could be targeted for therapeutic intervention or further research.

## Methodology

Out framework integrates data from multiple omics layers (e.g., genomics, transcriptomics, proteomics) and calculate a score to identify key drivers of Long-COVID. 

![Workflow Causal Framework](Workflow.png)

Specifically, we:

**Integrated Framework for Long-COVID Causal Gene Identification**

This framework combines advanced techniques (Mendelian Randomization: Mt_Robin (Multi-tissue transcriptome-wide Mendelian Randomization method ROBust to INvalid instrumental variables) [Mr.MtRobin Repository](https://github.com/kjgleason/Mr.MtRobin) [Reference](https://doi.org/10.1002/gepi.22380) and Control Theory: Controllability Analysis (CA) [Reference](https://www.pnas.org/doi/full/10.1073/pnas.1603992113)) to identify key genes associated with Long-COVID by integrating data from [GWAS](https://www.medrxiv.org/content/10.1101/2023.06.29.23292056v1), [eQTL](https://gtexportal.org/home/datasets), [PPI](https://www.pnas.org/doi/full/10.1073/pnas.1603992113), and [RNA-seq](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE215865) datasets. The focus is on identifying protein-coding genes that play crucial roles in disease mechanisms, applying rigorous selection criteria to ensure the relevance and robustness of the results.

### Selection Process

1. **Candidate SNP Identification**: The framework begins by identifying candidate SNPs (Single Nucleotide Polymorphisms) that serve as instrumental variables (IVs) for each gene. The selection process is applied to all genes, with the final analysis focusing exclusively on protein-coding genes.

2. **Threshold Criteria**:
   - **LD Threshold**: SNPs with a Linkage Disequilibrium (LD) correlation greater than 0.5 with another SNP in the pool are excluded.
   - **P-value Threshold 1**: Only SNPs with a p-value less than 0.001 are considered significant.
   - **Number of Tissues Threshold**: SNPs showing significant effects in at least one tissue are retained.
   - **P-value Threshold 2**: Genes with a p-value and False Discovery Rate (FDR) less than or equal to 0.05 are retained, ensuring that only statistically robust genes are included in the final analysis.

3. **Long-COVID Network**: The framework evaluates the roles of these genes within the protein-coding gene network, focusing on their degree (K), in-degree (Kin), and out-degree (Kout). The genes are classified into specific categories based on their indispensability and criticality in network control:
   - **Indispensable and Critical Genes**: The analysis highlights genes that are crucial for network control, subdividing them into:
     - **Type I Critical Genes**: Genes whose removal increases the number of driver nodes (N_D), indicating their essential role in maintaining control within the network.
     - **Type II Critical Genes**: Genes that must always be controlled, belonging to all driver node sets, and characterized by zero in-degree (Kin=0).

4. **Final Score Calculation:**  
   For each gene, a weighted score is computed based on its contributions to risk and prevention, adjusted by a user-defined parameter (`alpha`). The final score is calculated by combining the normalized Mendelian Randomization Score (`MR_Score_norm`) and Control Theory Score (`CT_Score_norm`).

   We developed the following equation to identify the risk/preventive causal and network-critical genes for Long-COVID:

![Causal Score Equation](equation.png)

5. **Summarize and rank genes:**  
   Genes are ranked based on their Final Scores, with additional annotations indicating their effect (Risk/Preventive) and their criticality in biological networks, specifically highlighting whether they are classified as indispensable Type-I or Type-II critical genes in the context of Long-COVID.

6. **Generate a detailed report:**  
   The top candidate genes are outputted to a CSV file, with a summary of key statistics provided. The report includes:
   - Total number of genes analyzed.
   - Number of selected genes based on the Final Score.
   - Number of Risk genes, Preventive genes, and Critical genes (Type-I and Type-II) for both the entire dataset and the selected subset.

### Framework Outcome

The integrated framework filters and ranks genes based on their contributions to Long-COVID pathogenesis, with a special focus on those that are both indispensable and critical within the protein-coding gene network. This comprehensive approach ensures that the final set of identified genes is not only statistically significant but also biologically essential for network control, providing valuable insights into potential therapeutic targets for Long-COVID.

### Definitions

**Indispensable Genes**:  
These are protein-coding genes crucial for maintaining the controllability of the Long-COVID network. If removed, they increase the number of driver nodes (\(ND\)) required to control the network. Indispensable genes are further classified into two categories, Type-I and Type-II, which reflect their different roles and impact across various network states.

**Type-I Genes**:  
These genes are defined by their direct effect on the controllability of the network, as measured by their influence on the number of driver nodes (\(ND\)):
- **Critical**: The removal of a critical Type-I gene increases \(ND\), meaning the network requires more driver nodes for control when this gene is absent.
- **Redundant**: The removal of a redundant Type-I gene decreases \(ND\), meaning fewer driver nodes are needed to control the network when this gene is absent.
- **Ordinary**: The removal of an ordinary Type-I gene does not change \(ND\), meaning it has no effect on the number of driver nodes required for network control.

**Type-II Genes**:  
These genes are classified based on their participation in driver node sets, which are sets of nodes that must be controlled to maintain network controllability:
- **Critical**: A critical Type-II gene must be present in all driver node sets, meaning it always plays a role in network control.
- **Redundant**: A redundant Type-II gene is absent from all driver node sets, meaning it is never required for network control.
- **Ordinary**: An ordinary Type-II gene is present in some but not all driver node sets, meaning it plays a role in network control in certain contexts but not universally.

**Driver Nodes (\(ND\))**:  
Driver nodes are key nodes in the network that must be controlled to ensure the network's overall functionality. An increase in the number of driver nodes suggests a greater level of complexity or difficulty in controlling the network, while a decrease indicates a reduction in the effort required for control.

## Files in This Repository

- **`generate_report_function.R`:** The primary R script containing the function to calculate Final Scores, rank genes, and generate a summary report.
- **`input_data/`:** A directory containing the input datasets required for running the analysis (e.g., normalized scores for genes across different omics layers).
- **`results/`:** Output directory for the generated reports and ranked gene lists.

## How to Use

**Option 1: Dynamic Causal Genes Visualization for Long-COVID Network**

You can dynamically explore shifts in gene rankings using our interactive tool available at [Dynamic Causal Genes Visualization in a Long-COVID Network](https://sindypin.shinyapps.io/github/). This tool allows users to adjust the parameter \(\alpha\), enabling a detailed examination of how genes transition from being network-critical (\(\alpha \to 0\)) to focusing more on disease risk or prevention (\(\alpha \to 1\)).

By adjusting \(\alpha\), you can customize insights into gene roles based on their specific research objectives, whether those objectives involve network dynamics, genetic risk factors, or a combination of both.

![Causal Score Equation](App.png)

**Option 2: Clone the Repository to Modify Results**

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/SindyPin/Causal-Multiomics-Method
   ```

2. The input data is provided in the `input_data/` directory. You do not need to supply any additional data.

3. Load the R script and run the `generate_report` function with the provided dataset and desired parameters:
   General Results:
   - Number of Risk genes: 406 
   - Number of Preventive genes: 402 
   - Number of TypeI Critical genes: 1334 
   - Number of TypeII Critical genes: 387 
   - Total number of genes: 6963

   - Check `alpha=1.0`:
   ```R
   source("generate_report_function.R")
   generate_report(file_path = "input_data/mt_robin_CT.csv", alpha = 1, num_genes_to_print = 16, output_file = "results/gene_report.csv")
   ```
   Output:
   - Number of Risk genes: 8 
   - Number of Preventive genes: 6 
   - Number of TypeI Critical genes: 0 
   - Number of TypeII Critical genes: 0
   - Total number of protein-coding-genes: 1654

| Rank | gene_name | MR_Score_norm | CT_Score_norm | Final_Score | Gene_Effect  | Critical_Gene    |
|-----:|:----------|--------------:|--------------:|------------:|:-------------|:-----------------|
|    1 | MORN4     |        1.000  |        0.000  |       1.000 | Risk         | Not_Indispensable |
|    2 | CDC26     |        0.878  |        0.000  |       0.878 | Preventive   | Not_Indispensable |
|    3 | EIF5A     |        0.614  |        0.000  |       0.614 | Risk         | Not_Indispensable |
|    4 | VWDE      |        0.453  |        0.000  |       0.453 | Risk         | Not_Indispensable |
|    5 | GMPPB     |        0.388  |        0.000  |       0.388 | Risk         | Not_Indispensable |
|    6 | NDUFA6    |        0.286  |        0.000  |       0.286 | Risk         | Not_Critical      |
|    7 | BNIP1     |        0.263  |        0.000  |       0.263 | Risk         | Not_Indispensable |
|    8 | CERS4     |        0.228  |        0.000  |       0.228 | Preventive   | Not_Indispensable |
|    9 | ADAT1     |        0.225  |        0.000  |       0.225 | Preventive   | Not_Indispensable |
|   10 | C19orf18  |        0.225  |        0.000  |       0.225 | Risk         | Not_Indispensable |
|   11 | BOLA2     |        0.179  |        0.000  |       0.179 | Preventive   | Not_Indispensable |
|   12 | CDA       |        0.177  |        0.000  |       0.177 | Preventive   | Not_Indispensable |
|   13 | MORN3     |        0.143  |        0.000  |       0.143 | Risk         | Not_Indispensable |
|   14 | BTN3A1    |        0.141  |        0.000  |       0.141 | Preventive   | Not_Indispensable |
   
   - Check `alpha=0.5`:
   ```R
   source("generate_report_function.R")
   generate_report(file_path = "input_data/mt_robin_CT.csv", alpha = 0.5, num_genes_to_print = 10, output_file = "results/gene_report.csv")
   ```
   Output:
   - Number of Risk genes: 2
   - Number of Preventive genes: 1
   - Number of TypeI Critical genes: 7 
   - Number of TypeII Critical genes: 0 
   - Total number of protein-coding-genes: 1654

| Rank | Gene  | Final_Score | Gene_Effect      | TypeI             | TypeII            |
|-----:|:------|------------:|:-----------------|:------------------|:------------------|
|    1 | MORN4 |       0.500 | Risk_Factor      | Not_Indispensable | Not_Indispensable |
|    2 | TP53  |       0.500 | Non_Significant  | Critical          | Redundant         |
|    3 | CREBBP|       0.465 | Non_Significant  | Critical          | Redundant         |
|    4 | EP300 |       0.460 | Non_Significant  | Critical          | Redundant         |
|    5 | CDC26 |       0.439 | Preventive_Factor| Not_Indispensable | Not_Indispensable |
|    6 | YWHAG |       0.398 | Non_Significant  | Critical          | Redundant         |
|    7 | SMAD3 |       0.372 | Non_Significant  | Critical          | Redundant         |
|    8 | GRB2  |       0.358 | Non_Significant  | Critical          | Redundant         |
|    9 | SRC   |       0.329 | Non_Significant  | Critical          | Redundant         |
|   10 | EIF5A |       0.307 | Risk_Factor      | Not_Indispensable | Not_Indispensable |

   - Check `alpha=0.0`:
   ```R
   source("generate_report_function.R")
   generate_report(file_path = "input_data/mt_robin_CT.csv", alpha = 0.0, num_genes_to_print = 10, output_file = "results/gene_report.csv")
   ```
   Output:
   - Number of Risk genes: 0
   - Number of Preventive genes: 0
   - Number of TypeI Critical genes: 10
   - Number of TypeII Critical genes: 0 
   - Total number of protein-coding-genes: 1654

| Rank | Gene  | Final_Score | Gene_Effect      | TypeI    | TypeII    |
|-----:|:------|------------:|:-----------------|:---------|:----------|
|    1 | TP53  |       1.000 | Non_Significant  | Critical | Redundant |
|    2 | CREBBP|       0.931 | Non_Significant  | Critical | Redundant |
|    3 | EP300 |       0.920 | Non_Significant  | Critical | Redundant |
|    4 | YWHAG |       0.796 | Non_Significant  | Critical | Redundant |
|    5 | SMAD3 |       0.744 | Non_Significant  | Critical | Redundant |
|    6 | GRB2  |       0.716 | Non_Significant  | Critical | Redundant |
|    7 | SRC   |       0.657 | Non_Significant  | Critical | Redundant |
|    8 | ESR1  |       0.585 | Non_Significant  | Critical | Redundant |
|    9 | AR    |       0.581 | Non_Significant  | Critical | Redundant |
|   10 | RB1   |       0.564 | Non_Significant  | Critical | Redundant |

5. The function will output a ranked list of genes and a summary of the results to the specified output file.

## Dependencies

- **R** version 4.0 or later
- R libraries: `dplyr`, `knitr`, `pander`

Install the required libraries in R:
```R
install.packages(c("dplyr", "knitr", "pander"))
```

## Customization

Applying the same framework, users can modify the input data to analyze other diseases and apply other MR and CT methods to explore different conditions or datasets.

## Contributing

We welcome contributions from the community! If you would like to contribute to this project, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or issues, please open an issue in this repository or contact the project lead at [sindypin2005@gmail.com](mailto:sindypin2005@gmail.com).
