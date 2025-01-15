# Supplementary Material 5: Enrichment Analysis of Causal Genes when `alpha = 1.00` (Network Driver Genes)

## Purpose and Application:

This README explains the "Each_Network_Driver_EA_Genes" folder for each gene in different tables, which results from enrichment analysis on causal genes identified when alpha = 1.00.
The analysis identifies biological functions, pathways, and potential Long-COVID symptoms associated with these genes.

## Types of Enrichment Analysis Used in this Study:

1. **Gene Ontology (GO) Enrichment Analysis**: Determines overrepresentation of GO terms in biological processes, molecular functions, and cellular components.
2. **Pathway Enrichment Analysis**: Identifies overrepresentation of genes in specific pathways. This study used KEGG and Reactome for this purpose, suggesting involvement in particular biological functions or diseases.

## Dataset Overview:

The dataset highlights significant causal genes when `alpha = 1.00`, focusing on gene functions and pathways.

## Column Descriptions:

- **ID**: Unique identifier for the pathway the gene is involved in.
- **Description**: Description of the pathway.
- **GeneRatio**: Ratio of observed genes to the total number of genes in the pathway.
- **BgRatio**: Background ratio of pathway genes to the total number of genes analyzed.
- **pvalue**: Probability that the gene's association with the pathway is due to chance.
- **p.adjust**: Adjusted p-value for multiple hypothesis testing.
- **qvalue**: False discovery rate-adjusted p-value.
- **geneID**: Unique identifier for each enriched gene.
- **Count**: Number of genes in the gene set involved in the pathway.
- **gene_names**: Common name or symbol for the gene.

## References:

For further reading and understanding of the methodologies used in this analysis, refer to the following publication:

- Ashburner, M., et al., 2000. Gene ontology: a tool for the unification of biology. The Gene Ontology Consortium. Nature Genetics, 25(1), 25-29.
- The Gene Ontology Consortium, 2023. The Gene Ontology knowledgebase in 2023. Nucleic Acids Research, 51(D1), D1-D2.
- Kanehisa, M., & Goto, S., 2000. KEGG: Kyoto Encyclopedia of genes and genomes. Nucleic Acids Research, 28(1), 27-30.
- Milacic, M., et al., 2024. The Reactome Pathway Knowledgebase 2024. Nucleic Acids Research, 52(D1), D1-D2.
