# Normalization Analysis for Long COVID Causal Gene Discovery

This repository contains comprehensive analysis results comparing different normalization techniques for integrating Mendelian Randomization (MR) and Control Theory (CT) scores in our Long COVID causal gene discovery framework.

## Overview

Our multi-omics framework combines two scoring systems:
- **SRisk**: Derived from Transcriptome-Wide Mendelian Randomization (TWMR) identifying risk/preventive genes
- **SNetwork**: Derived from Control Theory identifying network driver genes

We investigated whether different normalization techniques could achieve better integration of these complementary scoring systems across the α parameter range.

## Files Description

### `fusion_scores.csv`
**Complete dataset with all normalization results**
- **Records**: 6,339 genes
- **Columns**: 66 variables including:
  - Gene identifiers (`gene_id`, `gene_name`, `gene_type`)
  - Network properties (`K`, `Kin`, `Kout`, `TypeI`, `TypeII`, `Weight`)
  - Original scores (`CT_Score`, `MR_Score`, `beta_y`, `p_value`, `fdr`)
  - Normalized scores for 7 techniques × 5 α values each:
    - `MR_minmax`, `CT_minmax`, `Fused_minmax_a1.00` through `Fused_minmax_a0.00`
    - `MR_boxcox`, `CT_boxcox`, `Fused_boxcox_a1.00` through `Fused_boxcox_a0.00`
    - `MR_yeojohnson`, `CT_yeojohnson`, `Fused_yeojohnson_a1.00` through `Fused_yeojohnson_a0.00`
    - `MR_rin`, `CT_rin`, `Fused_rin_a1.00` through `Fused_rin_a0.00`
    - `MR_quantile`, `CT_quantile`, `Fused_quantile_a1.00` through `Fused_quantile_a0.00`
    - `MR_asinh`, `CT_asinh`, `Fused_asinh_a1.00` through `Fused_asinh_a0.00`
    - `MR_rank`, `CT_rank`, `Fused_rank_a1.00` through `Fused_rank_a0.00`

### Visualization Files
**Comprehensive comparison across different gene set sizes**

#### `Different_Normalization_Techniques_TOP16.pdf`
Visual comparison of the top 16 genes across all 7 normalization techniques:
- **Min-Max**: Our original normalization approach
- **Box-Cox**: Power transformation for normality
- **Yeo-Johnson**: Extended power transformation handling zero/negative values
- **Rank-Inverse Normal (RIN)**: Rank-based normal transformation
- **Quantile**: Uniform distribution transformation
- **Asinh**: Inverse hyperbolic sine transformation
- **Rank**: Simple rank-based transformation

#### `Different_Normalization_Techniques_TOP50.pdf`
Extended analysis showing the top 50 genes to assess whether switching behavior persists with larger gene sets.

#### `Different_Normalization_Techniques_TOP100.pdf`
Comprehensive view of the top 100 genes demonstrating consistency of switching patterns across different selection thresholds.

## Key Findings

### Normalization Performance Summary Table
| Technique | α = 1.0 | α = 0.75 | α = 0.5 | α = 0.25 | α = 0.00 |
|-----------|---------|----------|---------|----------|----------|
| Min-Max   | 16:0    | 10:6     | 13:3    | 0:16     | 0:16     |
| Box-Cox   | 16:0    | 16:0     | 15:1    | 0:16     | 0:16     |
| Yeo-Johnson| 16:0   | 16:0     | 15:1    | 0:16     | 0:16     |
| RIN       | 16:0    | 16:0     | 7:9     | 0:16     | 0:16     |
| Quantile  | 16:0    | 16:0     | 0:16    | 0:16     | 0:16     |
| Asinh     | 16:0    | 16:0     | 14:2    | 0:16     | 0:16     |
| Rank      | 16:0    | 16:0     | 0:16    | 0:16     | 0:16     |

*Format: Risk/Preventive genes : Network genes*

### Main Observations

1. **Consistent Switching Behavior**: All normalization techniques exhibit switching between risk/preventive genes and network genes rather than smooth blending

2. **Best Performance**: Rank-Inverse Normal (RIN) transformation at α = 0.50 showed the most balanced transition (7:9 ratio)

3. **Robust Pattern**: Extended analysis (TOP 50 and TOP 100 genes) confirms switching behavior persists regardless of gene selection threshold

4. **Biological Interpretation**: The switching pattern reflects fundamental differences between:
   - **SRisk**: Long-tailed distribution from statistical significance thresholds
   - **SNetwork**: Compressed range from network centrality measures

## Biological Significance

The observed switching behavior validates our framework's complementary design philosophy:

- **α → 1.0**: Prioritizes genes with strong statistical causal evidence from MR analysis
- **α → 0.0**: Emphasizes critical network regulators from CT analysis  
- **Intermediate α**: Identifies genes bridging both domains

This design preserves the interpretability of each methodology while enabling systematic exploration across the causal-regulatory spectrum.

### Visualization Recreation
The visualization files can be recreated using the fusion scores data with appropriate plotting libraries. Each gene's color coding indicates:
- **Red/Pink**: Risk genes (positive effect)
- **Green**: Preventive genes (negative effect)  
- **Yellow/Orange**: Network driver genes

## Applications

This analysis supports:
- **Method Validation**: Demonstrates robustness of complementary approach across normalizations
- **Parameter Selection**: Guides α choice based on research objectives
- **Framework Extension**: Provides baseline for future normalization developments
- **Biological Interpretation**: Clarifies distinct roles of causal vs. network genes

---

*This analysis demonstrates that our complementary fusion approach effectively captures distinct biological information from causal inference and network control perspectives, providing researchers with flexible tools for Long COVID genetic investigation.*
