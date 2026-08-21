***********************************************************************************
*PART 1: Restrictions for Short-Term & Longer-Term Policy Effect for NN
***********************************************************************************

*WAVE 1996
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA_NN.dta", clear
drop treatment
destring dob*, replace
gen parity_2_3= 1 if (dob3-dob2 <=60) &  inrange(age_mother_2ndbirth,15,30)
replace parity_2_3=0 if (dob3-dob2>60) | (dob3==. & inrange(age_mother_2ndbirth,15,30))
gen treatment=1 if (State=="Rajasthan"| State=="Haryana" | State=="Odisha" | State=="Andhra Pradesh")
replace treatment=0 if treatment==.
gen post_short=1 if inrange(year_birth2,1996,1999)
replace post_short=0 if inrange(year_birth2,1985,1990)
gen post_long=1 if inrange(year_birth2,2000,2003)
replace post_long=0 if inrange(year_birth2,1985,1990)
gen did_short=treatment*post_short
gen did_long=treatment*post_long
gen pre=1 if inrange(year_birth2,1985,1990)
replace pre=0 if pre==.
keep if inrange(age_mother_2ndbirth,15,30) & (inrange(year_birth2,1985,1990) | inrange(year_birth2,1996,2003))
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/1_wave/Wave1996_NN.dta", replace

*WAVE 2004
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB_NN.dta", clear
drop treatment
destring dob*, replace
gen parity_2_3= 1 if (dob3-dob2 <=60) &  inrange(age_mother_2ndbirth,15,30)
replace parity_2_3=0 if (dob3-dob2>60) | (dob3==. & inrange(age_mother_2ndbirth,15,30))
replace State=strproper(State)
gen treatment=1 if State=="Maharashtra"
replace treatment=0 if treatment==.
gen post_short=1 if inrange(year_birth2,2004,2007)
replace post_short=0 if inrange(year_birth2,1996,1998)
gen post_long=1 if inrange(year_birth2,2008,2011)
replace post_long=0 if inrange(year_birth2,1996,1998)
gen did_short=treatment*post_short
gen did_long=treatment*post_long
gen pre=1 if inrange(year_birth2,1996,1998)
replace pre=0 if pre==.
keep if inrange(age_mother_2ndbirth,15,30) & (inrange(year_birth2,1996,1998) | inrange(year_birth2,2004,2011))
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/1_wave/Wave2004_NN.dta", replace

*WAVE 2007
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC_NN.dta", clear
drop treatment
destring dob*, replace
gen parity_2_3= 1 if (dob3-dob2 <=60) &  inrange(age_mother_2ndbirth,15,30)
replace parity_2_3=0 if (dob3-dob2>60) | (dob3==. & inrange(age_mother_2ndbirth,15,30))
replace State=strproper(State)
gen treatment=1 if State=="Gujarat"
replace treatment=0 if treatment==.
gen post_short=1 if inrange(year_birth2,2007,2010)
replace post_short=0 if inrange(year_birth2,1999,2001) 
gen post_long=1 if inrange(year_birth2,2011,2014)
replace post_long=0 if inrange(year_birth2,1999,2001) 
gen did_short=treatment*post_short
gen did_long=treatment*post_long
gen pre=1 if inrange(year_birth2,1999,2001) 
replace pre=0 if pre==.
keep if inrange(age_mother_2ndbirth,15,30) & (inrange(year_birth2,1999,2001) | inrange(year_birth2,2007,2014))
drop if post_short==. | post_long==.
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/1_wave/Wave2007_NN.dta", replace

***********************************************************************************
*PART 2: Restrictions for Short-Term & Longer-Term Policy Effect for Mahalanobis
***********************************************************************************

*WAVE 1996
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA_Mahalanobis.dta", clear
drop treatment
destring dob*, replace
gen parity_2_3= 1 if (dob3-dob2 <=60) &  inrange(age_mother_2ndbirth,15,30)
replace parity_2_3=0 if (dob3-dob2>60) | (dob3==. & inrange(age_mother_2ndbirth,15,30))
gen treatment=1 if (State=="Rajasthan"| State=="Haryana" | State=="Odisha" | State=="Andhra Pradesh")
replace treatment=0 if treatment==.
gen post_short=1 if inrange(year_birth2,1996,1999)
replace post_short=0 if inrange(year_birth2,1985,1990) 
gen post_long=1 if inrange(year_birth2,2000,2003)
replace post_long=0 if inrange(year_birth2,1985,1990) 
gen did_short=treatment*post_short
gen did_long=treatment*post_long
gen pre=1 if inrange(year_birth2,1985,1990) 
replace pre=0 if pre==.
keep if inrange(age_mother_2ndbirth,15,30) & (inrange(year_birth2,1988,1990) | inrange(year_birth2,1996,2003))
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/1_wave/Wave1996_Mahalanobis.dta", replace

*WAVE 2004
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB_Mahalanobis.dta", clear
drop treatment
destring dob*, replace
gen parity_2_3= 1 if (dob3-dob2 <=60) &  inrange(age_mother_2ndbirth,15,30)
replace parity_2_3=0 if (dob3-dob2>60) | (dob3==. & inrange(age_mother_2ndbirth,15,30))
replace State=strproper(State)
gen treatment=1 if State=="Maharashtra"
replace treatment=0 if treatment==.
gen post_short=1 if inrange(year_birth2,2004,2007)
replace post_short=0 if inrange(year_birth2,1996,1998)
gen post_long=1 if inrange(year_birth2,2008,2011)
replace post_long=0 if inrange(year_birth2,1996,1998)
gen did_short=treatment*post_short
gen did_long=treatment*post_long
gen pre=1 if inrange(year_birth2,1996,1998) 
replace pre=0 if pre==.
keep if inrange(age_mother_2ndbirth,15,30) & (inrange(year_birth2,1996,1998) | inrange(year_birth2,2004,2011))
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/1_wave/Wave2004_Mahalanobis.dta", replace

*WAVE 2007
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC_Mahalanobis.dta", clear
drop treatment
destring dob*, replace
gen parity_2_3= 1 if (dob3-dob2 <=60) &  inrange(age_mother_2ndbirth,15,30)
replace parity_2_3=0 if (dob3-dob2>60) | (dob3==. & inrange(age_mother_2ndbirth,15,30))
replace State=strproper(State)
gen treatment=1 if State=="Gujarat"
replace treatment=0 if treatment==.
gen post_short=1 if inrange(year_birth2,2007,2010)
replace post_short=0 if inrange(year_birth2,1999,2001) 
gen post_long=1 if inrange(year_birth2,2011,2014)
replace post_long=0 if inrange(year_birth2,1999,2001) 
gen did_short=treatment*post_short
gen did_long=treatment*post_long
gen pre=1 if inrange(year_birth2,1999,2001) 
replace pre=0 if pre==.
keep if inrange(age_mother_2ndbirth,15,30) & (inrange(year_birth2,1999,2001) | inrange(year_birth2,2007,2014))
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/1_wave/Wave2007_Mahalanobis.dta", replace

***********************************************************************************
*PART 3: Restrictions for Short-Term & Longer-Term Policy Effect for CEM
***********************************************************************************

*WAVE 1996
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelA_CEM.dta", clear
drop treatment
destring dob*, replace
gen parity_2_3= 1 if (dob3-dob2 <=60) &  inrange(age_mother_2ndbirth,15,30)
replace parity_2_3=0 if (dob3-dob2>60) | (dob3==. & inrange(age_mother_2ndbirth,15,30))
gen treatment=1 if (State=="Rajasthan"| State=="Haryana" | State=="Odisha" | State=="Andhra Pradesh")
replace treatment=0 if treatment==.
gen post_short=1 if inrange(year_birth2,1996,1999)
replace post_short=0 if inrange(year_birth2,1985,1990) 
gen post_long=1 if inrange(year_birth2,2000,2003)
replace post_long=0 if inrange(year_birth2,1985,1990) 
gen did_short=treatment*post_short
gen did_long=treatment*post_long
gen pre=1 if inrange(year_birth2,1985,1990) 
replace pre=0 if pre==.
keep if inrange(age_mother_2ndbirth,15,30) & (inrange(year_birth2,1985,1990) | inrange(year_birth2,1996,2003))
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/1_wave/Wave1996_CEM.dta", replace

*WAVE 2004
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelB_CEM.dta", clear
drop treatment
destring dob*, replace
gen parity_2_3= 1 if (dob3-dob2 <=60) &  inrange(age_mother_2ndbirth,15,30)
replace parity_2_3=0 if (dob3-dob2>60) | (dob3==. & inrange(age_mother_2ndbirth,15,30))
replace State=strproper(State)
gen treatment=1 if State=="Maharashtra"
replace treatment=0 if treatment==.
gen post_short=1 if inrange(year_birth2,2004,2007)
replace post_short=0 if inrange(year_birth2,1996,1998) 
gen post_long=1 if inrange(year_birth2,2008,2011)
replace post_long=0 if inrange(year_birth2,1996,1998) 
gen did_short=treatment*post_short
gen did_long=treatment*post_long
gen pre=1 if inrange(year_birth2,1996,1998) 
replace pre=0 if pre==.
keep if inrange(age_mother_2ndbirth,15,30) & (inrange(year_birth2,1996,1998) | inrange(year_birth2,2004,2011))
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/1_wave/Wave2004_CEM.dta", replace

*WAVE 2007
use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/0_statelevel/merged_PanelC_CEM.dta", clear
drop treatment
destring dob*, replace
gen parity_2_3= 1 if (dob3-dob2 <=60) &  inrange(age_mother_2ndbirth,15,30)
replace parity_2_3=0 if (dob3-dob2>60) | (dob3==. & inrange(age_mother_2ndbirth,15,30))
replace State=strproper(State)
gen treatment=1 if State=="Gujarat"
replace treatment=0 if treatment==.
gen post_short=1 if inrange(year_birth2,2007,2010)
replace post_short=0 if inrange(year_birth2,1999,2001)
gen post_long=1 if inrange(year_birth2,2011,2014)
replace post_long=0 if inrange(year_birth2,1999,2001)
gen did_short=treatment*post_short
gen did_long=treatment*post_long
gen pre=1 if inrange(year_birth2,1999,2001)
replace pre=0 if pre==.
keep if inrange(age_mother_2ndbirth,15,30) & (inrange(year_birth2,1999,2001) | inrange(year_birth2,2007,2014))
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/1_wave/Wave2007_CEM.dta", replace
