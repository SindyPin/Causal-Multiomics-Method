# Gene Expression Clustering Analysis for Long COVID Subtypes

This directory contains data, results, and figures from gene expression clustering analysis in Long COVID patients. The analysis stratifies patients into subgroups using gene expression data from 32 identified causal genes we found from our framework, revealing distinct symptom profiles and biological pathways associated with each cluster.

## Files in the Repository

### Figures
1. **silhouette_plot_2C.png**  
   Silhouette plot for clustering into **2 clusters**.  
   - **Description:** Shows the distribution of silhouette widths for 2 clusters. The average silhouette width is 0.99, indicating strong clustering performance.  
   - **Clusters:**
     - Cluster 1: 76 individuals (ASW: 0.99)
     - Cluster 2: 78 individuals (ASW: 0.99)

2. **silhouette_plot_3C.png**  
   Silhouette plot for clustering into **3 clusters**.  
   - **Description:** Shows the distribution of silhouette widths for 3 clusters. The average silhouette width is 0.86, indicating good clustering performance.  
   - **Clusters:**
     - Cluster 1: 65 individuals (ASW: 0.93)
     - Cluster 2: 53 individuals (ASW: 0.85)
     - Cluster 3: 36 individuals (ASW: 0.75)

3. **silhouette_plot_4C.png**  
   Silhouette plot for clustering into **4 clusters**.  
   - **Description:** Shows the distribution of silhouette widths for 4 clusters. The average silhouette width is 0.98, indicating strong clustering performance.  
   - **Clusters:** Balanced clusters with high silhouette widths.

4. **silhouette_plot_5C.png**  
   Silhouette plot for clustering into **5 clusters**.  
   - **Description:** Shows the distribution of silhouette widths for 5 clusters. The average silhouette width is 0.83, indicating moderate clustering performance.  
   - **Clusters:** Cluster assignments show distinct biological relevance but slightly lower clustering performance compared to 3 or 4 clusters.

### Data Files
1. **Best_Configurations.xlsx**  
   This tabletains the best clustering configurations, detailing the optimal parameters, metrics, and results for different numbers of clusters.

2. **cluster_assignments**  
   File with the patient assignments to clusters for 3 clusters.  
   - **Columns:**  
     - `Subject_ID`: Unique identifier for each patient.  
     - `Cluster`: Cluster number (1, 2, or 3).  

3. **cluster_mean_expression**  
   File with the mean gene expression levels for each gene in each cluster.  
   - **Columns:**  
     - Gene names and their average expression levels for clusters 1, 2, and 3.  

4. **Combined_Clustering_Results**  
   Comprehensive results of all clustering analyses, including metrics like silhouette width, cluster assignments, and other clustering parameters.  

5. **Symptoms_Frequency**  
   File summarizing the frequency of symptoms across different clusters.  
   - Includes symptom categories (e.g., respiratory, psychological, gastrointestinal) and their prevalence in each cluster.

## Context for Analysis
This analysis aims to stratify Long COVID patients into biologically distinct subtypes using gene expression data from the causal genes we found. 
Key findings:
- Identified three main clusters with distinct gene expression patterns and symptom profiles.
- Cluster-specific pathways and biological functions reveal potential therapeutic targets for addressing Long COVID's heterogeneous manifestations.
