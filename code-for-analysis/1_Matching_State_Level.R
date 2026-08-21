# ════════════════════════════════════════════════════════════════════════════
# STATE-LEVEL MATCHING WITH SMD DIAGNOSTICS
# File: 1_Matching_State_Level.R
# ════════════════════════════════════════════════════════════════════════════

library("MatchIt")
library(haven)

BASE_DIR <- "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/"

# ── Shared CEM helper: subsample to 3 controls per treated unit ──────────────
# If fewer than n_treated*3 controls survive CEM, uses all available controls.
cem_subsample <- function(matched_data, seed = 123) {
  matched_data <- as.data.frame(matched_data)
  treated      <- matched_data[matched_data$treatment == 1, ]
  control      <- matched_data[matched_data$treatment == 0, ]
  n_needed     <- nrow(treated) * 3
  set.seed(seed)
  if (nrow(control) <= n_needed) {
    warning(sprintf(
      "CEM: only %d controls available for %d needed (ratio < 3:1); using all controls.",
      nrow(control), n_needed
    ))
    control_sub <- control
  } else {
    control_sub <- control[sample(nrow(control), n_needed, replace = FALSE), ]
  }
  rbind(treated, control_sub)
}


# ── Matched-states bookkeeping helpers ──────────────────────────────────────
# METHOD_LEVELS fixes the column order of every by-method table below.
METHOD_LEVELS <- c("NN_PSM", "Mahalanobis", "CEM")

# One row per unit retained by a match: which state, treated or control.
# `md` is a match.data() result (or the cem_subsample() of one).
matched_states_long <- function(md, panel, treatment_state, method) {
  md <- as.data.frame(md)
  data.frame(
    Panel           = panel,
    Treatment_State = treatment_state,
    Method          = factor(method, levels = METHOD_LEVELS),
    State           = as.character(md$State),
    Role            = ifelse(md$treatment == 1, "treated", "control"),
    Subclass        = if ("subclass" %in% names(md)) as.character(md$subclass) else NA_character_,
    Weight          = if ("weights"  %in% names(md)) as.numeric(md$weights)    else NA_real_,
    stringsAsFactors = FALSE,
    row.names        = NULL
  )
}

# Collapse to one row per (panel, treated state, method): the control states used.
matched_states_summary <- function(long_tbl) {
  ctrl <- long_tbl[long_tbl$Role == "control", ]
  by   <- list(Panel = ctrl$Panel, Treatment_State = ctrl$Treatment_State,
               Method = ctrl$Method)
  agg  <- aggregate(list(Matched_Controls = ctrl$State), by = by,
                    FUN = function(x) paste(sort(unique(x)), collapse = "; "))
  cnt  <- aggregate(list(N_Controls = ctrl$State), by = by,
                    FUN = function(x) length(unique(x)))
  out  <- merge(agg, cnt, by = c("Panel", "Treatment_State", "Method"))
  out[order(out$Panel, out$Treatment_State, out$Method), ]
}

# Wide 0/1 indicator: rows = candidate control states, cols = matching methods.
# N_Methods shows how many methods agreed on that state (3 = selected by all).
matched_states_indicator <- function(long_tbl) {
  ctrl <- long_tbl[long_tbl$Role == "control", ]
  key  <- paste(ctrl$Panel, ctrl$Treatment_State, ctrl$State, sep = "\r")
  ind  <- as.data.frame.matrix((table(key, ctrl$Method) > 0) * 1L)
  parts <- do.call(rbind, strsplit(rownames(ind), "\r", fixed = TRUE))
  out  <- data.frame(Panel = parts[, 1], Treatment_State = parts[, 2],
                     State = parts[, 3], ind,
                     check.names = FALSE, stringsAsFactors = FALSE,
                     row.names = NULL)
  method_cols   <- names(ind)
  out$N_Methods <- rowSums(out[, method_cols, drop = FALSE])
  out[order(out$Panel, out$Treatment_State, -out$N_Methods, out$State), ]
}

# Print the summary + indicator for one panel.
print_matched_states <- function(long_tbl, header) {
  cat("\n\n════════════════════════════════════════════════════════════════════════════\n")
  cat(header, "\n")
  cat("════════════════════════════════════════════════════════════════════════════\n\n")
  print(matched_states_summary(long_tbl), row.names = FALSE)
  cat("\n── Method overlap (1 = state selected by that method) ──\n")
  print(matched_states_indicator(long_tbl), row.names = FALSE)
  cat("\n")
}

# Accumulator for the cross-panel table written at the end of the script.
matched_states_all <- list()


# ════════════════════════════════════════════════════════════════════════════
# PANEL A — Andhra Pradesh, Rajasthan, Haryana, Odisha (matched separately)
# Single combined CSV output + match pairs lookup
# ════════════════════════════════════════════════════════════════════════════
panelA <- read_dta(paste0(BASE_DIR, "PanelA.dta"))

# Impute Sikkim's missing NFHS value from Arunachal Pradesh
panelA$NFHS1199293[panelA$State == "sikkim"] <-
  panelA$NFHS1199293[panelA$State == "arunachal pradesh"]

FORMULA_A <- treatment ~ female_labor + female_literacy + prop_lhc + NFHS1199293
ALL_TREAT <- c("andhra pradesh", "rajasthan", "haryana", "odisha")

all_results_A <- list()
sample_sizes_A <- list()  # Track sample sizes

for (state_name in ALL_TREAT) {
  
  other_treat <- setdiff(ALL_TREAT, state_name)
  df_sub <- panelA[!(panelA$State %in% other_treat), ]
  
  cat("\n── Panel A | Matching for:", state_name, "(n =", nrow(df_sub), ") ──\n")
  
  # NN (PSM)
  m_nn    <- suppressWarnings(matchit(FORMULA_A, data = df_sub,
                                      method = "nearest", distance = "glm", link = "logit",
                                      ratio = 3, replace = FALSE))
  nn_data <- as.data.frame(match.data(m_nn))
  nn_data$match_method    <- "NN_PSM"
  nn_data$treatment_state <- state_name
  print(summary(m_nn))
  plot(m_nn, type = "jitter", interactive = FALSE)
  plot(summary(m_nn), abs = FALSE)
  
  # Mahalanobis
  m_mah    <- matchit(FORMULA_A, data = df_sub,
                      method = "nearest", distance = "mahalanobis", ratio = 3)
  mah_data <- as.data.frame(match.data(m_mah))
  mah_data$distance        <- NA_real_
  mah_data$match_method    <- "Mahalanobis"
  mah_data$treatment_state <- state_name
  print(summary(m_mah))
  plot(summary(m_mah), abs = FALSE)
  
  # CEM
  m_cem    <- matchit(FORMULA_A, data = df_sub,
                      method = "cem",
                      cutpoints = list(female_labor    = 2,
                                       female_literacy = 2,
                                       prop_lhc        = 2,
                                       NFHS1199293     = 2))
  cem_data <- cem_subsample(match.data(m_cem))
  cem_data$distance        <- NA_real_
  cem_data$match_method    <- "CEM"
  cem_data$treatment_state <- state_name
  print(summary(m_cem))
  plot(summary(m_cem), abs = FALSE)
  
  # Store sample sizes for this state
  sample_sizes_A[[state_name]] <- data.frame(
    State = state_name,
    NN_Sample = nrow(nn_data),
    Mah_Sample = nrow(mah_data),
    CEM_Sample = nrow(cem_data)
  )
  
  all_results_A[[state_name]] <- rbind(nn_data, mah_data, cem_data)
}

combined_A <- do.call(rbind, all_results_A)

# ── Match pairs: which control states were matched to each treatment state ──
match_pairs <- combined_A[, c("treatment_state", "treatment", "State",
                              "subclass", "match_method")]
match_pairs <- match_pairs[order(match_pairs$treatment_state,
                                 match_pairs$match_method,
                                 match_pairs$subclass), ]
cat("\n── Panel A | Match Pairs ──\n")
print(match_pairs)

write.csv(combined_A,
          file = paste0(BASE_DIR, "PanelA_AllStates_Combined.csv"),
          row.names = FALSE)
write.csv(match_pairs,
          file = paste0(BASE_DIR, "PanelA_MatchPairs.csv"),
          row.names = FALSE)

cat("\nPanel A outputs written.\n")
print(table(combined_A$treatment_state, combined_A$match_method))

# ── Panel A | Which states were matched, by method ──────────────────────────
panelA_states <- data.frame(
  Panel           = "A",
  Treatment_State = combined_A$treatment_state,
  Method          = factor(combined_A$match_method, levels = METHOD_LEVELS),
  State           = as.character(combined_A$State),
  Role            = ifelse(combined_A$treatment == 1, "treated", "control"),
  Subclass        = as.character(combined_A$subclass),
  Weight          = as.numeric(combined_A$weights),
  stringsAsFactors = FALSE,
  row.names        = NULL
)
matched_states_all[["A"]] <- panelA_states
print_matched_states(panelA_states, "PANEL A — MATCHED CONTROL STATES BY METHOD")

# ════════════════════════════════════════════════════════════════════════════
# DIAGNOSTICS — Panel A SMD Table
# ════════════════════════════════════════════════════════════════════════════

extract_smd <- function(match_obj) {
  summary_obj <- summary(match_obj)
  
  # Extract covariates (exclude "distance" which is the propensity score)
  all_vars <- rownames(summary_obj$sum.all)
  covars <- all_vars[all_vars != "distance"]
  
  smd_table <- data.frame(
    Covariate = covars,
    SMD_Before = summary_obj$sum.all[covars, "Std. Mean Diff."],
    SMD_After = summary_obj$sum.matched[covars, "Std. Mean Diff."],
    stringsAsFactors = FALSE,
    row.names = NULL
  )
  
  smd_table
}

panelA_diag <- list()

for (state_name in ALL_TREAT) {
  other_treat <- setdiff(ALL_TREAT, state_name)
  df_sub <- panelA[!(panelA$State %in% other_treat), ]
  
  # Rerun matching (silently, suppressing warnings)
  m_nn_diag   <- suppressWarnings(matchit(FORMULA_A, data = df_sub, method = "nearest", 
                                          distance = "glm", link = "logit", ratio = 3, replace = FALSE))
  m_mah_diag  <- matchit(FORMULA_A, data = df_sub, method = "nearest", 
                         distance = "mahalanobis", ratio = 3)
  m_cem_diag  <- matchit(FORMULA_A, data = df_sub, method = "cem",
                         cutpoints = list(female_labor = 2, female_literacy = 2, 
                                          prop_lhc = 2, NFHS1199293 = 2))
  
  # Extract SMD tables
  smd_nn  <- extract_smd(m_nn_diag)
  smd_mah <- extract_smd(m_mah_diag)
  smd_cem <- extract_smd(m_cem_diag)
  
  # Merge SMD tables by Covariate name to handle different row counts
  smd_comparison <- smd_nn[, c("Covariate", "SMD_Before", "SMD_After")]
  names(smd_comparison) <- c("Covariate", "NN_Before", "NN_After")
  
  smd_mah_renamed <- smd_mah[, c("Covariate", "SMD_Before", "SMD_After")]
  names(smd_mah_renamed) <- c("Covariate", "Mah_Before", "Mah_After")
  
  smd_cem_renamed <- smd_cem[, c("Covariate", "SMD_Before", "SMD_After")]
  names(smd_cem_renamed) <- c("Covariate", "CEM_Before", "CEM_After")
  
  # Merge on Covariate name (full outer join to catch all covariates)
  smd_comparison <- merge(smd_comparison, smd_mah_renamed, by = "Covariate", all = TRUE)
  smd_comparison <- merge(smd_comparison, smd_cem_renamed, by = "Covariate", all = TRUE)
  
  # Round all numeric columns
  numeric_cols <- grep("Before|After", names(smd_comparison))
  smd_comparison[, numeric_cols] <- round(smd_comparison[, numeric_cols], 4)
  
  panelA_diag[[state_name]] <- smd_comparison
}

cat("\n\n════════════════════════════════════════════════════════════════════════════\n")
cat("PANEL A — STANDARDIZED MEAN DIFFERENCE (SMD) DIAGNOSTICS\n")
cat("Target: < 0.1 after matching (ideally < 0.05)\n")
cat("════════════════════════════════════════════════════════════════════════════\n\n")

for (state_name in ALL_TREAT) {
  cat("── ", toupper(state_name), " ──\n", sep = "")
  print(panelA_diag[[state_name]], digits = 4)
  
  # Summary statistics
  nn_pass <- sum(panelA_diag[[state_name]]$NN_After < 0.1)
  mah_pass <- sum(panelA_diag[[state_name]]$Mah_After < 0.1)
  cem_pass <- sum(panelA_diag[[state_name]]$CEM_After < 0.1)
  n_covars <- nrow(panelA_diag[[state_name]])
  
  cat("  Summary: NN (", nn_pass, "/", n_covars, " pass)", 
      " | Mahalanobis (", mah_pass, "/", n_covars, " pass)",
      " | CEM (", cem_pass, "/", n_covars, " pass)\n\n", sep = "")
}


# ════════════════════════════════════════════════════════════════════════════
# PANEL B — Maharashtra
# ════════════════════════════════════════════════════════════════════════════
panelB    <- read_dta(paste0(BASE_DIR, "PanelB.dta"))
# Impute Sikkim's missing NFHS value from Arunachal Pradesh
panelB$NFHS1199293[panelB$State == "sikkim"] <-
  panelB$NFHS1199293[panelB$State == "arunachal pradesh"]

FORMULA_B <- treatment ~ female_labor + female_literacy + prop_lhc + NFHS1199293

cat("\n\n── Panel B | Maharashtra ──\n")

# NN (PSM)
m_nn <- matchit(FORMULA_B, data = panelB,
                method = "nearest", distance = "glm", link = "logit",
                ratio = 3, replace = FALSE)
print(summary(m_nn))
plot(m_nn, type = "jitter", interactive = FALSE)
plot(summary(m_nn), abs = FALSE)
nn_B <- as.data.frame(match.data(m_nn))
write.csv(nn_B,
          file = paste0(BASE_DIR, "NN_Maharashtra_State.csv"),
          row.names = FALSE)

# Mahalanobis
m_mah <- matchit(FORMULA_B, data = panelB,
                 method = "nearest", distance = "mahalanobis", ratio = 3)
print(summary(m_mah))
plot(summary(m_mah), abs = FALSE)
mah_B <- as.data.frame(match.data(m_mah))
write.csv(mah_B,
          file = paste0(BASE_DIR, "Mahalanobis_Maharashtra_State.csv"),
          row.names = FALSE)

# CEM
m_cem <- matchit(FORMULA_B, data = panelB,
                 method = "cem",
                 cutpoints = list(female_labor    = 3,
                                  female_literacy = 3,
                                  prop_lhc        = 3,
                                  NFHS1199293     = 2))
print(summary(m_cem))
plot(summary(m_cem), abs = FALSE)
cem_B <- cem_subsample(match.data(m_cem))
write.csv(cem_B,
          file = paste0(BASE_DIR, "CEM_Maharashtra_State.csv"),
          row.names = FALSE)

# ── Panel B | Which states were matched, by method ──────────────────────────
panelB_states <- rbind(
  matched_states_long(nn_B,  "B", "maharashtra", "NN_PSM"),
  matched_states_long(mah_B, "B", "maharashtra", "Mahalanobis"),
  matched_states_long(cem_B, "B", "maharashtra", "CEM")
)
matched_states_all[["B"]] <- panelB_states
print_matched_states(panelB_states, "PANEL B — MATCHED CONTROL STATES BY METHOD")

# ════════════════════════════════════════════════════════════════════════════
# DIAGNOSTICS — Panel B SMD Table
# ════════════════════════════════════════════════════════════════════════════

smd_nn_B  <- extract_smd(m_nn)
smd_mah_B <- extract_smd(m_mah)
smd_cem_B <- extract_smd(m_cem)

# Merge by covariate name
smd_comparison_B <- smd_nn_B[, c("Covariate", "SMD_Before", "SMD_After")]
names(smd_comparison_B) <- c("Covariate", "NN_Before", "NN_After")

smd_mah_B_renamed <- smd_mah_B[, c("Covariate", "SMD_Before", "SMD_After")]
names(smd_mah_B_renamed) <- c("Covariate", "Mah_Before", "Mah_After")

smd_cem_B_renamed <- smd_cem_B[, c("Covariate", "SMD_Before", "SMD_After")]
names(smd_cem_B_renamed) <- c("Covariate", "CEM_Before", "CEM_After")

smd_comparison_B <- merge(smd_comparison_B, smd_mah_B_renamed, by = "Covariate", all = TRUE)
smd_comparison_B <- merge(smd_comparison_B, smd_cem_B_renamed, by = "Covariate", all = TRUE)

numeric_cols <- grep("Before|After", names(smd_comparison_B))
smd_comparison_B[, numeric_cols] <- round(smd_comparison_B[, numeric_cols], 4)

cat("\n\n════════════════════════════════════════════════════════════════════════════\n")
cat("PANEL B — MAHARASHTRA: STANDARDIZED MEAN DIFFERENCE (SMD) DIAGNOSTICS\n")
cat("Target: < 0.1 after matching (ideally < 0.05)\n")
cat("════════════════════════════════════════════════════════════════════════════\n\n")
print(smd_comparison_B, digits = 4)

nn_pass_B <- sum(smd_comparison_B$NN_After < 0.1)
mah_pass_B <- sum(smd_comparison_B$Mah_After < 0.1)
cem_pass_B <- sum(smd_comparison_B$CEM_After < 0.1)
n_covars_B <- nrow(smd_comparison_B)

cat("\nSummary: NN (", nn_pass_B, "/", n_covars_B, " pass)", 
    " | Mahalanobis (", mah_pass_B, "/", n_covars_B, " pass)",
    " | CEM (", cem_pass_B, "/", n_covars_B, " pass)\n\n", sep = "")


# ════════════════════════════════════════════════════════════════════════════
# PANEL C — Gujarat
# ════════════════════════════════════════════════════════════════════════════
panelC <- read_dta(paste0(BASE_DIR, "PanelC.dta"))

# Impute missing NFHS values from parent states
panelC$NFHS1199293[panelC$State == "jharkhand"] <-
  panelC$NFHS1199293[panelC$State == "bihar"]
panelC$NFHS1199293[panelC$State == "sikkim"] <-
  panelC$NFHS1199293[panelC$State == "arunachal pradesh"]

FORMULA_C <- treatment ~ female_labor +  female_literacy + prop_lhc + NFHS1199293

cat("\n\n── Panel C | Gujarat ──\n")

# NN (PSM)
m_nn <- matchit(FORMULA_C, data = panelC,
                method = "nearest", distance = "glm", link = "logit",
                ratio = 3, replace = TRUE)
print(summary(m_nn))
plot(m_nn, type = "jitter", interactive = FALSE)
plot(summary(m_nn), abs = FALSE)
nn_C <- as.data.frame(match.data(m_nn))
write.csv(nn_C,
          file = paste0(BASE_DIR, "NN_Gujarat_State.csv"),
          row.names = FALSE)

# Mahalanobis
m_mah <- matchit(FORMULA_C, data = panelC,
                 method = "nearest", distance = "mahalanobis", ratio = 3)
print(summary(m_mah))
plot(summary(m_mah), abs = FALSE)
mah_C <- as.data.frame(match.data(m_mah))
write.csv(mah_C,
          file = paste0(BASE_DIR, "Mahalanobis_Gujarat_State.csv"),
          row.names = FALSE)

# CEM
m_cem <- matchit(FORMULA_C, data = panelC,
                 method = "cem",
                 cutpoints = list(female_labor = 2,
                                  female_literacy = 2,
                                  prop_lhc     = 2,
                                  NFHS1199293  = 2))
print(summary(m_cem))
plot(summary(m_cem), abs = FALSE)
cem_C <- cem_subsample(match.data(m_cem))
write.csv(cem_C,
          file = paste0(BASE_DIR, "CEM_Gujarat_State.csv"),
          row.names = FALSE)

# ── Panel C | Which states were matched, by method ──────────────────────────
# NOTE: Panel C NN uses replace = TRUE, so a control state can serve several
# treated units; match.data() still returns it once, with Weight > 1.
panelC_states <- rbind(
  matched_states_long(nn_C,  "C", "gujarat", "NN_PSM"),
  matched_states_long(mah_C, "C", "gujarat", "Mahalanobis"),
  matched_states_long(cem_C, "C", "gujarat", "CEM")
)
matched_states_all[["C"]] <- panelC_states
print_matched_states(panelC_states, "PANEL C — MATCHED CONTROL STATES BY METHOD")

# ════════════════════════════════════════════════════════════════════════════
# DIAGNOSTICS — Panel C SMD Table
# ════════════════════════════════════════════════════════════════════════════

smd_nn_C  <- extract_smd(m_nn)
smd_mah_C <- extract_smd(m_mah)
smd_cem_C <- extract_smd(m_cem)

# Merge by covariate name
smd_comparison_C <- smd_nn_C[, c("Covariate", "SMD_Before", "SMD_After")]
names(smd_comparison_C) <- c("Covariate", "NN_Before", "NN_After")

smd_mah_C_renamed <- smd_mah_C[, c("Covariate", "SMD_Before", "SMD_After")]
names(smd_mah_C_renamed) <- c("Covariate", "Mah_Before", "Mah_After")

smd_cem_C_renamed <- smd_cem_C[, c("Covariate", "SMD_Before", "SMD_After")]
names(smd_cem_C_renamed) <- c("Covariate", "CEM_Before", "CEM_After")

smd_comparison_C <- merge(smd_comparison_C, smd_mah_C_renamed, by = "Covariate", all = TRUE)
smd_comparison_C <- merge(smd_comparison_C, smd_cem_C_renamed, by = "Covariate", all = TRUE)

numeric_cols <- grep("Before|After", names(smd_comparison_C))
smd_comparison_C[, numeric_cols] <- round(smd_comparison_C[, numeric_cols], 4)

cat("\n\n════════════════════════════════════════════════════════════════════════════\n")
cat("PANEL C — GUJARAT: STANDARDIZED MEAN DIFFERENCE (SMD) DIAGNOSTICS\n")
cat("Target: < 0.1 after matching (ideally < 0.05)\n")
cat("════════════════════════════════════════════════════════════════════════════\n\n")
print(smd_comparison_C, digits = 4)

nn_pass_C <- sum(smd_comparison_C$NN_After < 0.1)
mah_pass_C <- sum(smd_comparison_C$Mah_After < 0.1)
cem_pass_C <- sum(smd_comparison_C$CEM_After < 0.1)
n_covars_C <- nrow(smd_comparison_C)

cat("\nSummary: NN (", nn_pass_C, "/", n_covars_C, " pass)", 
    " | Mahalanobis (", mah_pass_C, "/", n_covars_C, " pass)",
    " | CEM (", cem_pass_C, "/", n_covars_C, " pass)\n\n", sep = "")

# ════════════════════════════════════════════════════════════════════════════
# MATCHED STATES BY METHOD — COMBINED ACROSS PANELS + CSV EXPORT
# ════════════════════════════════════════════════════════════════════════════

matched_states_long_all <- do.call(rbind, matched_states_all)
row.names(matched_states_long_all) <- NULL

matched_states_summary_all   <- matched_states_summary(matched_states_long_all)
matched_states_indicator_all <- matched_states_indicator(matched_states_long_all)

cat("\n\n════════════════════════════════════════════════════════════════════════════\n")
cat("ALL PANELS — MATCHED CONTROL STATES BY METHOD\n")
cat("════════════════════════════════════════════════════════════════════════════\n\n")
print(matched_states_summary_all, row.names = FALSE)

cat("\n── Method overlap (1 = state selected by that method) ──\n")
print(matched_states_indicator_all, row.names = FALSE)

# Unit-level records (one row per retained state, per method)
write.csv(matched_states_long_all,
          file = paste0(BASE_DIR, "MatchedStates_ByMethod_Long.csv"),
          row.names = FALSE)

# One row per treated state x method, controls collapsed into a single cell
write.csv(matched_states_summary_all,
          file = paste0(BASE_DIR, "MatchedStates_ByMethod_Summary.csv"),
          row.names = FALSE)

# 0/1 matrix: control state x method, with N_Methods agreement count
write.csv(matched_states_indicator_all,
          file = paste0(BASE_DIR, "MatchedStates_ByMethod_Indicator.csv"),
          row.names = FALSE)

cat("\nMatched-state tables written to:\n",
    "  MatchedStates_ByMethod_Long.csv\n",
    "  MatchedStates_ByMethod_Summary.csv\n",
    "  MatchedStates_ByMethod_Indicator.csv\n", sep = "")