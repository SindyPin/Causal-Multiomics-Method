# Supplementary Material 3: Enrichment Analysis of the Core Causal Genes for Long-COVID

## Purpose and Application:

The results of the enrichment analysis provided in the following datasets offer insights into the biological significance of genes for Long-COVID identified as causal by our framework:
- GO: go_analysis_results_core_causal_genes.tsv
- KEGG: kegg_analysis_results_core_causal_genes.tsv
- Reactome: reactome_analysis_results_core_causal_genes.tsv 

## Types of Enrichment Analysis Applied in this Study:

1. **Gene Ontology (GO) Enrichment Analysis**: Determines overrepresentation of GO terms in biological processes, molecular functions, and cellular components.
2. **Pathway Enrichment Analysis**: Identifies overrepresentation of genes in specific pathways. In this study, we used KEGG and Reactome for this purpose, suggesting involvement in particular biological functions or diseases.

## Column Descriptions:

- **ID**: Unique identifier for the pathway in the respective database (KEGG, Reactome, or GO).
- **Description**: Detailed description of the pathway, providing insight into the biological processes, molecular functions, or cellular components associated with the pathway.
- **GeneRatio**: The ratio of genes in the gene set that are associated with a particular pathway, compared to the total number of genes in that gene set. This is expressed as a fraction (e.g., 3/10). Higher values indicate more genes from the gene set are associated with the pathway, which may suggest stronger enrichment.
- **BgRatio**: The background ratio representing the proportion of genes associated with the pathway across the entire set of genes analyzed. This is used to provide context for enrichment analysis. Higher values indicate a greater background association with the pathway.
- **pvalue**: The raw p-value representing the probability that the association between the gene set and the pathway is due to random chance. Lower values indicate a stronger statistical significance of the pathway's enrichment.
- **p.adjust**: The p-value adjusted for multiple hypothesis testing using the Benjamini-Hochberg method to control the false discovery rate (FDR). Lower adjusted p-values indicate more reliable associations after correction for multiple testing.
- **qvalue**: The q-value, which is a false discovery rate (FDR)-adjusted p-value that provides a measure of confidence in the association between the gene set and the pathway, with a focus on controlling for type I errors. Lower q-values suggest a higher level of confidence in the result.
- **geneID**: The list of genes from the gene set that are involved in the pathway, represented by their unique identifiers as Entrez IDs.
- **Count**: The number of genes from the gene set that are associated with the pathway. A higher count indicates a larger number of gene associations within the pathway, suggesting a potentially stronger pathway enrichment.
- **gene_names:** The name of each gene for each enriched pathway.

### **Additional Columns for GO Pathways:**

- **ONTOLOGY**:  
  Indicates the specific branch of Gene Ontology to which the pathway belongs. This can be one of the following:
  - **BP**: Biological Process
  - **MF**: Molecular Function
  - **CC**: Cellular Component

# References:

For further reading and understanding of the methodologies used in this analysis, refer to the following publications:

- Ashburner, M., et al., 2000. Gene ontology: tool for the unification of biology. The Gene Ontology Consortium. Nature Genetics, 25(1), 25-29.
- The Gene Ontology Consortium, 2023. The Gene Ontology knowledgebase in 2023. Nucleic Acids Research, 51(D1), D1-D2.
- Kanehisa, M., & Goto, S., 2000. KEGG: Kyoto Encyclopedia of genes and genomes. Nucleic Acids Research, 28(1), 27-30.
- Milacic, M., et al., 2024. The Reactome Pathway Knowledgebase 2024. Nucleic Acids Research, 52(D1), D1-D2.
