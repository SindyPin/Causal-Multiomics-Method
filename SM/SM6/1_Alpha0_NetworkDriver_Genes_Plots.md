# Network Driver Genes for Long-COVID

We provide a detailed example of 9 identified network driver genes in the "Network_Driver_Genes_Plots"—**AR**, **CDKN1A**, **CREBBP**, **EP300**, **ESR1**, **RB1**, **SMAD3**, **SRC**, and **TP53**—showing their connections with other genes and emphasizing their significant roles in the network. These genes were identified based on their involvement in essential biological processes and pathways that contribute to the persistence of long-term COVID symptoms.

## Visualization and Representation

In the network plots provided:

- **Shapes** represent different types of genes based on their role in maintaining network control:
  - **Ellipses**: Critical genes whose absence would increase the number of driver nodes required for full network control.
  - **Diamonds**: Ordinary genes whose removal does not affect the current set of driver nodes.
  - **Round rectangles**: Redundant genes whose removal does not affect the current set of driver nodes needed for full network control.
  
- **Colors** indicate the top three most relevant and significantly enriched pathways for each gene, helping to visualize their functional involvement.

- **Shape size** is proportional to the K-degree of the gene, reflecting its centrality and interaction density within the network. Genes with higher K-degree are more central to the network, playing a pivotal role in network connectivity.

## Importance and Literature Support

These genes are involved in critical pathways such as cell proliferation, DNA repair, immune response regulation, and inflammation control. The enriched pathways associated with these genes are supported by existing literature, emphasizing their relevance to Long-COVID pathophysiology and the potential for targeted therapies.

By illustrating the connections and roles of these network driver genes, we aim to provide insights into how their disruptions may contribute to the chronic symptoms of Long-COVID, highlighting potential areas for therapeutic intervention.

## References:

For further reading and understanding of the methodologies used in this analysis, refer to the following publication:
Vinayagam, A., et al., 2016. Controllability analysis of the directed human protein interaction network identifies disease genes and drug targets. Proceedings of the National Academy of Sciences of the United States of America, 113(18), 4976-4981. doi: 10.1073/pnas.1603992113.
