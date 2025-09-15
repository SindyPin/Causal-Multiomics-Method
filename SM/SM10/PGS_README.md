# Polygenic Risk Score Integration Analysis

This repository contains supplementary data tables for the Polygenic Risk Score (PGS) integration analysis conducted as part of our Long COVID causal gene discovery study.

## File: `PGS.xlsx`

This Excel file contains six worksheets with comprehensive results from our PGS integration analysis:

### Sheet 1: `All_PGS_Genes`
**Description:** Complete list of all unique genes mapped from COVID-19 PGS datasets
- **Columns:**
  - `gene`: Gene symbol
  - `n_pgs`: Number of PGS datasets containing this gene (1-3)
  - `pgs_sources`: Source PGS datasets (PGS002272, PGS002273, PGS004938)
- **Records:** 3,190 unique genes
- **Purpose:** Shows the complete gene universe derived from COVID-19 PGS for comparison with Long COVID genes

### Sheet 2: `Overlap`
**Description:** Genes that appear in multiple PGS datasets
- **Columns:**
  - `gene`: Gene symbol
  - `n_sources`: Number of PGS datasets (2-3)
  - `pgs_ids`: Contributing PGS dataset identifiers
- **Records:** 711 genes appearing in 2+ datasets
- **Purpose:** Identifies genes with stronger support across multiple COVID-19 PGS

### Sheet 3: `Sensitivity`
**Description:** Results from sensitivity analyses with different mapping parameters
- **Columns:**
  - `label`: Analysis identifier (primary, sens_A, sens_B1, sens_B2)
  - `percentile`: Filtering threshold for PGS004938 (0.975)
  - `window_kb`: TSS mapping window size (50 or 100 kb)
  - `k_policy`: Tie-handling approach ("ties" or "nearest1")
  - `k_nearest_max`: Maximum genes per SNP (1-3)
  - `tie_tol_bp`: Tie tolerance in base pairs (5000)
  - `clump_kb`: LD clumping distance (200 kb)
  - `union_genes`: Total unique genes mapped
  - `overlap`: Number of Long COVID genes found
  - `precision`, `recall`, `f1`: Performance metrics
  - `enrich_p`: Statistical enrichment p-value
  - `frac_ge2`: Fraction of overlapping genes in ≥2 datasets
  - `spread`: Range of genes across datasets
- **Records:** 4 sensitivity analyses
- **Purpose:** Demonstrates robustness of findings across parameter variations

### Sheet 4: `Distance`
**Description:** Distance from each Long COVID gene to nearest COVID-19 PGS variant
- **Columns:**
  - `gene`: Gene symbol
  - `min_bp_to_selected_snp`: Minimum distance to PGS SNP (base pairs)
  - `within_50kb`: Boolean, gene within 50kb of PGS SNP
  - `within_100kb`: Boolean, gene within 100kb of PGS SNP
- **Records:** 6,339 genes analyzed
- **Purpose:** Quantifies spatial relationship between Long COVID genes and COVID-19 PGS variants

### Sheet 5: `Clump`
**Description:** Comparison of different LD clumping distances
- **Columns:**
  - `label`: Clumping strategy identifier
  - `percentile` through `enrich_p`: Same as Sensitivity sheet
  - `clump_kb`: LD clumping distance (100 vs 200 kb)
- **Records:** 2 clumping strategies
- **Purpose:** Shows impact of LD clumping parameters on gene mapping

### Sheet 6: `Intersect`
**Description:** Venn diagram data showing gene distribution across PGS datasets
- **Columns:**
  - `region`: Set intersection description
  - `n`: Number of genes in each region
- **Records:** 7 intersection regions
- **Purpose:** Visualizes overlap patterns between the three PGS datasets

## Analysis Overview

This supplementary analysis was conducted to assess the translational potential of our 32 Long COVID putative causal genes by comparing them with existing COVID-19 genetic risk prediction models. The analysis employed:

- **TSS-based mapping:** ±50kb window from transcription start sites
- **LD clumping:** 200kb distance-based filtering to remove correlated variants
- **Sensitivity testing:** Multiple parameter combinations to ensure robustness
- **Statistical assessment:** Fisher's exact test for enrichment analysis

## Key Findings

- **3,190 unique genes** identified from combined COVID-19 PGS datasets
- **9.4% overlap** (3/32 genes) between Long COVID and COVID-19 PGS genes
- **Non-significant enrichment** (p = 0.72) indicating distinct genetic architectures
- **66% of Long COVID genes** operate beyond typical cis-regulatory range (>100kb from PGS variants)

## Usage

These tables support the main manuscript findings and can be used for:
- Replication of PGS integration analysis
- Extended analysis with different parameters
- Cross-validation with other Long COVID gene sets
- Development of combined genetic risk models

For questions about the data or analysis methods, please refer to the main manuscript Methods section or contact the corresponding authors.
