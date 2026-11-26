#==============================================================================
# test_control_theory.R
# Checks for control_theory.R that can be verified by hand or by brute force.
# Run:  Rscript Code/test_control_theory.R      (prints "ALL TESTS PASSED")
#==============================================================================
f <- c("control_theory.R", "Code/control_theory.R")   # run from Code/ or from the top folder
source(f[file.exists(f)][1])
set.seed(20261120)
E <- function(...) { x <- c(...); data.frame(source = x[c(TRUE, FALSE)], target = x[c(FALSE, TRUE)]) }
cls <- function(ct, col) setNames(ct$nodes[[col]], ct$nodes$Name)

# 1. Chain a -> b -> c. One driver node (a) steers everything.
ct <- ct_controllability(E("a","b", "b","c"))
stopifnot(ct$summary$driver_nodes == 1, identical(ct$driver_set, "a"))
stopifnot(all(cls(ct, "TypeII")[c("a","b","c")] == c(0, 1, 1)))   # a always a driver; b, c never
stopifnot(all(cls(ct, "TypeI")[c("a","b","c")] == c(2, 0, 2)))    # removing b breaks the chain: Nd goes up

# 2. Star a -> b, a -> c, a -> d. A hub can steer only one neighbour directly: Nd = 3.
ct <- ct_controllability(E("a","b", "a","c", "a","d"))
stopifnot(ct$summary$driver_nodes == 3, ct$summary$matching_size == 1)
stopifnot(all(cls(ct, "TypeII")[c("a","b","c","d")] == c(0, 2, 2, 2)))
stopifnot(all(cls(ct, "TypeI")[c("a","b","c","d")] == c(2, 1, 1, 1)))

# 3. Cycle a -> b -> c -> a. Perfect matching, so Nd = 1 by convention.
ct <- ct_controllability(E("a","b", "b","c", "c","a"))
stopifnot(ct$summary$driver_nodes == 1, ct$summary$matching_size == 3)

# 4. Repeated rows are counted once; degrees are right.
ct <- ct_controllability(E("a","b", "a","b", "b","a", "b","c"))
stopifnot(ct$summary$edges == 3, all(cls(ct, "K")[c("a","b","c")] == c(2, 3, 1)))

# 5. Brute force on small random networks: list every maximum matching and
#    every node removal, and compare with the function.
all_max_matchings <- function(s, t) {           # returns list(size, list of matched-target sets)
  best <- 0; sets <- list()
  rec <- function(k, used_s, used_t) {
    if (k > length(s)) {
      m <- length(used_t)
      if (m > best) { best <<- m; sets <<- list(sort(used_t)) } else if (m == best) sets[[length(sets) + 1]] <<- sort(used_t)
      return(invisible())
    }
    rec(k + 1, used_s, used_t)
    if (!(s[k] %in% used_s) && !(t[k] %in% used_t)) rec(k + 1, c(used_s, s[k]), c(used_t, t[k]))
  }
  rec(1, integer(0), integer(0))
  list(size = best, sets = unique(sets))
}
for (rep in 1:300) {
  n <- sample(3:7, 1); m <- sample(2:min(11, n * (n - 1)), 1)
  pairs <- expand.grid(s = 1:n, t = 1:n); pairs <- pairs[sample(nrow(pairs), m), ]   # self loops allowed
  ed <- data.frame(source = paste0("g", pairs$s), target = paste0("g", pairs$t))
  ct <- ct_controllability(ed)
  nodes <- ct$nodes$Name; N <- length(nodes)
  s <- match(ed$source, nodes); t <- match(ed$target, nodes)
  mm <- all_max_matchings(s, t)
  nd <- max(N - mm$size, 1)
  stopifnot(ct$summary$driver_nodes == nd)
  # Type II by listing all maximum matchings
  always_matched  <- vapply(1:N, function(v) all(vapply(mm$sets, function(x) v %in% x, logical(1))), logical(1))
  never_matched   <- vapply(1:N, function(v) !any(vapply(mm$sets, function(x) v %in% x, logical(1))), logical(1))
  expectII <- ifelse(never_matched, 0L, ifelse(always_matched, 1L, 2L))
  stopifnot(all(ct$nodes$TypeII == expectII))
  stopifnot(all((ct$nodes$TypeII == 0) == (ct$nodes$Kin == 0)))
  # Type I by removing each node
  expectI <- vapply(1:N, function(v) {
    keep <- s != v & t != v
    size <- if (any(keep)) all_max_matchings(s[keep], t[keep])$size else 0
    nd2 <- max((N - 1) - size, 1)
    if (nd2 > nd) 0L else if (nd2 < nd) 1L else 2L
  }, integer(1))
  stopifnot(all(ct$nodes$TypeI == expectI))
}

# 6. Correlation step equals stats::cor, with ties, for both methods.
expr <- matrix(round(rnorm(40 * 12), 1), nrow = 40, dimnames = list(paste0("g", 1:40), paste0("p", 1:12)))
expr["g7", ] <- 5                                         # a constant gene
ed <- data.frame(source = paste0("g", sample(40, 60, TRUE)), target = paste0("g", sample(45, 60, TRUE)))
for (method in c("spearman", "pearson")) {
  cc <- ct_correlation(expr, ed, method = method)
  ref <- mapply(function(a, b) cor(expr[a, ], expr[b, ], method = method), cc$source, cc$target)
  stopifnot(max(abs(cc$r - ref)) < 1e-12)
  stopifnot(!any(cc$source == "g7" | cc$target == "g7"), all(cc$target %in% rownames(expr)))
}

# 7. Threshold from the distribution and the whole step in one call.
cc <- ct_correlation(expr, ed)
th <- ct_choose_threshold(cc$r, keep = 0.5)
stopifnot(abs(mean(abs(cc$r) >= th) - 0.5) <= 1 / nrow(cc) + 1e-9)
res <- run_control_theory(ed, expr = expr, keep = 0.5)
stopifnot(res$settings$threshold == th, nrow(res$network) == nrow(unique(ct_filter_edges(cc, th))))
stopifnot(all(c("Name", "K", "TypeI", "TypeII", "weight", "score") %in% names(res$nodes)))
res0 <- run_control_theory(ed)                             # structure only
stopifnot(!res0$settings$expression_used, res0$summary$edges == nrow(unique(ed)))
same <- ct_controllability(ed, cores = 2)                  # parallel gives the same answer
stopifnot(identical(same$nodes, ct_controllability(ed)$nodes))

cat("ALL TESTS PASSED\n")
