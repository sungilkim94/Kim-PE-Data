cd "***"

import delimited "Python-AHA-Deal-Link", clear

gen level = 1 if level_b == "hospital"
replace level = 2 if level_b == "system"
drop level_b
rename level level_b

label define level 1 "hospital" 2 "system"

label values level_b level

tostring id_b, replace

replace match_score = match_score/100

duplicates drop

tostring zip5_b, replace

rename address_a addr_a
rename address_b addr_b

duplicates drop id_a id_b name_raw_a name_raw_b, force

tostring id_a, replace

merge 1:1 id_a id_b name_raw_a name_raw_b using STATA-AHA-Deal-Link

label define match_source 1 "Python" 2 "Stata" 3 "Both" 4 "Unmatched" 5 "All-wrong-match", replace

label values _merge match_source

rename _merge match_source

label variable match_source "Source of Fuzzy Match Results"

label variable level_b "Hospital/System Tag in AHA"

replace state_b = trim(lower(state_b))

gen verified = .

replace verified = 1 if addr_a == addr_b
replace verified = 1 if zip5_a == zip5_b & match_score > 0.95
replace verified = 1 if city_a == city_b & match_score > 0.95


replace verified = 0 if state_a != state_b

destring id_b, replace

replace verified = 0 if mi(verified)

duplicates drop id_a id_b verified, force

rename id_a id
rename name_raw_a pename

merge m:1 id pename using deal_match_keys, keepusing(city state zip addr extracted_target_name extracted_target_name_source )


replace city_a = city if mi(city_a)

replace state_a = state if mi(state_a)

replace addr_a = address if mi(addr_a)

replace zip5_a = zip if mi(zip5_a)


replace match_source = 4 if mi(match_source)

drop _merge

drop if verified == 0

merge m:1 id pename using deal_match_keys, keepusing(city state zip addr extracted_target_name extracted_target_name_source)

label define manual_search 1 "Not Needed" 2 "Needed"
replace _merge = 1 if _merge == 3
replace _merge = 2 if match_source == 4
label values _merge manual_search
rename _merge manual_search
label variable manual_search "Needed means no-match or all-wrong-match from Fuzzy Match"
rename pename_sdc name_raw_a

replace city_a = city if mi(city_a)

replace state_a = state if mi(state_a)

replace addr_a = address if mi(addr_a)

replace zip5_a = zip if mi(zip5_a)

rename id id_a

drop name_trim_a name_trim_b city state zip address

replace match_source = 5 if mi(match_source)

export excel using "Deal-AHA-Manualwork", firstrow(variables) replace


