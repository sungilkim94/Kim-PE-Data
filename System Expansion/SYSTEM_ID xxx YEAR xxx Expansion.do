* ============================================================
* System Expansion - Automatic Expansion (Example)
* Purpose: Illustrate per-deal automatic system expansion using
*          the AHA hospital-system link in the year prior to
*          the transaction
* ============================================================

* ---- 0. User-specific paths ----
local user = c(username)
if "`user'" == "[username_1]" {
    global aha_root "C:/Users/[username_1]/[project-folder-AHA]"
    global out_root "C:/Users/[username_1]/[project-folder]"
}
else if "`user'" == "[username_2]" {
    global aha_root "C:/Users/[username_2]/[project-folder-AHA]"
    global out_root "C:/Users/[username_2]/[project-folder]"
}
* Add additional users as needed

* ---- 1. Load AHA data and restrict to deal system and year ----
* For each deal, restrict AHA data to the matched system ID
* and the year prior to the transaction
use "${aha_root}/raw_data/[aha_data].dta", clear

* Example: System AHA ID [SYSID], Deal Year [YEAR]
* drop if sysid != [SYSID]
* drop if year != [YEAR] - 1

* ---- 2. Merge with AHA match keys to verify system name ----
rename id ID
tempfile system_expansion
save `system_expansion'

merge 1:m ID using "${aha_root}/work_data/aha_match_keys.dta", keepusing(level SYSNAME)
drop if _merge == 2

* Retain only hospitals confirmed under the matched system name
* drop if SYSNAME != "[SYSTEM NAME]" & SYSNAME != ""
duplicates drop ID, force
drop _merge

merge 1:1 ID using `system_expansion'

* Flag hospitals not found in match keys (may require manual review)
gen manual_req = 0
replace manual_req = 1 if _merge == 2
drop _merge

* ---- 3. Rename variables to standard output format ----
rename mname        name_aha
rename ID           id_aha
rename level        level_aha
rename sysid        system_id_aha
rename sysname      system_name_aha
drop year SYSNAME

* ---- 4. Add deal-level identifiers and source variables ----
* Populate deal identifiers and source indicators for the relevant
* deal databases. Variables for unused sources are left as empty strings.
* Deal IDs are proprietary and not included here; populate from your
* own licensed data sources.

* Example variables (populate as appropriate):
* gen companyid_[source] = "[COMPANY_ID]"
* gen dealid_[source]    = "[DEAL_ID]"
* gen name_raw_[source]  = "[TARGET_NAME]"
* gen deal_year_combined = [YEAR]
* gen source             = "[PRIMARY_SOURCE]"

* ---- 5. Export per-deal expansion workbook ----
* Output is one workbook per deal for manual review if needed
cd "${out_root}"
export excel using "ID [SYSID] Year [YEAR] Expansion.xlsx", replace firstrow(variables)
