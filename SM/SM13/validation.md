# Validation of `Code/control_theory.R`

## 1. Agreement with the reference software

The function was run on two stored edge lists and compared, node by node, with the stored output of ControllabilityAnalysis v1.0.

| Network | Proteins | Interactions | Driver nodes | Nodes with a different K | Nodes with a different Type I | Nodes with a different Type II |
|---|---:|---:|---:|---:|---:|---:|
| Network of the article (Vinayagam) | 6,327 | 34,620 | 2,290 (36.2%) | 0 | 0 | 0 |
| OmniPath | 4,789 | 16,281 | 2,654 (55.4%) | 0 | 0 | 0 |
| 13 networks of SM13 (thresholds 0 to 0.6, two groups) | up to 4,770 | up to 25,211 | | 0 | 0 | 0 |

The function and the software give the same result for every protein.

## 2. Agreement with a published result

Vinayagam et al. (PNAS 2016;113:4976) analysed the same directed human PPI network with 6,339 proteins and 34,813 interactions.

| Quantity | Vinayagam et al. 2016 | Network of the article (6,327 proteins, 34,620 interactions) |
|---|---:|---:|
| Driver nodes | 36% | 36.2% |
| Indispensable (Type I critical) | 21% | 21.1% |
| Dispensable (Type I redundant) | 37% | 36.7% |
| Neutral (Type I ordinary) | 42% | 42.2% |

## 3. Tests

`Rscript Code/test_control_theory.R` checks the function on small networks that can be verified by hand and compares it with an exhaustive search on 300 random networks.
