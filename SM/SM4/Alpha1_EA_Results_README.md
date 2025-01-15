# Enrichment Analysis of Causal Genes when `alpha = 1.00`

## Purpose and Application:

This README explains the "Alpha_1.00_EA_Genes.xlsx" dataset, which results from enrichment analysis on causal genes identified when alpha = 1.00.
The analysis identifies biological functions, pathways, and potential Long-COVID symptoms associated with these genes.

## Types of Enrichment Analysis Used in this Study:

1. **Gene Ontology (GO) Enrichment Analysis**: Determines overrepresentation of GO terms in biological processes, molecular functions, and cellular components.
2. **Pathway Enrichment Analysis**: Identifies overrepresentation of genes in specific pathways. This study used KEGG and Reactome for this purpose, suggesting involvement in particular biological functions or diseases.

## Dataset Overview:

The dataset highlights significant causal genes when `alpha = 1.00`, focusing on gene functions and pathways.

## Column Descriptions:

- **Gene_Set_ID**: Unique identifier for each gene set, with pathways highlighted in different colors.
- **Ensembl_Gene_ID**: Unique identifier for genes in the Ensembl database.
- **Entrez_Gene_ID**: Unique identifier for genes in the NCBI Entrez database.
- **Gene_Symbol**: Common name or symbol for the gene.
- **Synonyms**: Gene name synonyms.
- **Gene_Function**: Brief description of the gene's function.
- **Database**: Source database for pathway or gene function information.
- **Path_ID**: Unique identifier for the pathway the gene is involved in.
- **Path_Description**: Description of the pathway.
- **Gene_Ratio**: Ratio of observed genes to the total number of genes in the pathway.
- **Bg_Ratio**: Background ratio of pathway genes to the total number of genes analyzed.
- **p_value**: Probability that the gene's association with the pathway is due to chance.
- **p_adjust**: Adjusted p-value for multiple hypothesis testing.
- **q_value**: False discovery rate-adjusted p-value.
- **Count**: Number of genes in the gene set involved in the pathway.
- **Possible_Long-COVID_Symptoms**: Potential symptoms linked to the gene, if relevant.

## References:

For further reading and understanding of the methodologies used in this analysis, refer to the following publication:

- Ashburner, M., et al., 2000. Gene ontology: a tool for the unification of biology. The Gene Ontology Consortium. Nature Genetics, 25(1), 25-29.
- The Gene Ontology Consortium, 2023. The Gene Ontology knowledgebase in 2023. Nucleic Acids Research, 51(D1), D1-D2.
- Kanehisa, M., & Goto, S., 2000. KEGG: Kyoto Encyclopedia of genes and genomes. Nucleic Acids Research, 28(1), 27-30.
- Milacic, M., et al., 2024. The Reactome Pathway Knowledgebase 2024. Nucleic Acids Research, 52(D1), D1-D2.
