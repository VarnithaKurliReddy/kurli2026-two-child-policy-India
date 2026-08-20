*Wave 1996
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/merged_all_rounds.dta", clear
decode v024, generate(State)
*AP, Rajasthan,Telangana and Haryana are treatment State
replace State = substr(State, strpos(State, " ") + 1, .)
replace State=strtrim(State)
replace State=strlower(State)
replace State="odisha" if State=="orissa"
replace State="madhya pradesh" if State=="chhattisgarh"
replace State="bihar" if State=="jharkhand"
replace State="uttar pradesh" if State=="uttaranchal"
drop if State=="delhi" | State== "jammu and kashmir"
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA.dta", replace
merge m:1 State using "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/1_raw/Census/1991/census_1991.dta"
keep if _merge==3
drop _merge
drop if age_fmarriage==.
drop treatment
gen treatment=(State== "andhra pradesh" | State== "rajasthan" | State== "odisha" | State== "haryana")
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA.dta", replace

use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA.dta", clear
replace State=strlower(State)
keep if State=="tamil nadu" | State=="maharashtra" | State=="madhya pradesh"|  State=="punjab"  | State=="bihar"   ///
 | State=="sikkim"  | State=="uttar pradesh"  | State=="rajasthan" ///
 | State=="haryana" | State=="odisha"  | State=="andhra pradesh" | State=="tripura" | State=="gujarat" 
replace State=strproper(State)
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA_NN.dta", replace

use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA.dta", clear
*Restricting control states to those from 1st stage matching Mahalanobis
replace State=strlower(State)
keep if State=="manipur" | State=="karnataka" | State=="tamil nadu"|  State=="bihar" | State== "punjab" ///
 | State=="uttar pradesh"  | State=="gujarat" | State=="west bengal" | State=="madhya pradesh" | State=="rajasthan" ///
 | State=="haryana" | State=="odisha"  | State=="andhra pradesh" | State=="tripura" 
replace State=strproper(State)
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA_Mahalanobis.dta", replace

use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA.dta", clear
replace State=strlower(State)
keep if State=="tamil nadu" | State=="nagaland" | State=="manipur"|  State=="bihar" | State=="uttar pradesh" | ///
 State=="gujarat" | State=="rajasthan" | State=="maharashtra" ///
 | State=="haryana" | State=="odisha"  | State=="andhra pradesh" 

replace State=strproper(State)
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA_CEM.dta", replace



*Wave 2004
*Merge Maharashtra with census 2001
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/merged_all_rounds.dta", clear
decode v024, generate(State)
*AP, Rajasthan,Telangana and Haryana are treatment State
replace State = substr(State, strpos(State, " ") + 1, .)
replace State=strtrim(State)
replace State=strlower(State)
replace State="odisha" if State=="orissa"
replace State="madhya pradesh" if State=="chhattisgarh"
replace State="bihar" if State=="jharkhand"
replace State="uttar pradesh" if State=="uttaranchal"
drop if State=="delhi" | State== "andhra pradesh" | State== "rajasthan" | State== "odisha" | State== "haryana"
*Keep Maharashtra and Other controls
*Union territories, Andhra Prdaesh, Haryana, Rajasthan, Odisha

save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB.dta", replace
merge m:1 State using "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/1_raw/Census/2001/census_2001.dta"
keep if _merge==3
drop _merge
drop treatment
gen treatment=(State=="maharashtra")
drop if age_fmarriage==.
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB.dta", replace

use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB.dta", clear
keep if State=="tamil nadu" | State=="manipur" | State=="maharashtra" | State=="himachal pradesh"
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB_NN.dta", replace

use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB.dta", clear
keep if State=="karnataka" | State=="meghalaya" | State=="maharashtra" | State=="manipur"
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB_Mahalanobis.dta", replace

use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB.dta", clear
keep if State=="himachal pradesh" | State=="manipur" | State=="karnataka" | State=="maharashtra"
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB_CEM.dta", replace



*Wave 2007
*Merge Gujarat Treatment  Census 2001
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/merged_all_rounds.dta", clear
decode v024, generate(State)
replace State = substr(State, strpos(State, " ") + 1, .)
*AP, Rajasthan,Telangana and Haryana are treatment State
replace State=strtrim(State)
replace State=strlower(State)
replace State="odisha" if State=="orissa"
replace State="madhya pradesh" if State=="chhattisgarh"
replace State="bihar" if State=="jharkhand"
replace State="uttar pradesh" if State=="uttaranchal"
 drop if State=="delhi" | State== "andhra pradesh" | State== "rajasthan" | State== "odisha" | State== "haryana" | State=="maharashtra"
*Keep Gujarat and Other controls
*we don't include maharashtra, Union territories, Andhra Prdaesh, Haryana, Rajasthan, Odisha
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC.dta", replace
merge m:1 State using "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/1_raw/Census/2001/census_2001.dta"
keep if _merge==3
drop _merge
drop treatment
gen treatment=(State=="gujarat")
drop if age_fmarriage==.
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC.dta", replace


use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC.dta", clear
keep if State=="tamil nadu" | State=="jammu and kashmir" | State=="arunachal pradesh" | State=="gujarat"
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC_NN.dta", replace
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC.dta", clear
keep if State=="karnataka" | State=="madhya pradesh" | State=="tamil nadu" | State=="gujarat"
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC_Mahalanobis.dta", replace

use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC.dta", clear
keep if  State=="manipur" |  State=="tamil nadu" | State=="karnataka" | State=="gujarat"
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC_CEM.dta", replace



