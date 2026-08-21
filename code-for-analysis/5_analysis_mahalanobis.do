local method  "Mahalanobis"
local datadir "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/4_final"
local resdir  "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/3_results"
local logdir  "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/9_logs"

cap mkdir "`logdir'"
log using "`logdir'/Mainresults_`method'_${S_DATE}.log", replace text


capture program drop gen_vars
program gen_vars
  gen noboys=1 if b0g2==1
  replace noboys=0 if (b1g1==1 | b2g0==1)
  gen poor=1 if (wealth_index==1)
  replace poor=0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)
  gen education_new=1 if education==4
  replace education_new=2 if education==3
  replace education_new=3 if education==2
  replace education_new=4 if education==1
end

* ---------------------------------------------------------------------------
* 3 columns per wave (9 total):
*   Col 1 - STE:  pre + post_short,  key coef = treatment#post_short  (H0a)
*   Col 2 - LTE:  pre + post_long,   key coef = treatment#post_long   (H0b)
*   Col 3 - Diff: all periods,       key coef = treatment#post_long_extra = LTE-STE (H0c)
* ---------------------------------------------------------------------------

***********************************************************************************
* PART 1: Basic Model
***********************************************************************************

foreach wave in Wave1996 Wave2004 Wave2007 {
  use "`datadir'/`wave'_`method'.dta", clear
  gen_vars
  gen post_any        = (post_short==1 | post_long==1)
  gen post_long_extra = (post_long==1)

  * --- Col 1: STE (H0a) ---
  preserve
  keep if pre==1 | post_short==1
  logit parity_2_3 i.treatment##i.post_short ///
    i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys, ///
    vce(robust)
  if "`wave'"=="Wave1996" {
    etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
      export("`resdir'/Mainresults_`method'.docx", replace)
  }
  else {
    etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
      export("`resdir'/Mainresults_`method'.docx", replace)
  }
  restore

  * --- Col 2: LTE (H0b) ---
  preserve
  keep if pre==1 | post_long==1
  logit parity_2_3 i.treatment##i.post_long ///
    i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys, ///
    vce(robust)
  etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
    export("`resdir'/Mainresults_`method'.docx", replace)
  restore

  * --- Col 3: Differential LTE-STE (H0c) ---
  logit parity_2_3 i.treatment##i.post_any i.treatment##i.post_long_extra ///
    i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys, ///
    vce(robust)
  etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
    export("`resdir'/Mainresults_`method'.docx", replace)
}

***********************************************************************************
* PART 2: Gender Interaction
***********************************************************************************

foreach wave in Wave1996 Wave2004 Wave2007 {
  use "`datadir'/`wave'_`method'.dta", clear
  gen_vars
  * --- Col 1: STE (H0a) ---
  preserve
  keep if pre==1 | post_short==1
  logit parity_2_3 ///
    i.treatment#i.post_short i.treatment#i.post_short#i.noboys ///
    i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor, ///
    vce(robust)
  if "`wave'"=="Wave1996" {
    etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
      export("`resdir'/InteractionGirls_`method'.docx", replace)
  }
  else {
    etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
      export("`resdir'/InteractionGirls_`method'.docx", replace)
  }
  restore

  * --- Col 2: LTE (H0b) ---
  preserve
  keep if pre==1 | post_long==1
  logit parity_2_3 ///
    i.treatment#i.post_long i.treatment#i.post_long#i.noboys ///
    i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor, ///
    vce(robust)
  etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
    export("`resdir'/InteractionGirls_`method'.docx", replace)
  restore
}

***********************************************************************************
* PART 3: Poor Household Interaction
***********************************************************************************

foreach wave in Wave1996 Wave2004 Wave2007 {
  use "`datadir'/`wave'_`method'.dta", clear
  gen_vars
  * --- Col 1: STE (H0a) ---
  preserve
  keep if pre==1 | post_short==1
  logit parity_2_3 ///
    i.treatment#i.post_short i.treatment#i.post_short#i.poor ///
    i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys, ///
    vce(robust)
  if "`wave'"=="Wave1996" {
    etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
      export("`resdir'/InteractionPoor_`method'.docx", replace)
  }
  else {
    etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
      export("`resdir'/InteractionPoor_`method'.docx", replace)
  }
  restore

  * --- Col 2: LTE (H0b) ---
  preserve
  keep if pre==1 | post_long==1
  logit parity_2_3 ///
    i.treatment#i.post_long i.treatment#i.post_long#i.poor ///
    i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys, ///
    vce(robust)
  etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
    export("`resdir'/InteractionPoor_`method'.docx", replace)
  restore
}

log close
