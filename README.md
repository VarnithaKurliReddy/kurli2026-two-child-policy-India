# Do Two-Child Policies in India Adequately Address Demographic Realities?

**Replication code for:** Kurli, V., & Menken, J. "Do Two-Child Policies in India Adequately Address Demographic Realities? Examining the Effectiveness and Unintended Consequences of State-Level Fertility Policies"

**Authors:** Varnitha Kurli¹, Jane Menken²

¹Department of Environmental Studies, University of Colorado Boulder; CU Population Center and Population Program, Institute of Behavioral Science
²Institute of Behavioral Science, University of Colorado Boulder

## Abstract

Using difference-in-differences analysis with matching techniques on National Family Health Survey data, we examine whether India's state-level two-child policies succeeded in reducing third-child births and whether their effects differed across demographic and socioeconomic subgroups. We find that while two-child policies decreased the overall likelihood of a third birth in implementing states, they were significantly less effective for families with no sons and the poorest households. This heterogeneity reveals a mismatch between policy design and target-population behavior, with implications for the design of population policy in developing countries.

## Data Availability

NFHS-1 (1992–93), NFHS-3 (2005–06), NFHS-4 (2015–16), and NFHS-5 (2019–21) data are available from the DHS Program (https://dhsprogram.com) upon registration and approval of a research project request, per data-sharing agreements between the DHS Program and the Government of India. Census 1991 and 2001 data are available from the Office of the Registrar General & Census Commissioner, India (https://censusindia.gov.in). Raw survey data are not redistributed in this repository.

## Requirements

- **Stata 17+** (tested on Stata 17.0) — scripts use `etable`, no user-written packages required
- **R** with the following packages:
  ```r
  install.packages(c("MatchIt", "haven"))
  ```

## Usage

1. Request and download NFHS and Census data per **Data Availability** above; place under `1_data/1_raw/` (see **Repository Structure**)
2. Update the hardcoded paths at the top of each script (`BASE_DIR` in the R scripts; `local datadir`/`resdir`/`logdir` and `use "..."` paths in the Stata scripts) to point to your local copy
3. Run scripts in order from the repository root:
   ```
   code for data preparation/0_data_preperation_2005_06.do
   code for data preparation/1_data_preperation_2015_16.do
   code for data preparation/2_data_preperation_2019_21.do
   code for data preparation/3_merging_all_rounds.do
   code for data preparation/4_restricting_states.do
   code for data preparation/5_Matching_State_Level.R
   code for data preparation/6_merging_states_NFHS.do
   code for data preparation/7_restrictions_waves.do
   code for data preparation/8_Matching_Individual_level.R
   code for analysis/0_analysis_mahalanobis.do
   code for analysis/1_analysis_NN.do
   code for analysis/2_analysis_CEM.do
   ```
   Steps 0–2 (per-round DHS cleaning) can run in any order; step 3 requires all three to have completed. Steps 4–5 (Census-based state panels) are independent of steps 0–3 and can run in parallel with them, but must finish before step 6. The three analysis scripts are independent of each other and can run in any order once step 8 completes.

## Repository Structure

```
├── 1_data/
│   ├── 1_raw/
│   │   ├── Census/
│   │   │   ├── 1991/                          # Census 1991 (Wave1996 state matching)
│   │   │   └── 2001/                          # Census 2001 (Wave2004/2007 state matching)
│   │   ├── 2005-06/
│   │   │   └── IA_2005-06_DHS_09252023_1812_94372/
│   │   │       ├── IABR52DT/IABR52FL.dta       # NFHS-3 Birth Record
│   │   │       └── IAHR52DT/IAHR52FL.dta       # NFHS-3 Household Record
│   │   ├── 2015-16/
│   │   │   ├── IABR74DT/IABR74FL.DTA           # NFHS-4 Birth Record
│   │   │   └── IAHR74DT/IAHR74FL.DTA           # NFHS-4 Household Record
│   │   └── 2019-2021/
│   │       ├── Birth Record/IABR7DFL.DTA       # NFHS-5 Birth Record
│   │       └── Household Record/IAHR7DFL.DTA   # NFHS-5 Household Record
│   ├── 2_interim/                   # Trimmed mother/household extracts + per-round merge, one set per survey round (2005_06, 2015_16, 2019_21_all)
│   ├── 3_processed/
│   │   ├── merged_2005_06_all.dta   # Output of 0_data_preperation_2005_06.do
│   │   ├── merged_2015_16_all.dta   # Output of 1_data_preperation_2015_16.do
│   │   ├── merged_2019_21_all.dta   # Output of 2_data_preperation_2019_21.do
│   │   ├── merged_all_rounds.dta    # Output of 3_merging_all_rounds.do (all three rounds stacked)
│   │   ├── 0_statelevel/            # Stage-1 matched state panels
│   │   └── 1_wave/                  # Individual match-eligible datasets by wave x method
│   └── 4_final/                     # Stage-2 matched analytic datasets + SMD diagnostics
├── 3_results/                       # Regression output (.docx via etable)
├── 9_logs/                          # Stata log files
├── code for data preparation/
│   ├── 0_data_preperation_2005_06.do    # Clean NFHS-3 (2005-06) individual records
│   ├── 1_data_preperation_2015_16.do    # Clean NFHS-4 (2015-16) individual records
│   ├── 2_data_preperation_2019_21.do    # Clean NFHS-5 (2019-21) individual records
│   ├── 3_merging_all_rounds.do          # Append the three cleaned survey rounds
│   ├── 4_restricting_states.do          # Build state-level candidate panels (Panel A/B/C)
│   ├── 5_Matching_State_Level.R         # Stage 1: state-level matching (NN/Mahalanobis/CEM)
│   ├── 6_merging_states_NFHS.do         # Merge matched states with individual NFHS records
│   ├── 7_restrictions_waves.do          # Build Parity-23 outcome, treatment/period flags
│   └── 8_Matching_Individual_level.R    # Stage 2: individual-level matching within period
├── code for analysis/
│   ├── 0_analysis_mahalanobis.do        # DiD models — Mahalanobis matched sample (main results)
│   ├── 1_analysis_NN.do                 # DiD models — Nearest-Neighbor matched sample
│   └── 2_analysis_CEM.do                # DiD models — Coarsened Exact Matching sample
├── LICENSE
└── README.md
```

## Contact

For questions about the replication code: varnitha.kurli@colorado.edu

## Acknowledgments

This research has benefited from research, administrative, and computing support provided by the University of Colorado Population Center (Project 2P2CHD066613-06), funded by the Eunice Kennedy Shriver National Institute of Child Health and Human Development. We are grateful to participants at the Population Association of America (PAA) 2025 Annual Meeting for their valuable feedback and constructive suggestions that significantly improved the paper.

