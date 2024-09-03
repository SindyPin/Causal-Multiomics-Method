# Long-COVID Gene Identification Framework

## Overview

This repository contains the code and necessary datasets for a novel bioinformatics framework that employs causality to identify genes potentially driving Long-COVID. Our approach integrates multi-omics data to find causal genes that influence the risk and prevention of Long-COVID, as well as the stability of its associated biological networks.

## Purpose

The goal of this project is to develop an advanced causal inference framework for multi-omics data in order to:
- Identify genes that may increase or decrease the risk of developing Long-COVID.
- Determine the role of these genes in maintaining the stability of biological networks affected by Long-COVID.
- Provide a ranked list of candidate genes that could be targeted for therapeutic intervention or further research.

## Methodology

The framework combines data from multiple omics layers (e.g., genomics, transcriptomics, proteomics) and applies our new causal framework and score to identify key drivers of Long-COVID. Specifically, we:
1. **Preprocess and normalize the data:** Handle missing values and standardize scores across datasets.
2. **Calculate a Final Score:** For each gene, a weighted score is computed based on its contributions to risk and prevention, adjusted by a user-defined parameter (`alpha`).
3. **Summarize and rank genes:** Genes are ranked based on their Final Scores, with additional annotations provided for their effect (Risk/Preventive) and criticality in biological networks.
4. **Generate a detailed report:** The top candidate genes are outputted to a CSV file, with a summary of key statistics provided.

## Files in This Repository

- **`generate_report_function.R`:** The primary R script containing the function to calculate Final Scores, rank genes, and generate a summary report.
- **`input_data/`:** A directory containing the input datasets required for running the analysis (e.g., normalized scores for genes across different omics layers).
- **`results/`:** Output directory for the generated reports and ranked gene lists.

## How to Use

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

   - Check all risk/preventive causal genes:
   ```R
   source("generate_report_function.R")
   generate_report(file_path = "input_data/mt_robin_CT.csv", alpha = 1, num_genes_to_print = 16, output_file = "results/gene_report.csv")
   ```
   Output:
   - Number of Risk genes: 9 
   - Number of Preventive genes: 7 
   - Number of TypeI Critical genes: 0 
   - Number of TypeII Critical genes: 0
   - Total number of genes: 6963 

| Rank|gene_name | MR_Score_norm| CT_Score_norm| Final_Score|Gene_Effect |Critical_Gene |
|----:|:---------|-------------:|-------------:|-----------:|:-----------|:-------------|
|    1|MORN4     |     1.0000000|             0|   1.0000000|Risk        |Not_Critical  |
|    2|CDC26     |     0.8778914|             0|   0.8778914|Preventive  |Not_Critical  |
|    3|EIF5A     |     0.6141077|             0|   0.6141077|Risk        |Not_Critical  |
|    4|VWDE      |     0.4532133|             0|   0.4532133|Risk        |Not_Critical  |
|    5|GMPPB     |     0.3882238|             0|   0.3882238|Risk        |Not_Critical  |
|    6|NDUFA6    |     0.2860991|             0|   0.2860991|Risk        |Not_Critical  |
|    7|BNIP1     |     0.2628553|             0|   0.2628553|Risk        |Not_Critical  |
|    8|CERS4     |     0.2280826|             0|   0.2280826|Preventive  |Not_Critical  |
|    9|ADAT1     |     0.2254065|             0|   0.2254065|Preventive  |Not_Critical  |
|   10|C19orf18  |     0.2252227|             0|   0.2252227|Risk        |Not_Critical  |
|   11|BOLA2     |     0.1787183|             0|   0.1787183|Preventive  |Not_Critical  |
|   12|CDA       |     0.1774153|             0|   0.1774153|Preventive  |Not_Critical  |
|   13|MORN3     |     0.1429947|             0|   0.1429947|Risk        |Not_Critical  |
|   14|CCDC129   |     0.1419264|             0|   0.1419264|Preventive  |Not_Critical  |
|   15|BTN3A1    |     0.1407982|             0|   0.1407982|Preventive  |Not_Critical  |
|   16|FAM214A   |     0.0642437|             0|   0.0642437|Risk        |Not_Critical  |
   
   - Check all network control genes:
   ```R
   source("generate_report_function.R")
   generate_report(file_path = "input_data/mt_robin_CT.csv", alpha = 0, num_genes_to_print = 10, output_file = "results/gene_report.csv")
   ```
   Output:
   - Number of Risk genes: 0 
   - Number of Preventive genes: 0 
   - Number of TypeI Critical genes: 10 
   - Number of TypeII Critical genes: 0 
   - Total number of genes: 6963 

| Rank|gene_name | MR_Score_norm| CT_Score_norm| Final_Score|Gene_Effect |Critical_Gene |
|----:|:---------|-------------:|-------------:|-----------:|:-----------|:-------------|
|    1|TP53      |             0|     1.0000000|   1.0000000|No_Effect   |TypeI         |
|    2|CREBBP    |             0|     0.9130435|   0.9130435|No_Effect   |TypeI         |
|    3|EP300     |             0|     0.9030100|   0.9030100|No_Effect   |TypeI         |
|    4|YWHAG     |             0|     0.8428094|   0.8428094|No_Effect   |TypeI         |
|    5|SMAD3     |             0|     0.7525084|   0.7525084|No_Effect   |TypeI         |
|    6|GRB2      |             0|     0.7023411|   0.7023411|No_Effect   |TypeI         |
|    7|SRC       |             0|     0.6521739|   0.6521739|No_Effect   |TypeI         |
|    8|AR        |             0|     0.5986622|   0.5986622|No_Effect   |TypeI         |
|    9|ESR1      |             0|     0.5819398|   0.5819398|No_Effect   |TypeI         |
|   10|RB1       |             0|     0.5652174|   0.5652174|No_Effect   |TypeI         |

   - Check half risk/preventive genes and half network control genes:
   ```R
   source("generate_report_function.R")
   generate_report(file_path = "input_data/mt_robin_CT.csv", alpha = 0.5, num_genes_to_print = 10, output_file = "results/gene_report.csv")
   ```
   Output:
   - Number of Risk genes: 2 
   - Number of Preventive genes: 1 
   - Number of TypeI Critical genes: 7 
   - Number of TypeII Critical genes: 0 
   - Total number of genes: 6963 

| Rank|gene_name | MR_Score_norm| CT_Score_norm| Final_Score|Gene_Effect |Critical_Gene |
|----:|:---------|-------------:|-------------:|-----------:|:-----------|:-------------|
|    1|TP53      |     0.0000000|     1.0000000|   0.5000000|No_Effect   |TypeI         |
|    2|MORN4     |     1.0000000|     0.0000000|   0.5000000|Risk        |Not_Critical  |
|    3|CREBBP    |     0.0000000|     0.9130435|   0.4565217|No_Effect   |TypeI         |
|    4|EP300     |     0.0000000|     0.9030100|   0.4515050|No_Effect   |TypeI         |
|    5|CDC26     |     0.8778914|     0.0000000|   0.4389457|Preventive  |Not_Critical  |
|    6|YWHAG     |     0.0000000|     0.8428094|   0.4214047|No_Effect   |TypeI         |
|    7|SMAD3     |     0.0000000|     0.7525084|   0.3762542|No_Effect   |TypeI         |
|    8|GRB2      |     0.0000000|     0.7023411|   0.3511706|No_Effect   |TypeI         |
|    9|SRC       |     0.0000000|     0.6521739|   0.3260870|No_Effect   |TypeI         |
|   10|EIF5A     |     0.6141077|     0.0000000|   0.3070538|Risk        |Not_Critical  |

5. The function will output a ranked list of genes and a summary of the results to the specified output file.

## Dependencies

- **R** version 4.0 or later
- R libraries: `dplyr`, `knitr`, `pander`

Install the required libraries in R:
```R
install.packages(c("dplyr", "knitr", "pander"))
```

## Contributing

We welcome contributions from the community! If you would like to contribute to this project, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or issues, please open an issue in this repository or contact the project lead at [sindypin2005@gmail.com](mailto:sindypin2005@gmail.com).
