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
   0_restricting_states.do
   1_Matching_State_Level.R
   2_merging_states_NFHS.do
   3_restrictions_waves.do
   4_Matching_Individual_level.R
   5_analysis_mahalanobis.do
   6_analysis_NN.do
   7_analysis_CEM.do
   ```
   Steps 5–7 are independent of each other and can run in any order once step 4 completes.

## Repository Structure

```
├── 1_data/
│   ├── 1_raw/
│   │   └── Census/
│   │       ├── 1991/                # Census 1991 (Wave1996 state matching)
│   │       └── 2001/                # Census 2001 (Wave2004/2007 state matching)
│   ├── 3_processed/
│   │   ├── 0_statelevel/            # Stage-1 matched state panels
│   │   └── 1_wave/                  # Individual match-eligible datasets by wave x method
│   └── 4_final/                     # Stage-2 matched analytic datasets + SMD diagnostics
├── 3_results/                       # Regression output (.docx via etable)
├── 9_logs/                          # Stata log files
├── 0_restricting_states.do          # Build state-level candidate panels (Panel A/B/C)
├── 1_Matching_State_Level.R         # Stage 1: state-level matching (NN/Mahalanobis/CEM)
├── 2_merging_states_NFHS.do         # Merge matched states with individual NFHS records
├── 3_restrictions_waves.do          # Build Parity-23 outcome, treatment/period flags
├── 4_Matching_Individual_level.R    # Stage 2: individual-level matching within period
├── 5_analysis_mahalanobis.do        # DiD models — Mahalanobis matched sample (main results)
├── 6_analysis_NN.do                 # DiD models — Nearest-Neighbor matched sample
├── 7_analysis_CEM.do                # DiD models — Coarsened Exact Matching sample
├── LICENSE
└── README.md
```

## Contact

For questions about the replication code: varnitha.kurli@colorado.edu

## Acknowledgments

This research has benefited from research, administrative, and computing support provided by the University of Colorado Population Center (Project 2P2CHD066613-06), funded by the Eunice Kennedy Shriver National Institute of Child Health and Human Development. We are grateful to participants at the Population Association of America (PAA) 2025 Annual Meeting for their valuable feedback and constructive suggestions that significantly improved the paper.
