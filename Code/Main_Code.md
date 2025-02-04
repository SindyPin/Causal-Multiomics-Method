# Main Code

This file describes the functionality and usage of the `generate_report` function in R. This function processes a dataset of genetic information to calculate scores, rank genes, and generate an output report. Below is a detailed breakdown of the script.

---

## Overview
The `generate_report` function is designed to:
- Process input genetic data to normalize scores and calculate a final score based on a specified weight (alpha).
- Summarize the dataset, including counts of risk, preventive, and critical genes.
- Select the top genes based on their scores and rank them.
- Generate a final report, save it as a CSV file, and display key results.

---

## Functionality

### Input
- **`file_path`**: Path to the input CSV file containing genetic data.
- **`alpha`**: Weighting parameter to calculate the final score as a weighted combination of `MR_Score_norm` and `CT_Score_norm`.
- **`num_genes_to_print`** *(default: `Inf`)*: The number of top genes to select and display based on the final score.
- **`output_file`**: Path to save the final processed table as a CSV file.

### Steps
1. **Data Loading**: Reads the input data from a CSV file.
2. **Missing Value Handling**: Replaces `NA` values in `MR_Score_norm` and `CT_Score_norm` with 0.
3. **Final Score Calculation**: Combines `MR_Score_norm` and `CT_Score_norm` using the formula:
   \[
   Final\_Score = \alpha \cdot MR\_Score\_norm + (1 - \alpha) \cdot CT\_Score\_norm
   \]
4. **Summary Statistics**:
   - Counts the total number of genes, risk genes, preventive genes, Type I critical genes, and Type II critical genes.
5. **Gene Selection**:
   - Ranks genes based on the `Final_Score` in descending order.
   - Filters the top `num_genes_to_print` genes.
6. **Output Formatting**:
   - Adds ranking and classification columns (`Gene_Effect` and `Critical_Gene`).
   - Formats the final table with selected columns: `Rank`, `gene_name`, `MR_Score_norm`, `CT_Score_norm`, `Final_Score`, `Gene_Effect`, and `Critical_Gene`.
7. **Report Generation**:
   - Saves the processed data as a CSV file.
   - Displays the first few rows of the final table.

---

## Output
1. **CSV File**:
   - Contains ranked and selected genes with their scores and classifications.
   - Saved to the path specified in `output_file`.

2. **Summary Statistics**:
   - Total genes in the dataset.
   - Number of risk, preventive, Type I, and Type II critical genes.
   - Number of selected genes by category.

3. **Formatted Table**:
   - Displays the top genes in a structured format using the `kable` function.

---

## Usage Example

```R
# Example Usage
generate_report(
  file_path = "input_genes.csv",
  alpha = 0.7,
  num_genes_to_print = 50,
  output_file = "top_genes_report.csv"
)
```

### Explanation:
- **`file_path`**: Path to the input dataset (`input_genes.csv`).
- **`alpha = 0.7`**: The final score is calculated with 70% weight for `MR_Score_norm` and 30% for `CT_Score_norm`.
- **`num_genes_to_print = 50`**: Selects the top 50 genes based on their final score.
- **`output_file = "top_genes_report.csv"`**: Saves the processed output to `top_genes_report.csv`.

---

## Dependencies
Ensure the following R libraries are installed:
- **`dplyr`**: For data manipulation.
- **`knitr`**: For table formatting.
- **`pander`**: For displaying formatted tables.

Install them using:
```R
install.packages(c("dplyr", "knitr", "pander"))
```

---

## Typical Install and Run Time

- **Typical Install Time on a "Normal" Desktop Computer:**  
  The installation of required R packages (`dplyr`, `knitr`, `pander`) is **very fast**, typically taking less than a minute on a standard desktop computer with a stable internet connection.

- **Expected Run Time for Demo on a "Normal" Desktop Computer:**  
  The `generate_report` function is designed for efficiency and completes **very quickly**, usually within a few seconds, depending on the dataset size. For the provided demo dataset, the run time is almost instantaneous.

---

## Key Notes
- **Customization**: Adjust the `alpha` parameter to modify the weight of `MR_Score_norm` and `CT_Score_norm` in the `Final_Score` calculation.
- **Handling Missing Values**: The script replaces missing values in `MR_Score_norm` and `CT_Score_norm` with 0, ensuring a complete dataset for scoring.
