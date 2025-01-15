%%R

# Load necessary libraries:
library(dplyr)
library(knitr)
library(pander)

# Function to calculate Final_Score, summarize results, and output to a file:
generate_report <- function(file_path, alpha, num_genes_to_print = Inf, output_file) {
  
  # Step 1: Read the input data from the specified CSV file
  data <- read.csv(file_path)
  
  # Step 2: Replace NA values in MR_Score_norm and CT_Score_norm with 0
  data <- data %>%
    mutate(
      MR_Score_norm = ifelse(is.na(MR_Score_norm), 0, MR_Score_norm),
      CT_Score_norm = ifelse(is.na(CT_Score_norm), 0, CT_Score_norm)
    )
  
  # Step 3: Calculate Final_Score based on the alpha parameter and select genes
  data <- data %>%
    mutate(
      # Calculate the Final_Score by combining MR_Score_norm and CT_Score_norm
      Final_Score = case_when(
        !is.na(MR_Score_norm) & !is.na(CT_Score_norm) ~
          alpha * MR_Score_norm + (1 - alpha) * CT_Score_norm,  # Use both scores when available
        !is.na(MR_Score_norm) ~ MR_Score_norm,  # Use MR_Score_norm if CT_Score_norm is missing
        !is.na(CT_Score_norm) ~ CT_Score_norm  # Use CT_Score_norm if MR_Score_norm is missing
      )
    )
  
  # Step 4: Print summary statistics for the entire dataset
  num_risk_genes <- sum(data$Gene_Effect == "Risk", na.rm = TRUE)
  num_preventive_genes <- sum(data$Gene_Effect == "Preventive", na.rm = TRUE)
  num_typeI_critical <- sum(data$TypeI == 0, na.rm = TRUE)
  num_typeII_critical <- sum(data$TypeII == 0, na.rm = TRUE)
  total_genes <- nrow(data)
  
  cat("Total number of genes in the dataset:", total_genes, "\n")
  cat("Total Number of Risk genes:", num_risk_genes, "\n")
  cat("Total Number of Preventive genes:", num_preventive_genes, "\n")
  cat("Total Number of TypeI Critical genes:", num_typeI_critical, "\n")
  cat("Total Number of TypeII Critical genes:", num_typeII_critical, "\n")
  
  # Step 5: Select the top genes based on user input
  selected_genes <- data %>%
    arrange(desc(Final_Score)) %>%  # Arrange the data by Final_Score in descending order
    head(num_genes_to_print)  # Select the top genes based on the specified number
  
  # Step 6: Print the number of selected genes and their categories
  num_selected_genes <- nrow(selected_genes)
  num_selected_risk_genes <- sum(selected_genes$Gene_Effect == "Risk", na.rm = TRUE)
  num_selected_preventive_genes <- sum(selected_genes$Gene_Effect == "Preventive", na.rm = TRUE)
  num_selected_typeI_critical <- sum(selected_genes$TypeI == 0, na.rm = TRUE)
  num_selected_typeII_critical <- sum(selected_genes$TypeII == 0, na.rm = TRUE)
  
  cat("\n")
  cat("Number of selected genes:", num_selected_genes, "\n")
  cat("Number of Selected Risk genes:", num_selected_risk_genes, "\n")
  cat("Number of Selected Preventive genes:", num_selected_preventive_genes, "\n")
  cat("Number of Selected TypeI Critical genes:", num_selected_typeI_critical, "\n")
  cat("Number of Selected TypeII Critical genes:", num_selected_typeII_critical, "\n")
  cat("\n")
  
  # Step 7: Add a Rank column to indicate the order
  selected_genes <- selected_genes %>%
    mutate(Rank = row_number())  # Add a Rank column based on the row number
  
  # Step 8: Conditionally add the Gene_Effect column if MR_Score_norm != 0, else set to "No Effect"
  selected_genes <- selected_genes %>%
    mutate(Gene_Effect = ifelse(MR_Score_norm != 0, Gene_Effect, "No_Effect"))
  
  # Step 9: Conditionally add the Critical_Gene column if CT_Score_norm != 0, else set to "Not Critical"
  selected_genes <- selected_genes %>%
    mutate(Critical_Gene = case_when(
      TypeI == 0 ~ "TypeI",
      TypeII == 0 ~ "TypeII",
      TRUE ~ "Not_Critical"
    ))
  
  # Step 10: Select the final columns based on conditions
  final_columns <- c("Rank", "gene_name", "MR_Score_norm", "CT_Score_norm", "Final_Score", "Gene_Effect", "Critical_Gene")
  
  # Step 11: Save the final table as a CSV file
  selected_genes %>%
    dplyr::select(all_of(final_columns)) %>%
    write.csv(output_file, row.names = FALSE)  # Write the selected columns to a CSV file without row names
  
  cat("Results saved to:", output_file, "\n")  # Print a message indicating where the file was saved
  
  # Step 12: Display the first few rows of the final table
  selected_genes %>%
    dplyr::select(all_of(final_columns)) %>%  # Select columns to display
    kable()  # Format the output as a table
}
