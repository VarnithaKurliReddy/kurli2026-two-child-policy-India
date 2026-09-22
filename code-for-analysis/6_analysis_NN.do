* ---------------------------------------------------------------------------
* Fertility Limits - main results, NN matched samples
*
* Everything goes into one workbook, one sheet per model, three waves as
* columns. ST and LT sit side by side on the same sheet rather than in one
* combined table, so neither carries empty rows for the other's period terms:
*
*   Basic          - ST at A1, LT at J1, Diff at S1   (H0a / H0b / H0c)
*   No boys        - ST at A1, LT at J1               (triple with noboys)
*   Poor           - ST at A1, LT at J1               (triple with poor)
*   No education   - ST at A1, LT at J1               (triple with noeduc)
*
* Each table is 7 columns wide (label + 3 waves x coef/stars), so the column
* offsets leave two spare columns between tables.
*
* Marginal effects (Ai and Norton 2003 - the triple coefficient is not the
* interaction effect in a logit) go to their own sheets, with standard errors:
*
*   No boys mfx | Poor mfx | No educ mfx   - ST left (col A), LT right (col M)
*   per wave: AME of treatment by cell, then the DDD on the probability scale
* ---------------------------------------------------------------------------

local datadir "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/4_final"
local resdir  "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/3_results"
local logdir  "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/9_logs"

cap mkdir "`logdir'"
log using "`logdir'/Mainresults_NN_${S_DATE}.log", replace text

local out "`resdir'/Results_NN.xlsx"


***********************************************************************************
* PART 1A: Basic Model - Short Term
* key coef = treatment#post_short (H0a)
* sheet "Basic ST"
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys ///
  if pre==1 | post_short==1, vce(robust)

etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys ///
  if pre==1 | post_short==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys ///
  if pre==1 | post_short==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
  title("Short term (ST)") ///
  export("`out'", sheet("Basic") cell(A1) replace)


***********************************************************************************
* PART 1B: Basic Model - Long Term
* key coef = treatment#post_long (H0b)
* sheet "Basic LT"
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys ///
  if pre==1 | post_long==1, vce(robust)

etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys ///
  if pre==1 | post_long==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys ///
  if pre==1 | post_long==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
  title("Long term (LT)") ///
  export("`out'", sheet("Basic") cell(J1) modify)


***********************************************************************************
* PART 1C: Basic Model - Difference (LT minus ST)
* key coef = treatment#post_long_extra (H0c); uses the whole sample
* sheet "Basic Diff"
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
gen post_any = (post_short==1 | post_long==1)
gen post_long_extra = (post_long==1)

logit parity_2_3 i.treatment##i.post_any i.treatment##i.post_long_extra ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys, ///
  vce(robust)

etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
gen post_any = (post_short==1 | post_long==1)
gen post_long_extra = (post_long==1)

logit parity_2_3 i.treatment##i.post_any i.treatment##i.post_long_extra ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys, ///
  vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
gen post_any = (post_short==1 | post_long==1)
gen post_long_extra = (post_long==1)

logit parity_2_3 i.treatment##i.post_any i.treatment##i.post_long_extra ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor i.noboys, ///
  vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
  title("Difference (LT minus ST)") ///
  export("`out'", sheet("Basic") cell(S1) modify)


***********************************************************************************
* PART 2A: Gender Interaction - Short Term
* noboys moves from the controls into the interaction here
* sheet "No boys ST"
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_short==1, vce(robust)

etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_short==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_short==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
  title("Short term (ST)") ///
  export("`out'", sheet("No boys") cell(A1) modify)


***********************************************************************************
* PART 2B: Gender Interaction - Long Term
* noboys moves from the controls into the interaction here
* sheet "No boys LT"
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_long==1, vce(robust)

etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_long==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_long==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
  title("Long term (LT)") ///
  export("`out'", sheet("No boys") cell(J1) modify)


***********************************************************************************
* PART 3A: Poor Household Interaction - Short Term
* poor moves from the controls into the interaction here
* sheet "Poor ST"
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_short==1, vce(robust)

etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_short==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_short==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
  title("Short term (ST)") ///
  export("`out'", sheet("Poor") cell(A1) modify)


***********************************************************************************
* PART 3B: Poor Household Interaction - Long Term
* poor moves from the controls into the interaction here
* sheet "Poor LT"
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_long==1, vce(robust)

etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_long==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_long==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
  title("Long term (LT)") ///
  export("`out'", sheet("Poor") cell(J1) modify)


***********************************************************************************
* PART 4A: Education Interaction - Short Term
* education_new moves from the controls into the interaction here
* noeduc = 1 for women with no schooling, 0 for any schooling
* sheet "No educ ST"
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_short##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_short==1, vce(robust)

etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_short##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_short==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_short##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_short==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
  title("Short term (ST)") ///
  export("`out'", sheet("No education") cell(A1) modify)


***********************************************************************************
* PART 4B: Education Interaction - Long Term
* education_new moves from the controls into the interaction here
* noeduc = 1 for women with no schooling, 0 for any schooling
* sheet "No educ LT"
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_long##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_long==1, vce(robust)

etable, cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_long##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_long==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_long##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_long==1, vce(robust)

etable, append cstat(_r_b) mstat(N) mstat(r2) showstars showstarsnote ///
  title("Long term (LT)") ///
  export("`out'", sheet("No education") cell(J1) modify)


***********************************************************************************
* PART 5C: noboys - marginal effects, ST
* The logit coefficient on a triple interaction is not the interaction effect
* in a nonlinear model (Ai and Norton 2003), so the same models are re-run here
* and read on the probability scale instead.
* sheet "No boys mfx", left block (column A)
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_short==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_short x noboys cell
margins post_short#noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - AME of treatment by cell") ///
  export("`out'", sheet("No boys mfx") cell(A1) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_short#r.noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - DDD on probability scale") ///
  export("`out'", sheet("No boys mfx") cell(A14) modify)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_short==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_short x noboys cell
margins post_short#noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - AME of treatment by cell") ///
  export("`out'", sheet("No boys mfx") cell(A24) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_short#r.noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - DDD on probability scale") ///
  export("`out'", sheet("No boys mfx") cell(A37) modify)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_short==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_short x noboys cell
margins post_short#noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - AME of treatment by cell") ///
  export("`out'", sheet("No boys mfx") cell(A47) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_short#r.noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - DDD on probability scale") ///
  export("`out'", sheet("No boys mfx") cell(A60) modify)


***********************************************************************************
* PART 5D: noboys - marginal effects, LT
* The logit coefficient on a triple interaction is not the interaction effect
* in a nonlinear model (Ai and Norton 2003), so the same models are re-run here
* and read on the probability scale instead.
* sheet "No boys mfx", right block (column M)
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_long==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_long x noboys cell
margins post_long#noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - AME of treatment by cell") ///
  export("`out'", sheet("No boys mfx") cell(M1) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_long#r.noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - DDD on probability scale") ///
  export("`out'", sheet("No boys mfx") cell(M14) modify)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_long==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_long x noboys cell
margins post_long#noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - AME of treatment by cell") ///
  export("`out'", sheet("No boys mfx") cell(M24) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_long#r.noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - DDD on probability scale") ///
  export("`out'", sheet("No boys mfx") cell(M37) modify)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.noboys ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.poor ///
  if pre==1 | post_long==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_long x noboys cell
margins post_long#noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - AME of treatment by cell") ///
  export("`out'", sheet("No boys mfx") cell(M47) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_long#r.noboys, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - DDD on probability scale") ///
  export("`out'", sheet("No boys mfx") cell(M60) modify)


***********************************************************************************
* PART 6C: poor - marginal effects, ST
* The logit coefficient on a triple interaction is not the interaction effect
* in a nonlinear model (Ai and Norton 2003), so the same models are re-run here
* and read on the probability scale instead.
* sheet "Poor mfx", left block (column A)
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_short==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_short x poor cell
margins post_short#poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - AME of treatment by cell") ///
  export("`out'", sheet("Poor mfx") cell(A1) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_short#r.poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - DDD on probability scale") ///
  export("`out'", sheet("Poor mfx") cell(A14) modify)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_short==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_short x poor cell
margins post_short#poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - AME of treatment by cell") ///
  export("`out'", sheet("Poor mfx") cell(A24) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_short#r.poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - DDD on probability scale") ///
  export("`out'", sheet("Poor mfx") cell(A37) modify)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_short##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_short==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_short x poor cell
margins post_short#poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - AME of treatment by cell") ///
  export("`out'", sheet("Poor mfx") cell(A47) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_short#r.poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - DDD on probability scale") ///
  export("`out'", sheet("Poor mfx") cell(A60) modify)


***********************************************************************************
* PART 6D: poor - marginal effects, LT
* The logit coefficient on a triple interaction is not the interaction effect
* in a nonlinear model (Ai and Norton 2003), so the same models are re-run here
* and read on the probability scale instead.
* sheet "Poor mfx", right block (column M)
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_long==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_long x poor cell
margins post_long#poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - AME of treatment by cell") ///
  export("`out'", sheet("Poor mfx") cell(M1) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_long#r.poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - DDD on probability scale") ///
  export("`out'", sheet("Poor mfx") cell(M14) modify)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_long==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_long x poor cell
margins post_long#poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - AME of treatment by cell") ///
  export("`out'", sheet("Poor mfx") cell(M24) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_long#r.poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - DDD on probability scale") ///
  export("`out'", sheet("Poor mfx") cell(M37) modify)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1

logit parity_2_3 i.treatment##i.post_long##i.poor ///
  i.age_marraige i.v025 i.religion_class i.education_new i.caste i.noboys ///
  if pre==1 | post_long==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_long x poor cell
margins post_long#poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - AME of treatment by cell") ///
  export("`out'", sheet("Poor mfx") cell(M47) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_long#r.poor, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - DDD on probability scale") ///
  export("`out'", sheet("Poor mfx") cell(M60) modify)


***********************************************************************************
* PART 7C: noeduc - marginal effects, ST
* The logit coefficient on a triple interaction is not the interaction effect
* in a nonlinear model (Ai and Norton 2003), so the same models are re-run here
* and read on the probability scale instead.
* sheet "No educ mfx", left block (column A)
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_short##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_short==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_short x noeduc cell
margins post_short#noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - AME of treatment by cell") ///
  export("`out'", sheet("No educ mfx") cell(A1) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_short#r.noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - DDD on probability scale") ///
  export("`out'", sheet("No educ mfx") cell(A14) modify)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_short##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_short==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_short x noeduc cell
margins post_short#noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - AME of treatment by cell") ///
  export("`out'", sheet("No educ mfx") cell(A24) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_short#r.noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - DDD on probability scale") ///
  export("`out'", sheet("No educ mfx") cell(A37) modify)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_short##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_short==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_short x noeduc cell
margins post_short#noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - AME of treatment by cell") ///
  export("`out'", sheet("No educ mfx") cell(A47) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_short#r.noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - DDD on probability scale") ///
  export("`out'", sheet("No educ mfx") cell(A60) modify)


***********************************************************************************
* PART 7D: noeduc - marginal effects, LT
* The logit coefficient on a triple interaction is not the interaction effect
* in a nonlinear model (Ai and Norton 2003), so the same models are re-run here
* and read on the probability scale instead.
* sheet "No educ mfx", right block (column M)
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_long##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_long==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_long x noeduc cell
margins post_long#noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - AME of treatment by cell") ///
  export("`out'", sheet("No educ mfx") cell(M1) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_long#r.noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 1996 - DDD on probability scale") ///
  export("`out'", sheet("No educ mfx") cell(M14) modify)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_long##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_long==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_long x noeduc cell
margins post_long#noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - AME of treatment by cell") ///
  export("`out'", sheet("No educ mfx") cell(M24) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_long#r.noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2004 - DDD on probability scale") ///
  export("`out'", sheet("No educ mfx") cell(M37) modify)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_NN.dta", clear

gen noboys = 1 if b0g2==1
replace noboys = 0 if (b1g1==1 | b2g0==1)

gen poor = 1 if (wealth_index==1)
replace poor = 0 if (wealth_index==2 | wealth_index==3 | wealth_index==4 | wealth_index==5)

* reverse the education coding so that 4 = no schooling, 1 = most educated
gen education_new = 1 if education==4
replace education_new = 2 if education==3
replace education_new = 3 if education==2
replace education_new = 4 if education==1
* no schooling vs. any schooling
gen noeduc = 1 if (education_new==4)
replace noeduc = 0 if (education_new==1 | education_new==2 | education_new==3)

logit parity_2_3 i.treatment##i.post_long##i.noeduc ///
  i.age_marraige i.v025 i.religion_class i.caste i.poor i.noboys ///
  if pre==1 | post_long==1, vce(robust)

estimates store mfxbase

* marginal effect of treatment in each post_long x noeduc cell
margins post_long#noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - AME of treatment by cell") ///
  export("`out'", sheet("No educ mfx") cell(M47) modify)

estimates restore mfxbase

* the DDD on the probability scale, with a test attached
margins r.post_long#r.noeduc, dydx(treatment) post

etable, cstat(_r_b) cstat(_r_se) showstars showstarsnote ///
  title("Wave 2007 - DDD on probability scale") ///
  export("`out'", sheet("No educ mfx") cell(M60) modify)


log close
