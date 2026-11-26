#==============================================================================
# control_theory.R
#
# Structural controllability of a directed network, with an optional gene
# expression step (correlation filter) in front of it.
#
# This file is an independent implementation written from the published
# definitions. It contains no code from the ControllabilityAnalysis software
# and does not need that software to run.
#
#   Liu YY, Slotine JJ, Barabasi AL. Controllability of complex networks.
#     Nature 473, 167 to 173 (2011).            driver nodes, maximum matching
#   Jia T et al. Emergence of bimodality in controlling complex networks.
#     Nat Commun 4, 2002 (2013).                Type II node classes
#   Vinayagam A et al. Controllability analysis of the directed human protein
#     interaction network identifies disease genes and drug targets.
#     PNAS 113, 4976 to 4981 (2016).            Type I node classes
#
# Requires: R >= 4.0 and the package igraph (maximum matching).
#
# Main function:   run_control_theory()
# Building blocks: ct_correlation(), ct_threshold_table(), ct_choose_threshold(),
#                  ct_filter_edges(), ct_controllability(), ct_score()
#
# WHAT THE OUTPUT MEANS
#   Driver nodes (Nd): the minimum number of nodes that must receive an
#     outside signal so that the whole network can be steered. Nd = N minus
#     the size of a maximum matching (at least 1).
#   Type I (what happens to Nd when the node is removed):
#     0 critical  (indispensable)  Nd increases
#     1 redundant (dispensable)    Nd decreases
#     2 ordinary  (neutral)        Nd does not change
#   Type II (is the node itself a driver node?):
#     0 critical   in every minimum driver set (exactly the nodes with Kin = 0)
#     1 redundant  in no minimum driver set
#     2 ordinary   in some minimum driver sets but not all
#   The codes 0, 1, 2 are the same as in the .nodetype file of
#   ControllabilityAnalysis v1.0, so older scripts keep working.
#==============================================================================

#------------------------------------------------------------------------------
# 1. Correlation per interaction
#------------------------------------------------------------------------------
# expr   numeric matrix, genes in rows, samples (or patients) in columns,
#        rownames = gene names. One column per patient is recommended: if a
#        patient has several samples, summarise them first (for example the
#        median), because repeated samples are not independent.
# edges  data frame or matrix with two columns: source gene, target gene
#        (direction as in the network file).
# method "spearman" (default) or "pearson".
# Returns a data frame: source, target, r. Interactions with a gene that is
# not in expr, or that is constant, are dropped; the attribute "dropped"
# gives the counts.
ct_correlation <- function(expr, edges, method = c("spearman", "pearson")) {
  method <- match.arg(method)
  expr <- as.matrix(expr)
  if (!is.numeric(expr)) stop("expr must be a numeric matrix")
  if (is.null(rownames(expr))) stop("expr needs gene names as rownames")
  if (anyDuplicated(rownames(expr))) stop("expr has duplicated gene names")
  if (ncol(expr) < 4) stop("expr needs at least 4 samples to compute a correlation")
  edges <- .ct_edges(edges)

  i <- match(edges$source, rownames(expr))
  j <- match(edges$target, rownames(expr))
  measured <- !is.na(i) & !is.na(j)

  genes <- sort(unique(c(i[measured], j[measured])))
  x <- expr[genes, , drop = FALSE]
  if (anyNA(x)) stop("expr has missing values in genes of the network; remove or impute them first")
  if (method == "spearman") x <- t(apply(x, 1, rank))       # ranks, ties averaged
  x <- x - rowMeans(x)
  ss <- sqrt(rowSums(x^2))
  constant <- ss == 0
  x <- x / ifelse(constant, 1, ss)                           # unit length rows

  a <- match(i[measured], genes); b <- match(j[measured], genes)
  r <- rowSums(x[a, , drop = FALSE] * x[b, , drop = FALSE])  # correlation of each pair
  r[constant[a] | constant[b]] <- NA
  r <- pmax(pmin(r, 1), -1)

  out <- data.frame(source = edges$source[measured], target = edges$target[measured],
                    r = r, stringsAsFactors = FALSE)
  keep <- !is.na(out$r)
  res <- out[keep, , drop = FALSE]
  rownames(res) <- NULL
  attr(res, "dropped") <- c(interactions_in_file = nrow(edges),
                            gene_not_measured = sum(!measured),
                            gene_constant = sum(!keep),
                            interactions_kept = nrow(res))
  res
}

#------------------------------------------------------------------------------
# 2. Look at the correlations before choosing a threshold
#------------------------------------------------------------------------------
# Table of the distribution of |r| and of what each threshold would keep.
ct_threshold_table <- function(r, thresholds = seq(0, 0.9, by = 0.1)) {
  a <- abs(r[!is.na(r)])
  data.frame(threshold = thresholds,
             interactions_kept = vapply(thresholds, function(t) sum(a >= t), numeric(1)),
             share_kept = round(vapply(thresholds, function(t) mean(a >= t), numeric(1)), 4))
}

# Threshold on |r| that keeps a given share of the interactions.
# keep = 0.5 gives the median of |r|: half of the interactions stay.
ct_choose_threshold <- function(r, keep = 0.5) {
  if (keep <= 0 || keep > 1) stop("keep must be in (0, 1]")
  a <- abs(r[!is.na(r)])
  if (keep == 1) return(0)
  unname(stats::quantile(a, probs = 1 - keep, type = 7))
}

# Histogram of r with the threshold marked.
ct_plot_distribution <- function(r, threshold = NULL, main = "Correlation per interaction") {
  r <- r[!is.na(r)]
  graphics::hist(r, breaks = seq(-1, 1, by = 0.05), col = "grey85", border = "white",
                 xlab = "correlation (r)", ylab = "interactions", main = main)
  if (!is.null(threshold)) graphics::abline(v = c(-threshold, threshold), lty = 2, lwd = 2)
  invisible(NULL)
}

# Keep an interaction if |r| >= threshold. Returns source, target.
ct_filter_edges <- function(correlations, threshold) {
  correlations[abs(correlations$r) >= threshold, c("source", "target"), drop = FALSE]
}

#------------------------------------------------------------------------------
# 3. Structural controllability
#------------------------------------------------------------------------------
# edges   two columns: source, target. Repeated rows are counted once.
# cores   number of cores for the Type I step (uses parallel::mclapply; on
#         Windows keep cores = 1).
# verbose print progress.
#
# Returns a list:
#   summary     one row: nodes, edges, matching size, driver nodes, counts of
#               each Type I and Type II class
#   nodes       one row per node: Name, K, Kin, Kout, TypeI, TypeII, and the
#               classes in words
#   driver_set  one minimum driver node set (it is not unique: Type II says
#               which nodes are in all, some or none of them)
ct_controllability <- function(edges, cores = 1, verbose = FALSE) {
  if (!requireNamespace("igraph", quietly = TRUE)) stop("Please install the package igraph")
  edges <- unique(.ct_edges(edges))
  if (nrow(edges) == 0) stop("the network has no edges")

  nodes <- sort(unique(c(edges$source, edges$target)))
  N <- length(nodes)
  s <- match(edges$source, nodes)       # source index
  t <- match(edges$target, nodes)       # target index
  kin  <- tabulate(t, N)
  kout <- tabulate(s, N)

  # Bipartite picture of the directed network: every node has an "out" copy
  # (1..N) and an "in" copy (N+1..2N); the link s -> t joins out(s) with in(t).
  # A maximum matching of this picture gives the driver nodes (Liu 2011).
  types <- c(rep(FALSE, N), rep(TRUE, N))
  bip <- igraph::make_empty_graph(n = 2 * N, directed = FALSE)
  bip <- igraph::add_edges(bip, as.vector(rbind(s, t + N)))
  mm <- igraph::max_bipartite_match(bip, types = types)
  M <- mm$matching_size
  Nd <- max(N - M, 1L)
  mate <- as.integer(mm$matching)                    # partner vertex or NA
  unmatched_in <- which(is.na(mate[(N + 1):(2 * N)]))

  #--- Type II: is the node a driver node in all, none or some of the sets? ---
  # A node is a driver node when its "in" copy is unmatched.
  # Starting from the unmatched "in" copies and following alternating paths
  # (any link, then a matching link) reaches every "in" copy that is unmatched
  # in at least one maximum matching. The others are matched in all of them.
  in_adj <- split(s, factor(t, levels = seq_len(N)))  # sources that point to each node
  can_be_unmatched <- logical(N)
  can_be_unmatched[unmatched_in] <- TRUE
  frontier <- unmatched_in
  while (length(frontier) > 0) {
    sources <- unique(unlist(in_adj[frontier], use.names = FALSE))
    partner <- mate[sources] - N                      # "in" copy matched to each source
    partner <- unique(partner[!is.na(partner)])
    frontier <- partner[!can_be_unmatched[partner]]
    can_be_unmatched[frontier] <- TRUE
  }
  typeII <- ifelse(kin == 0, 0L, ifelse(can_be_unmatched, 2L, 1L))

  #--- Type I: remove the node, compute Nd again, compare ---------------------
  inc <- split(rep(seq_len(nrow(edges)), 2), factor(c(s, t), levels = seq_len(N)))  # links of each node
  nd_without <- function(v) {
    g <- igraph::delete_edges(bip, unique(inc[[v]]))
    max((N - 1L) - igraph::max_bipartite_match(g, types = types)$matching_size, 1L)
  }
  run <- function(idx) vapply(idx, nd_without, numeric(1))
  if (cores > 1 && .Platform$OS.type != "windows" && N >= 50) {
    chunks <- split(seq_len(N), cut(seq_len(N), breaks = min(N, cores * 4), labels = FALSE))
    nd_removed <- unlist(parallel::mclapply(chunks, run, mc.cores = cores), use.names = FALSE)
    if (length(nd_removed) != N || !is.numeric(nd_removed)) stop("the parallel step failed; try cores = 1")
  } else {
    nd_removed <- numeric(N)
    for (v in seq_len(N)) {
      nd_removed[v] <- nd_without(v)
      if (verbose && v %% 500 == 0) message("Type I: ", v, " of ", N, " nodes")
    }
  }
  typeI <- ifelse(nd_removed > Nd, 0L, ifelse(nd_removed < Nd, 1L, 2L))

  lab <- c("critical", "redundant", "ordinary")
  node_table <- data.frame(Name = nodes, K = kin + kout, Kin = kin, Kout = kout,
                           TypeI = typeI, TypeII = typeII,
                           TypeI_class = lab[typeI + 1L], TypeII_class = lab[typeII + 1L],
                           stringsAsFactors = FALSE)
  summary <- data.frame(nodes = N, edges = nrow(edges), matching_size = M, driver_nodes = Nd,
                        driver_share = round(Nd / N, 4),
                        typeI_critical = sum(typeI == 0), typeI_redundant = sum(typeI == 1),
                        typeI_ordinary = sum(typeI == 2),
                        typeII_critical = sum(typeII == 0), typeII_redundant = sum(typeII == 1),
                        typeII_ordinary = sum(typeII == 2))
  driver_set <- if (length(unmatched_in) > 0) nodes[unmatched_in] else nodes[1]
  list(summary = summary, nodes = node_table, driver_set = driver_set)
}

#------------------------------------------------------------------------------
# 4. Score used in the MRCONTROL paper
#------------------------------------------------------------------------------
# weight 2 if the node is Type I critical (and not Type II critical),
# weight 1 if the node is Type II critical (and not Type I critical),
# weight 0 otherwise.  score = K * weight.
# Note: this score follows the number of connections (K) closely. Report the
# classes and the driver set as well, not only the top of this ranking.
ct_score <- function(nodes) {
  nodes$weight <- ifelse(nodes$TypeI == 0 & nodes$TypeII != 0, 2,
                  ifelse(nodes$TypeII == 0 & nodes$TypeI != 0, 1, 0))
  nodes$score <- nodes$K * nodes$weight
  nodes <- nodes[order(-nodes$score, nodes$Name), ]
  rownames(nodes) <- NULL
  nodes
}

#------------------------------------------------------------------------------
# 5. The whole step in one call
#------------------------------------------------------------------------------
# edges      the directed network (two columns: source, target).
# expr       optional expression matrix (genes x patients). If NULL, the
#            network is analysed as it is (structure only).
# threshold  keep an interaction if |r| >= threshold. Give this OR keep.
# keep       share of the measured interactions to keep (0.5 = the median of
#            |r|). The threshold is then read from the data.
# method     "spearman" or "pearson".
# cores      cores for the Type I step.
#
# Returns a list:
#   settings      what was used (method, threshold, numbers of samples and genes)
#   correlations  source, target, r for every measured interaction (NULL
#                 without expr)
#   distribution  table of |r| against thresholds (NULL without expr)
#   network       the edges that were analysed
#   summary       nodes, edges, driver nodes and class counts
#   nodes         one row per gene with K, Type I, Type II, weight and score
#   driver_set    one minimum driver node set
run_control_theory <- function(edges, expr = NULL, threshold = NULL, keep = NULL,
                               method = c("spearman", "pearson"), cores = 1, verbose = FALSE) {
  method <- match.arg(method)
  edges <- .ct_edges(edges)
  correlations <- NULL; distribution <- NULL
  if (is.null(expr)) {
    if (!is.null(threshold) || !is.null(keep)) stop("threshold and keep need an expression matrix (expr)")
    network <- unique(edges)
    settings <- list(expression_used = FALSE, method = NA, threshold = NA, samples = NA)
  } else {
    if (is.null(threshold) == is.null(keep)) stop("with expr, give exactly one of threshold or keep")
    correlations <- ct_correlation(expr, edges, method = method)
    distribution <- ct_threshold_table(correlations$r)
    if (is.null(threshold)) threshold <- ct_choose_threshold(correlations$r, keep = keep)
    network <- unique(ct_filter_edges(correlations, threshold))
    if (nrow(network) == 0) stop("no interaction passes the threshold ", signif(threshold, 3))
    settings <- list(expression_used = TRUE, method = method, threshold = threshold,
                     samples = ncol(expr), dropped = attr(correlations, "dropped"),
                     share_of_measured_interactions_kept = nrow(ct_filter_edges(correlations, threshold)) / nrow(correlations))
  }
  ct <- ct_controllability(network, cores = cores, verbose = verbose)
  list(settings = settings, correlations = correlations, distribution = distribution,
       network = network, summary = ct$summary, nodes = ct_score(ct$nodes),
       driver_set = ct$driver_set)
}

#------------------------------------------------------------------------------
# internal: read the edge list into two character columns
#------------------------------------------------------------------------------
.ct_edges <- function(edges) {
  edges <- as.data.frame(edges, stringsAsFactors = FALSE)
  if (ncol(edges) < 2) stop("edges needs two columns: source and target")
  out <- data.frame(source = as.character(edges[[1]]), target = as.character(edges[[2]]),
                    stringsAsFactors = FALSE)
  bad <- is.na(out$source) | is.na(out$target) | out$source == "" | out$target == ""
  out[!bad, , drop = FALSE]
}
