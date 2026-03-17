cd "***"

clear all
set more off

*---------------------------------------------------------------
* Step 1: Prepare PE  data
*---------------------------------------------------------------
use deal_match_keys, clear
generate idusing = _n
tempfile pemaster
save `pemaster'

*---------------------------------------------------------------
* Step 2: Prepare AHA data
*---------------------------------------------------------------
use aha_match_keys, clear
generate idmaster=_n

*---------------------------------------------------------------
* Step 3: Fuzzy match on name_trim
*---------------------------------------------------------------
reclink2 name_trim using `pemaster', ///
    idmaster(idmaster) idusing(idusing) ///
    gen(match_score) ///
    minscore(0)


duplicates drop id peid name_trim Uname_trim, force

rename name_trim name_trim_b
rename Uname_trim name_trim_a
rename id id_b
rename peid id_a
rename aha_unique_id unique_id_b

rename name_raw name_raw_b
rename pename name_raw_a
rename level level_b
rename city city_b
rename pecity city_a
rename state state_b
rename pestate state_a
rename zip5 zip5_b
rename pezip zip5_a
rename addr addr_b
rename peaddress addr_a

keep name_trim_b name_trim_a id_b id_a unique_id_b name_raw_b name_raw_a level_b city_b city_a zip5_a zip5_b addr_a addr_b state_b state_a match_score 

drop if match_score == 0

replace state_b = trim(lower(state_b))

keep if state_a == state_b

save "STATA-AHA-Deal-Link", replace
