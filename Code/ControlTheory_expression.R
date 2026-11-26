#==============================================================================
# ControlTheory_expression.R
#
# Control theory step with gene expression, at several correlation thresholds.
# Produces every table and figure of SM/SM13.
#
# Run from the top folder of the repository:
#
#   Rscript Code/ControlTheory_expression.R
#
#   This reads SM/SM13/data/ppi_correlations.tsv (one correlation per PPI
#   interaction and group; no participant data) and writes SM/SM13/tables and
#   SM/SM13/figures.
#
# To start from your own expression data, give the files as arguments:
#
#   Rscript Code/ControlTheory_expression.R ppi=<edge list> \
#       expr_LC=<genes x patients matrix> expr_recovered=<genes x patients matrix>
#
#   ppi             tab separated, two columns with a header: source, target
#   expr_LC,        tab separated, first column = gene symbol, one column per
#   expr_recovered  patient (one value per patient and gene, for example the
#                   median over the samples of that patient)
#   These files stay on your computer. Only the correlation per interaction is
#   written to SM/SM13/data.
#
# Requires: R, igraph. Uses Code/control_theory.R (no other software).
#==============================================================================

args <- commandArgs(trailingOnly = TRUE)
arg <- function(name, default = NULL) {
  hit <- grep(paste0("^", name, "="), args, value = TRUE)
  if (length(hit)) sub(paste0("^", name, "="), "", hit[1]) else default
}
source("Code/control_theory.R")

OUT        <- arg("out", "SM/SM13")
COR_FILE   <- file.path(OUT, "data", "ppi_correlations.tsv")
THRESHOLDS <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6)
TOP_N      <- 16
CORES      <- as.integer(arg("cores", "2"))
PUBLISHED  <- c("TP53", "CREBBP", "EP300", "YWHAG", "SMAD3", "GRB2", "SRC", "AR",
                "ESR1", "RB1", "CSNK2A1", "SMAD2", "CDKN1A", "MAPK1", "FYN", "HDAC1")
BLUE <- "#1F5A94"; ORANGE <- "#C8641B"; GREY <- "#8A8A8A"; INK <- "#1A1A1A"
dir.create(file.path(OUT, "tables"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(OUT, "figures"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(OUT, "data"), recursive = TRUE, showWarnings = FALSE)

#------------------------------------------------------------------------------
# 1. Correlation per interaction
#------------------------------------------------------------------------------
if (!is.null(arg("ppi"))) {
  read_expr <- function(f) { x <- read.delim(f, check.names = FALSE); m <- as.matrix(x[, -1]); rownames(m) <- x[[1]]; m }
  ppi <- read.delim(arg("ppi"), stringsAsFactors = FALSE)[, 1:2]
  c_lc  <- ct_correlation(read_expr(arg("expr_LC")), ppi)
  c_rec <- ct_correlation(read_expr(arg("expr_recovered")), ppi)
  key <- function(x) paste(x$source, x$target, sep = "\t")
  both <- intersect(key(c_lc), key(c_rec))
  correlations <- data.frame(c_lc[match(both, key(c_lc)), c("source", "target")],
                             r_LC = c_lc$r[match(both, key(c_lc))],
                             r_recovered = c_rec$r[match(both, key(c_rec))])
  write.table(correlations, COR_FILE, sep = "\t", quote = FALSE, row.names = FALSE)
}
correlations <- read.delim(COR_FILE, stringsAsFactors = FALSE)
cat("interactions with a correlation:", nrow(correlations), "\n")

#------------------------------------------------------------------------------
# 2. Control theory at every threshold, for both groups
#------------------------------------------------------------------------------
groups <- c(LC = "r_LC", recovered = "r_recovered")
runs <- list(); summary_rows <- list()
for (g in names(groups)) for (t in THRESHOLDS) {
  cc <- data.frame(correlations[, c("source", "target")], r = correlations[[groups[g]]])
  ct <- ct_controllability(ct_filter_edges(cc, t), cores = CORES)
  nodes <- ct_score(ct$nodes)
  nodes$rank <- seq_len(nrow(nodes))
  runs[[paste(g, t)]] <- nodes
  top <- head(nodes$Name, TOP_N)
  summary_rows[[length(summary_rows) + 1]] <- data.frame(
    group = g, threshold = t, ct$summary,
    share_interactions_kept = round(ct$summary$edges / nrow(correlations), 4),
    top_also_highest_degree = sum(top %in% head(nodes$Name[order(-nodes$K, nodes$Name)], TOP_N)),
    published_in_top = sum(top %in% PUBLISHED))
  cat(sprintf("%-9s t = %.1f  nodes %5d  edges %6d  Nd %5d\n", g, t, ct$summary$nodes, ct$summary$edges, ct$summary$driver_nodes))
}
summary_tab <- do.call(rbind, summary_rows)
write.table(summary_tab, file.path(OUT, "tables", "threshold_summary.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)

all_nodes <- do.call(rbind, lapply(names(runs), function(k) {
  p <- strsplit(k, " ")[[1]]; data.frame(group = p[1], threshold = as.numeric(p[2]), runs[[k]])
}))
write.table(all_nodes[all_nodes$group == "LC", ], file.path(OUT, "tables", "all_genes_by_threshold_LongCOVID.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)

#------------------------------------------------------------------------------
# 3. Core genes and genes that change with the threshold (Long COVID group)
#------------------------------------------------------------------------------
top_lc <- lapply(THRESHOLDS, function(t) head(runs[[paste("LC", t)]]$Name, TOP_N))
names(top_lc) <- THRESHOLDS
genes <- unique(unlist(top_lc))
in_top <- sapply(top_lc, function(x) genes %in% x); rownames(in_top) <- genes
rank_mat <- sapply(THRESHOLDS, function(t) match(genes, runs[[paste("LC", t)]]$Name))
k_mat <- sapply(THRESHOLDS, function(t) { n <- runs[[paste("LC", t)]]; n$K[match(genes, n$Name)] })
dimnames(rank_mat) <- dimnames(k_mat) <- dimnames(in_top)
category <- ifelse(rowSums(in_top) == length(THRESHOLDS), "core",
            ifelse(genes %in% PUBLISHED, "published", "new"))
first_in <- apply(in_top, 1, function(x) THRESHOLDS[which(x)[1]])
ord <- order(match(category, c("core", "published", "new")), -rowSums(in_top), first_in, rank_mat[, 1])
genes <- genes[ord]; in_top <- in_top[ord, ]; rank_mat <- rank_mat[ord, ]; k_mat <- k_mat[ord, ]; category <- category[ord]

roles <- read.delim(file.path(OUT, "data", "gene_roles.tsv"), stringsAsFactors = FALSE)
presence <- data.frame(gene = genes, category = category, thresholds_in_top = rowSums(in_top),
                       in_top_at = apply(in_top, 1, function(x) paste(THRESHOLDS[x], collapse = ", ")),
                       setNames(as.data.frame(rank_mat), paste0("rank_t", THRESHOLDS)),
                       setNames(as.data.frame(k_mat), paste0("K_t", THRESHOLDS)),
                       known_role = roles$known_role[match(genes, roles$gene)], check.names = FALSE)
write.table(presence, file.path(OUT, "tables", "top16_genes_across_thresholds.tsv"), sep = "\t", quote = FALSE, row.names = FALSE, na = "")
top_table <- as.data.frame(top_lc, check.names = FALSE)
write.table(data.frame(rank = 1:TOP_N, top_table, check.names = FALSE), file.path(OUT, "tables", "top16_by_threshold_LongCOVID.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)
top_rec <- lapply(THRESHOLDS, function(t) head(runs[[paste("recovered", t)]]$Name, TOP_N)); names(top_rec) <- THRESHOLDS
write.table(data.frame(rank = 1:TOP_N, as.data.frame(top_rec, check.names = FALSE), check.names = FALSE),
            file.path(OUT, "tables", "top16_by_threshold_recovered.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)
overlap <- data.frame(threshold = THRESHOLDS,
                      shared_top16_LC_recovered = sapply(seq_along(THRESHOLDS), function(i) length(intersect(top_lc[[i]], top_rec[[i]]))))
write.table(overlap, file.path(OUT, "tables", "top16_overlap_LC_recovered.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)
cat("core genes:", paste(genes[category == "core"], collapse = ", "), "\n")

#------------------------------------------------------------------------------
# 4. LaTeX tables
#------------------------------------------------------------------------------
fmt <- function(x) format(x, big.mark = ",", trim = TRUE)
pct <- function(x) sprintf("%.0f\\%%", 100 * x)
tex <- function(lines, file) writeLines(lines, file.path(OUT, "tables", file))

s <- summary_tab[summary_tab$group == "LC", ]
tex(c("\\begin{tabular}{rrrrrrrrr}", "\\toprule",
      "Threshold & \\multicolumn{2}{c}{Interactions kept} & Proteins & \\multicolumn{2}{c}{Driver nodes} & \\multicolumn{3}{c}{Type I class} \\\\",
      "\\cmidrule(lr){2-3}\\cmidrule(lr){5-6}\\cmidrule(lr){7-9}",
      "on $|r|$ & number & share & & number & share & critical & redundant & ordinary \\\\", "\\midrule",
      sprintf("%.1f & %s & %s & %s & %s & %s & %s & %s & %s \\\\", s$threshold, fmt(s$edges), pct(s$share_interactions_kept),
              fmt(s$nodes), fmt(s$driver_nodes), pct(s$driver_share), fmt(s$typeI_critical), fmt(s$typeI_redundant), fmt(s$typeI_ordinary)),
      "\\bottomrule", "\\end{tabular}"), "table_thresholds.tex")

mark <- function(g) { cat_g <- category[match(g, genes)]
  ifelse(cat_g == "core", paste0("\\textbf{", g, "}"), ifelse(cat_g == "new", paste0("\\textit{", g, "}$^{\\ast}$"), g)) }
tex(c("\\begin{tabular}{r*{7}{l}}", "\\toprule",
      paste0("Rank & ", paste(sprintf("%.1f", THRESHOLDS), collapse = " & "), " \\\\"), "\\midrule",
      sapply(1:TOP_N, function(i) paste0(i, " & ", paste(sapply(top_lc, function(x) mark(x[i])), collapse = " & "), " \\\\")),
      "\\midrule",
      paste0("Published & ", paste(sapply(top_lc, function(x) sum(x %in% PUBLISHED)), collapse = " & "), " \\\\"),
      paste0("Most connected & ", paste(s$top_also_highest_degree, collapse = " & "), " \\\\"),
      "\\bottomrule", "\\end{tabular}"), "table_top16.tex")

new <- presence[presence$category == "new", ]
tex(c("\\begin{tabular}{llrrp{7.4cm}}", "\\toprule",
      "Gene & In the top 16 at & \\multicolumn{2}{c}{Connections ($K$)} & Known role \\\\", "\\cmidrule(lr){3-4}",
      " & thresholds & all & at 0.5 & \\\\", "\\midrule",
      sprintf("%s & %s & %s & %s & %s \\\\", new$gene, new$in_top_at, new[["K_t0"]], ifelse(is.na(new[["K_t0.5"]]), "0", new[["K_t0.5"]]),
              ifelse(is.na(new$known_role), "", new$known_role)),
      "\\bottomrule", "\\end{tabular}"), "table_new_genes.tex")

rp <- read.delim(file.path(OUT, "data", "control_random_pairs.tsv"))
sm <- read.delim(file.path(OUT, "data", "control_size_matched_mean.tsv"))
sr <- summary_tab[summary_tab$group == "recovered", ]
tex(c("\\begin{tabular}{rrrrrrr}", "\\toprule",
      "Threshold & \\multicolumn{2}{c}{Pairs that pass (Long COVID)} & \\multicolumn{3}{c}{Interactions in the network} & Shared genes \\\\",
      "\\cmidrule(lr){2-3}\\cmidrule(lr){4-6}",
      " & PPI & random & Long COVID & Long COVID & recovered & in the top 16 \\\\",
      " & interactions & gene pairs & (155) & (27 drawn) & (27) & \\\\", "\\midrule",
      sprintf("%.1f & %.1f\\%% & %.1f\\%% & %s & %s & %s & %d \\\\", rp$threshold, rp$LC_ppi, rp$LC_random,
              fmt(s$edges[match(rp$threshold, s$threshold)]), fmt(round(sm$edges[match(rp$threshold, sm$threshold)])),
              fmt(sr$edges[match(rp$threshold, sr$threshold)]), overlap$shared_top16_LC_recovered[match(rp$threshold, overlap$threshold)]),
      "\\bottomrule", "\\end{tabular}"), "table_controls.tex")

sh <- read.delim(file.path(OUT, "data", "control_shuffled_labels.tsv"), check.names = FALSE)
tex(c("\\begin{tabular}{p{7.2cm}lrr}", "\\toprule",
      "Quantity & Threshold & Real groups & Shuffled groups \\\\", "\\midrule",
      sprintf("%s & %s & %s & %s (%s to %s) \\\\", gsub("p <=", "$p \\\\leq$", sh$test), sh$threshold, fmt(sh$observed),
              fmt(round(sh$shuffled_mean)), fmt(sh[["shuffled_p2.5"]]), fmt(sh[["shuffled_p97.5"]])),
      "\\bottomrule", "\\end{tabular}"), "table_shuffled.tex")

#------------------------------------------------------------------------------
# 5. Figures
#------------------------------------------------------------------------------
fig <- function(name, w, h, expr) {
  for (dev in c("pdf", "png")) {
    f <- file.path(OUT, "figures", paste0(name, ".", dev))
    if (dev == "pdf") grDevices::pdf(f, width = w, height = h) else grDevices::png(f, width = w, height = h, units = "in", res = 200)
    par(family = "sans", col.axis = "#444444", col.lab = INK, fg = "#666666", las = 1, mgp = c(2.4, 0.6, 0), tcl = -0.25, cex.axis = 0.9)
    expr(); grDevices::dev.off()
  }
}

# Figure 1: distribution of the correlation per interaction (Long COVID)
med <- ct_choose_threshold(correlations$r_LC, keep = 0.5)
fig("fig1_correlation_distribution", 7, 3.6, function() {
  par(mar = c(4, 4.6, 1.2, 1))
  h <- hist(correlations$r_LC, breaks = seq(-1, 1, by = 0.05), plot = FALSE)
  plot(NA, xlim = c(-1, 1), ylim = c(0, max(h$counts) * 1.12), xlab = "Spearman correlation between the two genes of an interaction",
       ylab = "", bty = "n", yaxt = "n")
  axis(2, at = pretty(h$counts), labels = format(pretty(h$counts), big.mark = ","), lwd = 0, lwd.ticks = 1)
  mtext("Interactions", side = 2, line = 3.4, las = 0, col = INK)
  abline(h = pretty(h$counts), col = "#EBEBEB", lwd = 0.8)
  rect(h$breaks[-length(h$breaks)] + 0.004, 0, h$breaks[-1] - 0.004, h$counts, col = BLUE, border = NA)
  abline(v = c(-med, med), lty = 2, col = INK, lwd = 1.2)
  text(med + 0.03, max(h$counts) * 1.08, sprintf("median of |r| = %.2f", med), adj = 0, col = INK, cex = 0.9)
})

# Figure 2: what each threshold keeps (Long COVID)
fig("fig2_network_by_threshold", 7, 3.6, function() {
  par(mar = c(4, 4.2, 1.2, 9))
  e <- 100 * s$edges / s$edges[1]; n <- 100 * s$nodes / s$nodes[1]
  plot(NA, xlim = c(0, 0.6), ylim = c(0, 100), xlab = "Threshold on |r|", ylab = "Share of the full network kept (%)", bty = "n", xaxt = "n")
  axis(1, at = THRESHOLDS); abline(h = seq(0, 100, 20), col = "#EBEBEB", lwd = 0.8)
  lines(s$threshold, n, col = ORANGE, lwd = 2); points(s$threshold, n, pch = 16, col = ORANGE, cex = 0.9)
  lines(s$threshold, e, col = BLUE, lwd = 2);   points(s$threshold, e, pch = 16, col = BLUE, cex = 0.9)
  par(xpd = NA)
  text(0.615, n[7], sprintf("Proteins (%s)", fmt(s$nodes[7])), adj = 0, col = INK, cex = 0.9)
  text(0.615, e[7], sprintf("Interactions (%s)", fmt(s$edges[7])), adj = 0, col = INK, cex = 0.9)
})

# Figure 3: the top 16 at every threshold (Long COVID)
fig("fig3_top16_across_thresholds", 7, 8.6, function() {
  par(mar = c(1, 6.2, 4.2, 12.5))
  ng <- length(genes); nt <- length(THRESHOLDS)
  gap <- cumsum(c(0, diff(match(category, c("core", "published", "new"))) != 0)) * 0.7
  y <- -(seq_len(ng) + gap)
  plot(NA, xlim = c(0.5, nt + 0.5), ylim = c(min(y) - 0.6, 0.2), axes = FALSE, xlab = "", ylab = "")
  fill <- c(core = BLUE, published = GREY, new = ORANGE)
  for (i in seq_len(ng)) for (j in seq_len(nt)) {
    if (in_top[i, j]) {
      rect(j - 0.46, y[i] - 0.42, j + 0.46, y[i] + 0.42, col = fill[category[i]], border = NA)
      text(j, y[i], rank_mat[i, j], col = "white", cex = 0.72, font = 2)
    } else {
      rect(j - 0.46, y[i] - 0.42, j + 0.46, y[i] + 0.42, col = "#F3F3F3", border = NA)
      if (is.na(rank_mat[i, j])) text(j, y[i], "absent", col = "#9A9A9A", cex = 0.55) else text(j, y[i], rank_mat[i, j], col = "#8A8A8A", cex = 0.62)
    }
  }
  par(xpd = NA)
  text(0.42, y, genes, adj = 1, col = INK, cex = 0.82, font = ifelse(category == "core", 2, 1))
  text(seq_len(nt), 0.75, sprintf("%.1f", THRESHOLDS), col = INK, cex = 0.9)
  text((nt + 1) / 2, 2.0, "Threshold on |r|", col = INK, cex = 0.95)
  lab <- c(core = "Core: in the top 16\nat every threshold", published = "Published genes that\nleave the top 16",
           new = "Genes that enter the top 16\nwhen the threshold rises")
  for (k in names(lab)) { yy <- y[category == k]
    segments(nt + 0.75, max(yy) + 0.42, nt + 0.75, min(yy) - 0.42, col = fill[k], lwd = 3, lend = 1)
    text(nt + 0.95, mean(range(yy)), lab[k], adj = 0, col = INK, cex = 0.85) }
})

# Figure 4: controls
fig("fig4_controls", 7.4, 3.5, function() {
  par(mfrow = c(1, 2), mar = c(4, 4.2, 2.4, 1))
  plot(NA, xlim = c(0.1, 0.6), ylim = c(0, 80), xlab = "Threshold on |r|", ylab = "Pairs that pass (%)", bty = "n")
  abline(h = seq(0, 80, 20), col = "#EBEBEB", lwd = 0.8)
  lines(rp$threshold, rp$LC_random, col = GREY, lwd = 2, lty = 2); points(rp$threshold, rp$LC_random, pch = 1, col = GREY, cex = 0.9)
  lines(rp$threshold, rp$LC_ppi, col = BLUE, lwd = 2); points(rp$threshold, rp$LC_ppi, pch = 16, col = BLUE, cex = 0.9)
  text(0.33, 47, "PPI interactions", adj = 0, col = INK, cex = 0.85); text(0.11, 10, "Random gene pairs", adj = 0, col = INK, cex = 0.85)
  segments(0.32, 46, 0.285, 41, col = "#999999"); segments(0.33, 12, 0.375, 21, col = "#999999")
  mtext("a  Interacting pairs and random pairs", side = 3, adj = 0, line = 1, cex = 0.85, col = INK, font = 2)
  par(mar = c(4, 4.6, 2.4, 1))
  plot(NA, xlim = c(0.1, 0.6), ylim = c(0, 21000), xlab = "Threshold on |r|", ylab = "", bty = "n", yaxt = "n")
  axis(2, at = seq(0, 20000, 5000), labels = format(seq(0, 20000, 5000), big.mark = ","), lwd = 0, lwd.ticks = 1)
  mtext("Interactions in the network", side = 2, line = 3.5, las = 0, col = INK)
  abline(h = seq(0, 20000, 5000), col = "#EBEBEB", lwd = 0.8)
  x <- rp$threshold
  lines(x, s$edges[match(x, s$threshold)], col = BLUE, lwd = 2); points(x, s$edges[match(x, s$threshold)], pch = 16, col = BLUE, cex = 0.9)
  lines(x, sm$edges[match(x, sm$threshold)], col = GREY, lwd = 2, lty = 2); points(x, sm$edges[match(x, sm$threshold)], pch = 1, col = GREY, cex = 0.9)
  lines(x, sr$edges[match(x, sr$threshold)], col = ORANGE, lwd = 2); points(x, sr$edges[match(x, sr$threshold)], pch = 17, col = ORANGE, cex = 0.9)
  legend("topright", legend = c("Recovered (27)", "Long COVID, 27 drawn", "Long COVID (155)"), col = c(ORANGE, GREY, BLUE),
         lty = c(1, 2, 1), pch = c(17, 1, 16), lwd = 2, bty = "n", cex = 0.8, text.col = INK)
  mtext("b  Network size and group size", side = 3, adj = 0, line = 1, cex = 0.85, col = INK, font = 2)
})
cat("Done. Tables and figures are in", OUT, "\n")
