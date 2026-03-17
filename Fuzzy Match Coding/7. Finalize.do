cd "***"
import excel "Deal-AHA-Manualwork-WorkedOn.xlsx", clear firstrow

keep if verified==1

rename id_a id_deal

rename id_b id_aha

drop unique_id_b

rename name_raw_a name_deal

rename name_raw_b name_aha

cd "****"

save "Deal-AHA-Link.dta", replace

export excel "Deal-AHA-Link.xlsx", firstrow(variables) replace
