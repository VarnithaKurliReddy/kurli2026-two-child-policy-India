* Wave 1996
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/1_raw/Census/1991/census_1991.dta" , clear
replace State=strtrim(State)
keep if State=="arunachal pradesh" | State=="assam" | State=="gujarat"| State=="maharashtra" | State=="jammu and kashmir" | ///
 State=="karnataka" | State=="kerala" | State== "manipur" | State=="meghalaya" | State=="mizoram" | State=="nagaland" | State=="punjab" ///
 | State=="sikkim" | State=="tamil nadu" | State=="west bengal" | State=="uttar pradesh" | State=="tripura"| State=="rajasthan" ///
 | State=="haryana" | State=="odisha"  | State=="andhra pradesh" | State=="madhya pradesh"  | State=="himachal pradesh" | State=="bihar" | State=="goa"
 gen treatment=(State=="rajasthan"| State=="haryana" | State=="odisha" | State=="andhra pradesh" | State=="telangana")
 save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/PanelA.dta", replace
 
*Wave 2004
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/1_raw/Census/2001/census_2001.dta" , clear
keep if State=="arunachal pradesh" | State=="assam" | State=="maharashtra" | State=="jammu and kashmir" | State=="karnataka"  ////
| State=="kerala" | State== "manipur" | State=="meghalaya" | State=="mizoram" | State=="nagaland" | State=="punjab" | State=="sikkim"  ////
| State=="tamil nadu" | State=="west bengal" | State=="uttar pradesh" | State=="tripura" | State=="gujarat"  | State=="bihar" | State=="goa" | State=="himachal pradesh" | State=="madhya pradesh"
gen treatment=(State=="maharashtra")
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/PanelB.dta", replace

*Wave2007
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/1_raw/Census/2001/census_2001.dta" , clear
keep if State=="arunachal pradesh" | State=="assam" | State=="gujarat" | State=="jammu and kashmir" | State=="karnataka"  ////
| State=="kerala" | State== "manipur" | State=="meghalaya" | State=="mizoram" | State=="nagaland" | State=="punjab" | State=="sikkim" | State=="himachal pradesh" | State=="madhya pradesh" ////
| State=="tamil nadu" | State=="west bengal" | State=="uttar pradesh" | State=="tripura" | State=="bihar" | State=="goa"
gen treatment=(State=="gujarat")
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/PanelC.dta", replace
