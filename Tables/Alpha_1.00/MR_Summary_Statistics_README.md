# Summary Statistics of Causal Genes when alpha = 1.00

## Purpose:

The "Alpha_1.00_Genes.xlsx" dataset provides results of 16 significant causal genes as risk or preventive factors for Long-COVID identified when setting `alpha=1.00` in our framework:

## Column Descriptions:

- **Rank:** Rank of genes based on Final Score.
- **Ensembl_Gene_ID**: Unique identifier for genes in the Ensembl database.
- **Gene_Symbol**: Standardized gene name.
- **Synonyms**: Gene name synonyms.
- **SNPs**: Count of single nucleotide polymorphisms associated with each gene.
- **SNPs_IDs**: Identifiers for the associated SNPs.
- **Obs**: Number of tissues for each gene-SNP(s) combination.
- **beta_y**: Estimated effect size of the gene on the trait.
- **Min**, **Max**: Extreme values of statistical measures across different conditions or tissues.
- **First_Q**, **Third_Q**: First (25%) and third (75%) quartiles of beta_y.
- **Median**: Midpoint of the effect size distribution.
- **SD_RE**, **Res_SD_RE**: Standard deviation of random effects and its residual component.
- **Var_RE**, **Res_Var_RE**: Variance of random effects and its residual component.
- **SE_FE**: Standard error of fixed effects.
- **t_value_FE**: T-statistic value for fixed effects.
- **REML**: Restricted maximum likelihood estimate.
- **p_value**: Probability of observing the effect size under the null hypothesis.
- **FDR**: False discovery rate, adjusted p-value.
- **CI_lower**, **CI_upper**: Confidence interval bounds for beta_y.
- **Tissues**: Specific tissues where gene-SNP associations are observed.
- **Tissue_Categories**: Broader biological systems impacted by the gene-SNP associations.
- **Lung_Tissue**: Indicates expression in lung tissues (1 = Yes, 0 = No).
- **Literature**: Literature support for gene-SNP associations with COVID-19 or long-COVID traits (if available).

## Reference:

For further reading and understanding of the methodologies used in this analysis, refer to the following publication:

Gleason, K.J., et al., 2021. A robust two-sample transcriptome-wide Mendelian randomization method integrates GWAS with multi-tissue eQTL summary statistics. Genetic Epidemiology, 45(4), 353-371.
