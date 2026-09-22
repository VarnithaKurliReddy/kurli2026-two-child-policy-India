* ---------------------------------------------------------------------------
* Fertility Limits - main results, Mahalanobis matched samples
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
*   DDD margins  - one flat table: the triple difference on the probability
*                  scale for every moderator x wave x period, with SE, z, p
*                  and a 95% CI. Covariates at their reference level.
* ---------------------------------------------------------------------------

local datadir "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/4_final"
local resdir  "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/3_results"
local logdir  "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/9_logs"

cap mkdir "`logdir'"
log using "`logdir'/Mainresults_Mahalanobis_${S_DATE}.log", replace text

local out "`resdir'/Results_Mahalanobis.xlsx"

* ---------------------------------------------------------------------------
* DDD on the probability scale - one row per wave x period, all moderators.
* Collected here and written to the "DDD margins" sheet at the end.
* ---------------------------------------------------------------------------
tempfile dddfile
tempname pf
postfile `pf' int modorder str14 moderator str6 wave str6 period ///
  double(ddd se z p lb ub n) using "`dddfile'", replace


***********************************************************************************
* PART 1A: Basic Model - Short Term
* key coef = treatment#post_short (H0a)
* sheet "Basic ST"
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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
* PART 5C: No sons - DDD on the probability scale, ST
* The logit coefficient on a triple interaction is not the interaction effect in a
* nonlinear model (Ai and Norton 2003), so the model is re-read on the probability
* scale, with every covariate other than treatment, post_short and noboys held
* at its reference level.
*
* margins returns the four cells in the order
*   1: post_short=0 noboys=0   2: post_short=0 noboys=1
*   3: post_short=1 noboys=0    4: post_short=1 noboys=1
* so the DDD is the contrast (+1, -1, -1, +1) across them:
*   [cell4 - cell2] - [cell3 - cell1]
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_short x noboys cell
margins post_short#noboys, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste poor) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (1) ("No sons") ("1996") ("ST") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_short x noboys cell
margins post_short#noboys, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste poor) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (1) ("No sons") ("2004") ("ST") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_short x noboys cell
margins post_short#noboys, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste poor) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (1) ("No sons") ("2007") ("ST") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)


***********************************************************************************
* PART 5D: No sons - DDD on the probability scale, LT
* The logit coefficient on a triple interaction is not the interaction effect in a
* nonlinear model (Ai and Norton 2003), so the model is re-read on the probability
* scale, with every covariate other than treatment, post_long and noboys held
* at its reference level.
*
* margins returns the four cells in the order
*   1: post_long=0 noboys=0   2: post_long=0 noboys=1
*   3: post_long=1 noboys=0    4: post_long=1 noboys=1
* so the DDD is the contrast (+1, -1, -1, +1) across them:
*   [cell4 - cell2] - [cell3 - cell1]
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_long x noboys cell
margins post_long#noboys, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste poor) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (1) ("No sons") ("1996") ("LT") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_long x noboys cell
margins post_long#noboys, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste poor) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (1) ("No sons") ("2004") ("LT") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_long x noboys cell
margins post_long#noboys, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste poor) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (1) ("No sons") ("2007") ("LT") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)


***********************************************************************************
* PART 6C: Poor - DDD on the probability scale, ST
* The logit coefficient on a triple interaction is not the interaction effect in a
* nonlinear model (Ai and Norton 2003), so the model is re-read on the probability
* scale, with every covariate other than treatment, post_short and poor held
* at its reference level.
*
* margins returns the four cells in the order
*   1: post_short=0 poor=0   2: post_short=0 poor=1
*   3: post_short=1 poor=0    4: post_short=1 poor=1
* so the DDD is the contrast (+1, -1, -1, +1) across them:
*   [cell4 - cell2] - [cell3 - cell1]
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_short x poor cell
margins post_short#poor, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (2) ("Poor") ("1996") ("ST") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_short x poor cell
margins post_short#poor, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (2) ("Poor") ("2004") ("ST") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_short x poor cell
margins post_short#poor, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (2) ("Poor") ("2007") ("ST") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)


***********************************************************************************
* PART 6D: Poor - DDD on the probability scale, LT
* The logit coefficient on a triple interaction is not the interaction effect in a
* nonlinear model (Ai and Norton 2003), so the model is re-read on the probability
* scale, with every covariate other than treatment, post_long and poor held
* at its reference level.
*
* margins returns the four cells in the order
*   1: post_long=0 poor=0   2: post_long=0 poor=1
*   3: post_long=1 poor=0    4: post_long=1 poor=1
* so the DDD is the contrast (+1, -1, -1, +1) across them:
*   [cell4 - cell2] - [cell3 - cell1]
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_long x poor cell
margins post_long#poor, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (2) ("Poor") ("1996") ("LT") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_long x poor cell
margins post_long#poor, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (2) ("Poor") ("2004") ("LT") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_long x poor cell
margins post_long#poor, dydx(treatment) ///
  at((base) age_marraige v025 religion_class education_new caste noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (2) ("Poor") ("2007") ("LT") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)


***********************************************************************************
* PART 7C: No schooling - DDD on the probability scale, ST
* The logit coefficient on a triple interaction is not the interaction effect in a
* nonlinear model (Ai and Norton 2003), so the model is re-read on the probability
* scale, with every covariate other than treatment, post_short and noeduc held
* at its reference level.
*
* margins returns the four cells in the order
*   1: post_short=0 noeduc=0   2: post_short=0 noeduc=1
*   3: post_short=1 noeduc=0    4: post_short=1 noeduc=1
* so the DDD is the contrast (+1, -1, -1, +1) across them:
*   [cell4 - cell2] - [cell3 - cell1]
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_short x noeduc cell
margins post_short#noeduc, dydx(treatment) ///
  at((base) age_marraige v025 religion_class caste poor noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (3) ("No schooling") ("1996") ("ST") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_short x noeduc cell
margins post_short#noeduc, dydx(treatment) ///
  at((base) age_marraige v025 religion_class caste poor noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (3) ("No schooling") ("2004") ("ST") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_short x noeduc cell
margins post_short#noeduc, dydx(treatment) ///
  at((base) age_marraige v025 religion_class caste poor noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (3) ("No schooling") ("2007") ("ST") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)


***********************************************************************************
* PART 7D: No schooling - DDD on the probability scale, LT
* The logit coefficient on a triple interaction is not the interaction effect in a
* nonlinear model (Ai and Norton 2003), so the model is re-read on the probability
* scale, with every covariate other than treatment, post_long and noeduc held
* at its reference level.
*
* margins returns the four cells in the order
*   1: post_long=0 noeduc=0   2: post_long=0 noeduc=1
*   3: post_long=1 noeduc=0    4: post_long=1 noeduc=1
* so the DDD is the contrast (+1, -1, -1, +1) across them:
*   [cell4 - cell2] - [cell3 - cell1]
***********************************************************************************

* ------------------------------- Wave 1996 -------------------------------
use "`datadir'/Wave1996_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_long x noeduc cell
margins post_long#noeduc, dydx(treatment) ///
  at((base) age_marraige v025 religion_class caste poor noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (3) ("No schooling") ("1996") ("LT") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2004 -------------------------------
use "`datadir'/Wave2004_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_long x noeduc cell
margins post_long#noeduc, dydx(treatment) ///
  at((base) age_marraige v025 religion_class caste poor noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (3) ("No schooling") ("2004") ("LT") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)

* ------------------------------- Wave 2007 -------------------------------
use "`datadir'/Wave2007_Mahalanobis.dta", clear

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

scalar nobs = e(N)

* effect of treatment in each post_long x noeduc cell
margins post_long#noeduc, dydx(treatment) ///
  at((base) age_marraige v025 religion_class caste poor noboys) post

matrix b = e(b)
matrix V = e(V)

* margins returns one equation per level of treatment, and the base level is
* all structural zeros, so pull out the 1.treatment equation before contrasting
capture matrix bb = b[1, "1.treatment:"]
if _rc == 0 {
  matrix VV = V["1.treatment:", "1.treatment:"]
}
else {
  matrix bb = b
  matrix VV = V
}

matrix c = (1, -1, -1, 1)
matrix bd = c * bb'
matrix vd = c * VV * c'

scalar d  = bd[1,1]
scalar sd = sqrt(vd[1,1])

* fail loudly rather than silently reporting a zero if the layout is not what
* this expects
if sd == 0 {
  display as error "DDD contrast is degenerate - check: matrix list b"
  exit 498
}

post `pf' (3) ("No schooling") ("2007") ("LT") ///
  (d) (sd) (d/sd) (2*normal(-abs(d/sd))) ///
  (d - 1.96*sd) (d + 1.96*sd) (nobs)


***********************************************************************************
* "DDD margins" sheet - one row per moderator x wave x period
***********************************************************************************

postclose `pf'
use "`dddfile'", clear

gen str2 sig = ""
replace sig = "*"  if p < .05
replace sig = "**" if p < .01

gen byte porder = 1 if period=="ST"
replace porder = 2 if period=="LT"
sort modorder wave porder
drop modorder porder

label variable moderator "Moderator"
label variable wave      "Wave"
label variable period    "Period"
label variable ddd       "DDD (prob.)"
label variable se        "Std. err."
label variable z         "z"
label variable p         "p-value"
label variable sig       "Sig."
label variable lb        "95% CI low"
label variable ub        "95% CI high"
label variable n         "N"

order moderator wave period ddd se z p sig lb ub n
format ddd se lb ub %9.4f
format z %9.2f
format p %9.3f

list, clean noobs

export excel using "`out'", sheet("DDD margins") ///
  firstrow(varlabels) sheetreplace

log close
