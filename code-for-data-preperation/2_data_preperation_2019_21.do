* ******************************************************************** *
   * ******************************************************************** *
   *                                                                      *
   *                                                                      * 
   *                                                                      *                      
   *                     MASTER DO_FILE                                   *
   *                                                                      *
   * ******************************************************************** *
   * ******************************************************************** *
       /*
       ** PURPOSE: The purpose of the project is to clean the individual record data from DHS 2019-2020
       ** OUTLINE:      
                        PART 1: Load the Birth Record and trim dataset
                        
                        PART 2: Load the Household Dataset and trim it
						
                        PART 3: Generate Relavant Varaibles
						
                        PART 4: Regression analysis

       ** IDS VAR:      list_ID_var_here         

       ** NOTES:

       ** WRITEN BY:    Varnitha Kurli
	   
	   

       ** Last date modified: Sept 3, 2023

*/
***********************************************************************************
*PART 1: Load individual record data and trim it
***********************************************************************************
cd "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/1_raw/2019-2021/"
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/1_raw/2019-2021/Birth Record/IABR7DFL.DTA", replace
keep v000 v001 v002 v003 v005 v006 v007 v008 v201 v212 b0 b1 b4 b5 bord caseid b2 b3 s361 s356 v107 v011 v012 v013 v024 v025 sdist v020 v026 s314c
tostring v001 v002 v003, replace
replace v001="00"+v001 if length(v001)==3
replace v001="0"+v001 if length(v001)==4
replace v002="0"+v002 if length(v002)==1
replace v003="0"+v003 if length(v003)==1
gen motherid= v000+ v001+v002+v003
gen hhid=v000+ v001+v002
replace caseid=strtrim(caseid)
*reshape the data from long to wide
ren b0 twin
ren b1 month_birth
ren b2 year_birth
ren b3 dob
ren b4 sex_child
ren b5 child_alive
ren v107 education_level
ren s361 met_health_worker_3months
ren s314c age_fmarriage
label define v020  0 "All woman sample" 1 "Ever married sample", replace //
lab val v020 v020 
decode v024, gen(state)
label define v025    1 "Urban" 2 "Rural", replace
lab val v025 v025
label define v026     0 "Capital, large city" 1 "Small city" 2 "Town" 3 "Countryside", replace
lab val v026 v026
reshape wide twin month_birth year_birth dob sex_child child_alive,i(motherid) j(bord)
*keep women with at least two children 
ren v201 ceb
keep if ceb>=2
*keep only those women that second birth by 2014. Why do we do this-since the survey is done in 2019. We want to give a woman atleast 5 years of time to have child 3.
keep if year_birth2<=2014
*drop women who had twins. Twins are unplanned for. Although the Fertility Limit applies to them. Yet,It is not reflective of actual decision making of the household. 
drop if twin1==1 |twin2==1 |twin3==1
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/2_interim/trimmed_mother_2019_21_all.dta", replace
***********************************************************************************
*PART 2: Load the household dataset and trim dataset
***********************************************************************************
use hhid hv000 hv001 hv002 hv003 sh49 sh47 sv270us sv270rs  using  "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/1_raw/2019-2021/Household Record/IAHR7DFL.DTA", clear
tostring  hv000 hv001 hv002 hv003, replace
replace hv001="00"+hv001 if length(hv001)==3
replace hv001="0"+hv001 if length(hv001)==4
replace hv002="0"+hv002 if length(hv002)==1
drop hhid
gen hhid=hv000+ hv001+hv002
ren sh49 schedule_caste
ren sh47 religion
replace sv270rs=0 if sv270rs==.
replace sv270us=0 if sv270us==.
gen wealth_index=sv270us+sv270rs
label define wealth_index 1 "poorest" 2 "poorer" 3 "middle" 4 "richer" 5 "richest", replace
label val wealth_index wealth_index
duplicates drop hhid, force
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/2_interim/trimmed_household_2019_21_all.dta", replace

***********************************************************************************
* Merge Household and Mother Records
***********************************************************************************
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/2_interim/trimmed_mother_2019_21_all.dta", clear
merge m:1 hhid using "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/2_interim/trimmed_household_2019_21_all.dta"
keep if _merge==3
drop _merge
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/2_interim/trimmed_2019_21_all.dta", replace

***********************************************************************************
*PART 3: Relevant Variables
***********************************************************************************
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/2_interim/trimmed_2019_21_all.dta", clear
*whether the women had a third child
*age of mother at second birth
gen age_mother_2ndbirth=(dob2-v011)/12
replace age_mother_2ndbirth=trunc(age_mother_2ndbirth)
gen age_mother_cohort_2ndbirth=(dob2-v011)/60
replace age_mother_cohort_2ndbirth=trunc(age_mother_cohort_2ndbirth)
forvalues i=1/10 { 
local j = `i'+1
gen diff_`i'= (dob`j')-(dob`i')
}

tab diff_2
*First figure out how many twins
*There are 2211 observations for which diff_2==0. These are all twins
edit twin* dob* child_alive*  if diff_2==0

*How many observations than have gap greater than 60 months.(15861 observations between 3rd and 2nd child) We need to compare with age of child variables to see if data entry was correct. 
edit diff_* dob* child_alive*  if diff_2>60 & diff_2!=.

gen hadbirth3=1 if ceb>=3
replace hadbirth3=0 if ceb==2
replace hadbirth3=. if ceb<2
*** 2nd child was born  in the period (<60 months before survey) We have to omit ALL women whose 2nd child was born in that period, including those who had a 3rd child.
replace hadbirth3=. if ceb>=2 & (v008-dob2<60)
replace hadbirth3=0 if hadbirth3==1 & diff_2>=60

*Age at first Marraige
gen age_marraige=1 if age_fmarriage>19
replace age_marraige=2 if inrange(age_fmarriage, 15,19)
replace age_marraige=3 if age_fmarriage<15

*Education
replace education_level=0 if education_level==.
gen education=1 if education_level==0 
replace education=2 if inrange(education_level,1,4)
replace education=3 if education_level==5
replace education=4 if inrange(education_level,6,9)
replace education=5 if education_level>9

*Sibling composition
*sibling composition for parity progression 2 to 3
gen b0g2=.
replace b0g2=1 if sex_child1==2 & sex_child2==2
replace b0g2=0 if b0g2==. & ceb>=2
tab b0g2

gen b1g1=.
replace b1g1=1 if sex_child1==1 & sex_child2==2
replace b1g1=1 if sex_child1==2 & sex_child2==1
replace b1g1=0 if b1g1==. & ceb>=2
tab b1g1


gen b2g0=.
replace b2g0=1 if sex_child1==1 & sex_child2==1
replace b2g0=0 if b2g0==. & ceb>=2
tab b2g0

gen sibling_composition=1 if b2g0==1
replace sibling_composition=2 if b1g1==1
replace sibling_composition=3 if b0g2==1


drop if hadbirth3==.


gen child_survival=1 if child_alive1==0 & child_alive2==0
replace child_survival=2 if (child_alive1==0 & child_alive2==1) | (child_alive1==1 & child_alive2==0)
replace child_survival=3 if (child_alive1==1 & child_alive2==1) 

gen religion_class=1 if religion==1
replace religion_class=2 if religion==2
replace religion_class=3 if religion==3
replace religion_class=4 if religion>3

gen caste=1 if schedule_caste>3
replace caste=2 if schedule_caste==1
replace caste=3 if schedule_caste==2
replace caste=4 if schedule_caste==3

label define caste 1 "forward caste"  2 "schedule caste" 3 "schedule tribe" 4 "backward caste" , replace 
lab val caste caste

replace state="andhra pradesh" if state=="telangana"
replace state="madhya pradesh" if state=="chhattisgarh"
replace state="bihar" if state=="jharkhand"
replace state="uttar pradesh" if state=="uttaranchal"

save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/merged_2019_21_all.dta", replace


