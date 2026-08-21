use "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/merged_2005_06_all.dta" , clear
gen survey="2005-06"
append using "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/merged_2015_16_all.dta" , force
replace survey="2015-16" if survey==""
append using "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/merged_2019_21_all.dta" , force
replace survey="2019-21" if survey==""
replace state="odisha" if state=="orissa"
replace state="jammu and kashmir" if state=="jammu & kashmir"
save "/Users/varnithakurli/Library/CloudStorage/Dropbox/Boulder/Research/1.Fertility/Fertlity Limits/1_data/3_processed/merged_all_rounds.dta" , replace
