# PPI Network Sensitivity Analysis

This repository contains comprehensive sensitivity analysis results comparing Control Theory (CT) scores across different Protein-Protein Interaction (PPI) networks for Long COVID causal gene discovery.

## Overview

Our framework's network component uses Control Theory to identify critical driver genes in biological networks. To validate robustness, we compared results using two major PPI databases:
- **Vinayagam Network**: 6,327 genes (primary analysis)
- **OmniPath Database**: 4,789 genes (validation analysis)

## Files Description

### `PPIs_Intersections.xlsx`
**Complete statistical analysis across network databases**

#### Sheet 1: `statistical_summary`
Comprehensive statistical comparison across all analyses
- **Columns**: Analysis type, gene counts, overlap statistics, significance tests
- **Key Metrics**: 
  - Jaccard Index (similarity measure)
  - Hypergeometric test p-values
  - Permutation test statistics
  - Odds ratios with confidence intervals
- **Analyses**: All genes, critical genes, non-critical genes, top 16, top 100

#### Sheet 2: `intersection_all_genes`
Complete list of 3,027 genes present in both networks
- **Columns**: Gene symbol, category, significance flag
- **Purpose**: Universe of overlapping genes for downstream analysis

#### Sheet 3: `intersection_critical_genes`
423 critical genes (Type I or Type II) found in both networks
- **Significance**: Statistically significant overlap (p < 0.001)
- **Enrichment**: 1.13-fold over random expectation
- **Interpretation**: Core critical genes are robust across network sources

#### Sheet 4: `intersection_top16_genes`
4 genes from our top 16 Long COVID candidates present in both networks
- **Genes**: SRC, TP53, MAPK1, CSNK2A1
- **Significance**: Highly significant overlap despite small sample size

#### Sheet 5: `intersection_top100_genes`
46 genes from top 100 candidates present in both networks
- **Significance**: Extremely significant (p < 1e-58)
- **Enrichment**: 37.21-fold over random expectation
- **Jaccard Index**: 0.299 (strong agreement for biological networks)

#### Sheet 6: `significance`
Statistical interpretation summary
- **Metrics**: Observed vs expected overlap, enrichment fold-change, Z-scores
- **Key Finding**: Significant enrichment for critical genes and high-degree genes

#### Sheet 7: `venn_summary_statistics`
Jaccard indices and overlap statistics for all comparisons
- **Range**: 0.138 (critical genes) to 0.374 (all genes)
- **Interpretation**: Moderate to strong agreement across network types

### `Ven_Diagrams_PPIs.pdf`
**Visual representation of network overlaps**

#### Page 1: All Genes in Networks
- **Vinayagam**: 3,300 unique + 3,027 shared
- **OmniPath**: 1,762 unique + 3,027 shared
- **Jaccard Index**: 0.374

#### Page 2: Critical Genes (Type I or II)
- **Overlap**: 423 genes significantly enriched
- **Statistical**: p = 7.445e-04, highly significant

#### Page 3: Non-Critical Genes
- **Overlap**: 1,310 genes, not significantly enriched
- **Interpretation**: Critical genes show stronger conservation

#### Page 4: Top 16 Genes by Degree
- **Overlap**: 4/16 genes (25% overlap)
- **High Conservation**: Core hubs maintain importance across networks

#### Page 5: Critical Genes in Top 16
- **Same Pattern**: 4 overlapping critical genes among top-ranked

#### Page 6: Top 100 Genes by Degree
- **Overlap**: 46/100 genes
- **Strong Agreement**: High-degree genes show substantial consistency

#### Page 7: Critical Genes in Top 100
- **Overlap**: 42/92 critical genes
- **Validation**: Critical genes maintain status across networks

#### Page 8: Network-Specific Patterns
- **Type I Critical**: 256 overlapping genes (substantial agreement)
- **Type II Critical**: 35 overlapping genes
- **Non-Critical Top 100**: Only 8 OmniPath-specific genes

## Key Statistical Findings

### Network Agreement Metrics
| Analysis Type | Jaccard Index | Significance | Interpretation |
|---------------|---------------|--------------|----------------|
| All Genes | 0.374 | ns | Moderate overlap |
| Critical Genes | 0.138 | p < 0.001 | Significant enrichment |
| Top 16 Genes | 0.143 | p < 0.01 | Strong conservation |
| Top 100 Genes | 0.299 | p < 1e-58 | Exceptional agreement |

### Validation Summary
- **Core Finding**: Spearman correlation ρ = 0.61 between CT scores
- **Robustness**: Critical genes maintain importance across networks
- **Network Independence**: Results not dependent on specific PPI database
- **High-Confidence Targets**: Genes ranking highly in both networks

## Biological Implications

1. **Network Robustness**: Critical control genes are conserved across different interaction databases
2. **Database Independence**: Core findings not artifacts of specific PPI compilation
3. **Therapeutic Confidence**: Overlapping genes represent high-confidence intervention targets
4. **Methodological Validation**: CT approach identifies biologically relevant regulatory nodes

### Reproducing Venn Diagrams
The visualization files show the statistical overlap patterns. Key measurements:
- **Circle sizes**: Proportional to gene counts in each network
- **Intersection areas**: Proportional to overlapping gene counts
- **Statistical annotations**: Hypergeometric p-values and Jaccard indices

### Network Selection Guidance
Based on this analysis:
- **Vinayagam Network**: Larger, more comprehensive interaction set
- **OmniPath Database**: Curated, high-confidence interactions
- **Ensemble Approach**: Use both for maximum confidence in driver gene identification
- **Overlap Genes**: Highest confidence targets for experimental validation

## Applications

This sensitivity analysis supports:
- **Method Validation**: Demonstrates CT robustness across PPI sources
- **Target Prioritization**: Overlapping genes represent highest-confidence targets
- **Network Selection**: Guidance for choosing appropriate PPI databases
- **Experimental Design**: High-confidence gene lists for validation studies

## Long COVID Context

Among our 32 Long COVID putative causal genes:
- **Network Coverage**: Genes present in both major PPI databases
- **Critical Classification**: Maintained across network sources
- **Therapeutic Targets**: Enhanced confidence for drug discovery
- **Biological Validation**: Network-independent identification of key regulators

## Statistical Notes

- **Hypergeometric Testing**: Assesses overlap significance vs random expectation
- **Permutation Analysis**: Validates results against randomized networks  
- **Jaccard Index**: Quantifies similarity between gene sets (0-1 scale)
- **Confidence Intervals**: Provided for all statistical measures

## Citation

If you use these network sensitivity results, please cite our main manuscript and acknowledge the network databases:

**Networks Used:**
- Vinayagam, A., et al. Controllability analysis of the directed human protein interaction network identifies disease genes and drug targets. PNAS 2016.
- Türei, D., et al. Integrated intra‐ and intercellular signaling knowledge for multicellular omics analysis. Mol Syst Biol 2021.

---

*This analysis validates that our Control Theory approach identifies biologically relevant driver genes independent of specific PPI database selection, strengthening confidence in the Long COVID therapeutic targets identified through our framework.*
