# ════════════════════════════════════════════════════════════════════════════
# INDIVIDUAL-LEVEL MATCHING WITH COMPREHENSIVE SMD TABLES
# 4_Matching_Individual_level.R
# ════════════════════════════════════════════════════════════════════════════

library(MatchIt)
library(haven)

MAKE_PLOTS <- FALSE   # set TRUE to draw jitter / love plots (27 plots per run)

# ============================================================
# Matching specification
# ============================================================

formula <- treatment ~ caste + religion_class + age_fmarriage + v013 + v212 + education_level
vars    <- all.vars(formula)          # treatment + all covariates

cem_cutpoints <- list(caste = 4, religion_class = 4, age_fmarriage = 4,
                      v013  = 4, v212 = 4, education_level = 4)

PERIODS <- c("pre", "post_short", "post_long")

# ============================================================
# Paths
# ============================================================

proc  <- "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/1_wave/"
final <- "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/4_final"

# ============================================================
# Helpers
# ============================================================

# Stata codes the period flags as 1 / 0 / . where "." means "belongs to a
# different window", not "unknown". haven maps "." to NA, and R's `[` turns an
# NA index into a fabricated all-NA row -- which is what broke matchit().
# `%in% 1` is NA-safe, so this collapses the three partial indicators into one
# clean factor with no missing values.
add_period <- function(df) {
  df$period <- ifelse(df$post_long  %in% 1, "post_long",
                      ifelse(df$post_short %in% 1, "post_short", "pre"))
  df$period <- factor(df$period, levels = PERIODS)
  df
}

prep <- function(df) {
  df <- add_period(df)
  df <- df[, !names(df) %in% c("pscore", "weights", "subclass")]
  df[complete.cases(df[, vars]), ]
}

# Verify the flags partition the sample as expected.
check_periods <- function(df, label = "") {
  cat("\n-- period breakdown", label, "--\n")
  print(table(df$period, useNA = "ifany"))
  raw <- table(short = df$post_short, long = df$post_long, useNA = "ifany")
  if (sum(raw > 0) != 3L) {
    warning("Expected exactly 3 populated (post_short, post_long) cells; ",
            "flags may overlap. Inspect:\n",
            paste(capture.output(print(raw)), collapse = "\n"))
  }
  invisible(df)
}

# ============================================================
# Matching functions -- each returns the matchit OBJECT
# ============================================================

match_nn <- function(df) {
  suppressWarnings(
    matchit(formula, data = df,
            method = "nearest", distance = "glm", link = "logit",
            ratio = 1, replace = FALSE)
  )
}

match_mah <- function(df) {
  matchit(formula, data = df, distance = "mahalanobis", ratio = 1)
}

match_cem <- function(df) {
  matchit(formula, data = df, method = "cem", cutpoints = cem_cutpoints)
}

# CEM produces unequal treated/control counts. The original script downsampled
# both arms to a common n; kept here for continuity. See note at bottom of file.
balance_cem <- function(md, seed = 123) {
  treated <- md[md$treatment == 1, ]
  control <- md[md$treatment == 0, ]
  set.seed(seed)
  n_sample <- min(nrow(treated), nrow(control))
  treated  <- treated[sample(nrow(treated), n_sample), ]
  control  <- control[sample(nrow(control), n_sample), ]
  combined <- rbind(treated, control)
  print(table(combined$treatment))
  combined
}

# ============================================================
# Diagnostics helper
# ============================================================

extract_smd_individual <- function(match_obj) {
  summary_obj <- summary(match_obj)
  
  all_vars <- rownames(summary_obj$sum.all)
  covars   <- all_vars[all_vars != "distance"]   # drop propensity score
  
  data.frame(
    Covariate  = covars,
    SMD_Before = summary_obj$sum.all[covars, "Std. Mean Diff."],
    SMD_After  = summary_obj$sum.matched[covars, "Std. Mean Diff."],
    stringsAsFactors = FALSE,
    row.names = NULL
  )
}

# `%||%` is only in base R >= 4.4, so use an explicit helper instead.
n_rows <- function(x) if (is.null(x)) 0L else nrow(x)

draw_plots <- function(m, method) {
  if (!MAKE_PLOTS) return(invisible(NULL))
  if (method == "NN") plot(m, type = "jitter", interactive = FALSE)
  plot(summary(m), abs = FALSE)
}

# ============================================================
# Run all waves x methods
# ============================================================

runs <- list(
  list(wave = "Wave1996", suffix = "NN",          fn = match_nn),
  list(wave = "Wave1996", suffix = "Mahalanobis", fn = match_mah),
  list(wave = "Wave1996", suffix = "CEM",         fn = match_cem),
  list(wave = "Wave2004", suffix = "NN",          fn = match_nn),
  list(wave = "Wave2004", suffix = "Mahalanobis", fn = match_mah),
  list(wave = "Wave2004", suffix = "CEM",         fn = match_cem),
  list(wave = "Wave2007", suffix = "NN",          fn = match_nn),
  list(wave = "Wave2007", suffix = "Mahalanobis", fn = match_mah),
  list(wave = "Wave2007", suffix = "CEM",         fn = match_cem)
)

# Column labels used in the merged SMD table
period_labels <- c(pre = "Pre", post_short = "PostShort", post_long = "PostLong")

smd_diagnostics <- list()
sample_sizes    <- list()

for (r in runs) {
  cat("\n===", r$wave, "-", r$suffix, "===\n")
  
  df <- prep(read_dta(file.path(proc, paste0(r$wave, "_", r$suffix, ".dta"))))
  check_periods(df, paste(r$wave, r$suffix))
  
  matched   <- list()
  smd_parts <- list()
  
  for (p in PERIODS) {
    sub <- subset(df, period == p)          # NA-safe: drops nothing spurious
    if (nrow(sub) == 0L) {
      warning("No rows for period '", p, "' in ", r$wave, " ", r$suffix)
      next
    }
    
    m <- r$fn(sub)                          # matched ONCE
    print(summary(m))
    draw_plots(m, r$suffix)
    
    # NOTE: match.data()'s `distance` argument NAMES the output column, it does
    # not select one -- and Mahalanobis matching has no propensity score at all.
    md <- match.data(m, data = sub)
    if (r$suffix == "NN" && "distance" %in% names(md)) {
      names(md)[names(md) == "distance"] <- "pscore"   # original column name
    }
    if (r$suffix == "CEM") md <- balance_cem(md)
    
    md$period    <- p
    matched[[p]] <- md
    
    # SMD columns named <Method>_<Period>_Before / _After
    smd <- extract_smd_individual(m)
    names(smd) <- c("Covariate",
                    paste0(r$suffix, "_", period_labels[[p]], "_Before"),
                    paste0(r$suffix, "_", period_labels[[p]], "_After"))
    smd_parts[[p]] <- smd
  }
  
  # ── Merge SMD across periods, then accumulate across methods ──
  smd_merged <- Reduce(function(a, b) merge(a, b, by = "Covariate", all = TRUE),
                       smd_parts)
  
  key <- paste0(r$wave, "_SMD")
  smd_diagnostics[[key]] <- if (is.null(smd_diagnostics[[key]])) {
    smd_merged
  } else {
    merge(smd_diagnostics[[key]], smd_merged, by = "Covariate", all = TRUE)
  }
  
  # ── Sample sizes ──
  sample_sizes[[paste0(r$wave, "_", r$suffix)]] <- data.frame(
    Wave      = r$wave,
    Method    = r$suffix,
    Pre       = n_rows(matched[["pre"]]),
    PostShort = n_rows(matched[["post_short"]]),
    PostLong  = n_rows(matched[["post_long"]])
  )
  
  # ── Write final data ──
  # subclass is numbered 1..N *within each fit*, so prefix it with the period;
  # otherwise subclass 1 refers to three unrelated pairs in the same file.
  # match.data() returns class `matchdata`, and MatchIt's rbind method receives
  # `deparse.level` as its first argument via S3 dispatch, then rejects it as a
  # non-matchdata input. Demote to plain data.frame so rbind.data.frame runs.
  # No data is lost -- weights / subclass / pscore are ordinary columns.
  combined <- do.call(rbind, lapply(matched, function(x) {
    class(x) <- "data.frame"
    x
  }))
  rownames(combined) <- NULL
  if ("subclass" %in% names(combined)) {
    combined$subclass <- paste(combined$period, combined$subclass, sep = "_")
  }
  write_dta(combined, file.path(final, paste0(r$wave, "_", r$suffix, ".dta")))
}

# ════════════════════════════════════════════════════════════════════════════
# DIAGNOSTICS -- COMPREHENSIVE SMD TABLES
# ════════════════════════════════════════════════════════════════════════════

cat("\n\n")
cat("════════════════════════════════════════════════════════════════════════════\n")
cat("INDIVIDUAL-LEVEL MATCHING: SMD TABLE (ALL METHODS & PERIODS MERGED)\n")
cat("Target: < 0.1 after matching (ideally < 0.05)\n")
cat("════════════════════════════════════════════════════════════════════════════\n\n")

round_smd <- function(smd_table) {
  numeric_cols <- grep("Before|After", names(smd_table))
  smd_table[, numeric_cols] <- round(smd_table[, numeric_cols], 4)
  smd_table
}

for (wave_name in c("Wave1996", "Wave2004", "Wave2007")) {
  key <- paste0(wave_name, "_SMD")
  if (key %in% names(smd_diagnostics)) {
    cat("-- ", wave_name, " --\n", sep = "")
    print(round_smd(smd_diagnostics[[key]]), digits = 4)
    cat("\n")
  }
}

# ════════════════════════════════════════════════════════════════════════════
# SUMMARY STATISTICS BY WAVE & PERIOD
# ════════════════════════════════════════════════════════════════════════════

compute_smd_summary <- function(smd_table, wave_name, period_suffix) {
  
  after_cols <- grep(paste0(period_suffix, "_After"), names(smd_table))
  if (length(after_cols) == 0) return(NULL)
  
  method_names <- sub(paste0("_", period_suffix, "_After"), "",
                      names(smd_table)[after_cols])
  
  results <- data.frame()
  
  for (i in seq_along(after_cols)) {
    after_vals <- smd_table[, after_cols[i]]
    
    n_covars   <- sum(!is.na(after_vals))
    if (n_covars == 0L) next
    
    avg_smd    <- mean(abs(after_vals), na.rm = TRUE)
    max_smd    <- max(abs(after_vals),  na.rm = TRUE)
    pass_count <- sum(abs(after_vals) < 0.1, na.rm = TRUE)
    
    results <- rbind(results, data.frame(
      Wave             = wave_name,
      Period           = period_suffix,
      Method           = method_names[i],
      Avg_SMD          = round(avg_smd, 4),
      Max_SMD          = round(max_smd, 4),
      Pass_Count       = pass_count,
      Total_Covariates = n_covars,
      Pass_Percent     = round(pass_count / n_covars * 100, 1),
      stringsAsFactors = FALSE
    ))
  }
  
  results
}

cat("════════════════════════════════════════════════════════════════════════════\n")
cat("SUMMARY STATISTICS: BALANCE BY WAVE, PERIOD & METHOD\n")
cat("════════════════════════════════════════════════════════════════════════════\n\n")

all_summaries <- data.frame()

for (wave_name in c("Wave1996", "Wave2004", "Wave2007")) {
  key <- paste0(wave_name, "_SMD")
  if (key %in% names(smd_diagnostics)) {
    smd_table <- round_smd(smd_diagnostics[[key]])
    for (period in c("Pre", "PostShort", "PostLong")) {
      s <- compute_smd_summary(smd_table, wave_name, period)
      if (!is.null(s)) all_summaries <- rbind(all_summaries, s)
    }
  }
}

print(all_summaries, row.names = FALSE)

# ════════════════════════════════════════════════════════════════════════════
# SAMPLE SIZES TABLE
# ════════════════════════════════════════════════════════════════════════════

cat("\n════════════════════════════════════════════════════════════════════════════\n")
cat("SAMPLE SIZES BY WAVE, METHOD & PERIOD\n")
cat("════════════════════════════════════════════════════════════════════════════\n\n")

sample_sizes_df <- do.call(rbind, sample_sizes)
rownames(sample_sizes_df) <- NULL
print(sample_sizes_df)

# ════════════════════════════════════════════════════════════════════════════
# EXPORT TO CSV
# ════════════════════════════════════════════════════════════════════════════

for (wave_name in c("Wave1996", "Wave2004", "Wave2007")) {
  key <- paste0(wave_name, "_SMD")
  if (key %in% names(smd_diagnostics)) {
    write.csv(round_smd(smd_diagnostics[[key]]),
              file = file.path(final, paste0(wave_name, "_SMD_Table.csv")),
              row.names = FALSE)
  }
}

write.csv(all_summaries,
          file = file.path(final, "Individual_Level_SMD_Summary.csv"),
          row.names = FALSE)

write.csv(sample_sizes_df,
          file = file.path(final, "Individual_Level_Sample_Sizes.csv"),
          row.names = FALSE)

cat("\nCSV files written to:", final, "\n")

# ════════════════════════════════════════════════════════════════════════════
# NOTE ON balance_cem()
# ════════════════════════════════════════════════════════════════════════════
# CEM matches within coarsened strata and returns unequal arm sizes, which it
# corrects via the `weights` column in match.data(). Downsampling both arms to a
# common n (carried over from the original script) draws treated and control
# units independently, which breaks the within-stratum pairing that CEM
# constructed and leaves the `weights` column no longer meaningful.
#
# The standard alternative is to skip the downsampling and carry CEM's weights
# into the outcome regression (in Stata: `reg y treatment [pw = weights]`).
# To do that, delete the `if (r$suffix == "CEM") md <- balance_cem(md)` line.
