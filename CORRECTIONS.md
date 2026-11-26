# Notes and corrections to the published article

Article: Pinero S, et al. Integrative multi-omics framework for causal gene discovery in Long COVID. PLOS Computational Biology 2025;21(12):e1013725. doi:[10.1371/journal.pcbi.1013725](https://doi.org/10.1371/journal.pcbi.1013725)

After publication we audited the code and the stored outputs against the article. This file lists the statements that need a correction, what the files show, and where the corrected material is. Last update: November 2026.

| # | Topic | Effect on the results |
|---|---|---|
| 1 | Control theory step: network structure only | Gene list unchanged. Interpretation changes |
| 2 | Weights of Type I and Type II critical genes | None. Text only |
| 3 | Agreement between the two PPI networks | The reported value changes |
| 4 | Symptom differences between the clusters, and Table 7 | The result changes |
| 5 | Other statements about the data and the clustering | None or small. Text only |

## 1. The control theory step used the network structure only

**In the article.** The PPI network is described as placed "within the specific context of Long COVID", and the 16 network driver genes are described as genes of a Long COVID network.

**What the files show.** The gene expression file was used to list the genes that were measured. The expression values did not enter the network. The network analysed (6,327 proteins, 34,620 interactions) is the general human PPI network of Vinayagam et al., and the 16 genes are its 16 most connected proteins. They are not specific to Long COVID.

**Corrected material.** [`SM/SM13`](SM/SM13) adds the analysis with gene expression at seven correlation thresholds. Six genes remain in the top 16 at every threshold (TP53, EP300, CREBBP, GRB2, MAPK1, FYN). The comparison with recovered patients shows no difference beyond chance.

## 2. Weights of Type I and Type II critical genes

**In the article (main text).** Type I critical genes receive a weight of 1 and Type II critical genes a weight of 2.

**What the files show.** The code gives a weight of 2 to Type I critical genes and a weight of 1 to Type II critical genes, as in the supplementary methods (Eq 7) and in [`SM/SM11/fusion_scores.csv`](SM/SM11/fusion_scores.csv). The supplementary methods and the results are correct. The main text has the two weights reversed.

## 3. Agreement between the Vinayagam network and OmniPath

**In the article.** The controllability scores of the two networks are reported to agree with a Spearman correlation of 0.61, described as moderate to strong agreement.

**What the files show.** Across the 3,027 genes present in both networks:

| Measure | Value |
|---|---:|
| Spearman correlation of the number of connections (K) | 0.48 |
| Spearman correlation of the control theory score, all 3,027 shared genes | 0.16 |
| Spearman correlation of the control theory score, the 423 genes with a score above zero in both networks | 0.70 |
| Top 16 genes shared by the two networks | 4 of 16 (SRC, TP53, MAPK1, CSNK2A1) |
| Type I critical genes shared | 256 (Jaccard index 0.16) |

No stored output gives 0.61. Most genes have a score of zero in one of the two networks, so the agreement across all shared genes is weak; among the genes that are critical in both networks the scores agree well. The statement that the comparison validates the robustness of the network results is therefore not supported as written. The description in [`SM/SM12/PPIs.md`](SM/SM12/PPIs.md) has the same limitation. The values above are in [`SM/SM12/Network_Agreement.tsv`](SM/SM12/Network_Agreement.tsv).

## 4. Symptom differences between the clusters, and Table 7

**In the article.** Symptoms were compared between the three gene expression clusters, and most symptoms are reported as significantly different (18 of 22 in the stored output). The clusters are described as distinct symptom based subtypes.

**What the files show.** The tests were run on the rows of the clinical table, which has several rows per patient, and not on the 154 patients. Each patient was therefore counted several times, which made the p values far too small. When each patient is counted once (clusters of 65, 53 and 36 patients), one of the 22 symptoms differs between the clusters after correction for multiple testing:

| Symptom | Cluster 1 | Cluster 2 | Cluster 3 | Published p | p per patient |
|---|---:|---:|---:|---:|---:|
| Nausea, diarrhoea, vomiting | 9 | 4 | 14 | 1.4e-116 | 0.0004 |
| Sleep problems | 32 | 15 | 12 | 1.0e-32 | 0.052 |
| Increased mucus | 19 | 8 | 6 | 1.1e-41 | 0.13 |
| Cavities, teeth problems | 9 | 10 | 2 | 2.3e-09 | 0.21 |
| Smell or taste problems | 13 | 5 | 6 | 8.2e-15 | 0.28 |
| Anxiety, depression | 24 | 20 | 9 | 0.008 | 0.40 |
| Lung problems | 15 | 8 | 5 | 7.7e-07 | 0.40 |
| Headaches | 20 | 12 | 12 | 2.2e-20 | 0.48 |
| Eating more or less | 31 | 20 | 17 | 1.6e-13 | 0.51 |

Numbers are patients with the symptom. The table shows the nine symptoms with the smallest published or per patient p values. Tests are chi square tests, or Fisher exact tests when an expected count is below 5, with Benjamini Hochberg adjustment over the 22 symptoms. Only nausea, diarrhoea and vomiting remains significant (adjusted p = 0.009). Two of the published test statistics (533.6 and 188.7) are larger than the number of patients, which is not possible for a test on 154 patients. The three clusters are gene expression clusters. Apart from this one symptom group, their symptom profiles do not differ significantly.

**Table 7.** The sections for clusters 1 and 2 show the two cluster solution (76 and 78 patients) and not the three cluster solution used in the text (65 and 53 patients). In the section for cluster 3, five values do not match the stored output: weakness or fatigue (15, output 17), memory or thought problems (12, output 17), muscle pain (12, output 16), shortness of breath (9, output 13) and chest pain or cardiac issues (8, output 10). [`SM/SM8/Symptoms_Frequency.tsv`](SM/SM8/Symptoms_Frequency.tsv) also holds the two cluster solution. The corrected table is in [`SM/SM8/Table7_Corrected.tsv`](SM/SM8/Table7_Corrected.tsv).

**Corrected material.** [`SM/SM8/Symptom_Tests_Per_Patient.tsv`](SM/SM8/Symptom_Tests_Per_Patient.tsv) has the tests for all 22 symptoms, and [`SM/SM8/Symptoms_Frequency_3_Clusters.tsv`](SM/SM8/Symptoms_Frequency_3_Clusters.tsv) has the counts and percentages for the three cluster solution. Both files hold counts per cluster only.

## 5. Other statements about the data and the clustering

| Statement in the article | What the files show |
|---|---|
| 413 blood samples from 158 individuals with Long COVID | 412 sample columns from 158 individuals, of which 366 hold expression values. The clustering used 154 individuals |
| Clustering of 32 genes | 31 genes. ITPRID1 is not in the expression matrix that was clustered ([`SM/SM8/Cluster_Mean_Expression.tsv`](SM/SM8/Cluster_Mean_Expression.tsv)) |
| The number of clusters was chosen by the highest average silhouette width and a balanced distribution | Two clusters have the highest width (0.99, with 76 and 78 patients). Three clusters have 0.87. The solutions use different distance measures, so their widths are not directly comparable ([`SM/SM8/Best_Configurations.tsv`](SM/SM8/Best_Configurations.tsv)) |
| Fixed seed of 5 for the clustering | The script uses seed 1 |
| Age, sex and smoking status evenly distributed between clusters (all p > 0.1) | The stored tests cover sex (p = 0.91) and smoking status (p = 0.49). No test for age is in the stored output |
| Leave one out diagnostics were implemented for the Mendelian randomisation | No leave one out analysis is in the public notebooks |

## Participant data

The file `SM/SM8/Cluster_Assignments.tsv`, which listed one cluster per participant, was removed from the repository in November 2026. The clinical data of GSE215865 are under controlled access and must be requested from Synapse.

