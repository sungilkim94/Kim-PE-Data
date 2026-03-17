* Import results from NLP NER 
import excel "C:\***\Deal_NER.xlsx", clear firstrow

keep if ner_flag==1

*-----------------------------------------------------------------
* Excluisve Keyword Filtering*
* ---------------------------------------------------------------
* Make company names lowercase (for consistent matching)

gen companyname_clean = trim(lower(company_name))

* Flag any rows that contain exclusion keywords

gen exclude_flag = 0

local keywords dental dentist dentists orthodontics orthodontist endodontic ///
endodontics periodontics implant prosthodontics ophthalmology optometry ///
optometrist eyecare imaging image radiology ///
radiologist radiologists x-ray ultrasound mammography screening ///
diagnostic pharmacy laboratory ///
toxicology audiology otolaryngology orthopedic ///
orthopedics prosthetics prosthesis orthotic orthotics ///
ankle podiatry podiatrist dermatology dermatologist dermatologists ///
dermatologic skincare acne cosmetic aesthetics aesthetic beauty laser autism ///
psychologist gynecology ///
obstetrics reproductive fertility surrogacy pediatrics pediatrician ///
adolescent geriatrics cardiology nephrology urology gastroenterology ///
endocrinology immunology digestive renal kidney anesthesia anesthesiology ///
anesthesiologists consultants consultant veterinary animal animals ///
occupational hair skin allergy infusion dialysis ///
therapeutic therapeutics therapy ///
oncology

foreach word in `keywords' {
    replace exclude_flag = 1 if regexm(companyname_clean, "`word'")
}

drop if exclude_flag == 1

* ---------------------------------------------------
* Manual Extension and Standardization of Multi-Facility Acquisition Records
* ---------------------------------------------------

gen extracted_target_name = company_name

gen extracted_target_name_source = .

label define extracted_target_name_source 1 "companyname" 2 "description" 3 "outside database(e.g, Google, etc)" 4 "no available info"

label values extracted_target_name_source extracted_target_name_source

replace extracted_target_name_source = 1

*Expand multi-facility but partial system acqusitions using deal descriptions and external sources. 
*The goal of this step is to create consistent company name strings at the hospital level for these acutisions.

* ------------------------------------------------------------
* Match Key Creation
* ------------------------------------------------------------
*--- basic IDs and names ----------------------------------
gen pename   = company_name
gen peid       = company_id
gen pename_trim  = trim(lower(pename))     // lowercase + trim
duplicates drop pename_trim peid , force

*--- location ----------------------------------------------------
gen pestate = trim(lower(company_state))
gen pecity  = trim(lower(company_city))
gen pezip = company_zip
gen peaddress = company_addresss

gen id = peid

gen name_raw  = extracted_target_name

gen name_trim = pename_trim

gen state = pestate
gen city = pecity
gen zip = pezip
gen address = peaddress

duplicates drop id name_trim, force

keep pename peid pename_trim pestate pecity pezip peaddress name_raw name_trim id state city zip address extracted_target_name_source company_name deal_description firm_about

cd "***"

save "deal_match_keys", replace

******************************************************************************************************************************
* AHA Match Key Creation

use "AHA.dta", clear

/***********************************************************************
* 2. Hospital-level block         *
***********************************************************************/

*--- basic IDs and names -------------------------------------------------
gen hospname_aha       = MNAME
replace hospname_aha   = mname if mi(hospname_aha)
gen hospid_aha         = ID
replace hospid_aha     = id if mi(hospid_aha)
gen hospname_aha_trim  = trim(lower(hospname_aha))     // lowercase + trim
duplicates drop hospname_aha_trim hospid_aha, force    

*--- ZIP: strip blanks, pad to 5, keep +4 in separate field -------------
gen hospzip_aha  = MLOCZIP
replace hospzip_aha = mloczip if mi(hospzip_aha)
replace hospzip_aha  = strtrim(hospzip_aha)                 // drop blanks
gen hospzip5_aha = substr(hospzip_aha,1,5)                  // first 5 only
replace hospzip5_aha = substr("00000"+hospzip_aha,-5,5) if strlen(hospzip_aha)<5

*--- address / city ------------------------------------------------------
gen hospaddr_aha = trim(lower(MLOCADDR))
replace hospaddr_aha = trim(lower(mlocaddr)) if mi(hospaddr_aha)
gen hospcity_aha = trim(lower(MLOCCITY))
replace hospcity_aha = trim(lower(mloccity)) if mi(hospcity_aha)

*--- state code → full name (numeric codes) ------------------------------
gen hospstate_aha = MLOCSTCD
tostring hospstate_aha, replace
replace hospstate_aha = mlocstcd if hospstate_aha == "."

* numeric territory/state codes  ➜  full names    (3–95 are AHA's codes)
replace hospstate_aha = "Marshall Islands"            if hospstate_aha == "3"
replace hospstate_aha = "Puerto Rico"                 if hospstate_aha == "4"
replace hospstate_aha = "Virgin Islands"              if hospstate_aha == "5"
replace hospstate_aha = "Guam"                        if hospstate_aha == "6"
replace hospstate_aha = "American Samoa"              if hospstate_aha == "7"
replace hospstate_aha = "Northern Mariana Islands"    if hospstate_aha == "8"

replace hospstate_aha = "Maine"                       if hospstate_aha == "11"
replace hospstate_aha = "New Hampshire"               if hospstate_aha == "12"
replace hospstate_aha = "Vermont"                     if hospstate_aha == "13"
replace hospstate_aha = "Massachusetts"               if hospstate_aha == "14"
replace hospstate_aha = "Rhode Island"                if hospstate_aha == "15"
replace hospstate_aha = "Connecticut"                 if hospstate_aha == "16"

replace hospstate_aha = "New York"                    if hospstate_aha == "21"
replace hospstate_aha = "New Jersey"                  if hospstate_aha == "22"
replace hospstate_aha = "Pennsylvania"                if hospstate_aha == "23"

replace hospstate_aha = "Delaware"                    if hospstate_aha == "31"
replace hospstate_aha = "Maryland"                    if hospstate_aha == "32"
replace hospstate_aha = "District of Columbia"        if hospstate_aha == "33"
replace hospstate_aha = "Virginia"                    if hospstate_aha == "34"
replace hospstate_aha = "West Virginia"               if hospstate_aha == "35"
replace hospstate_aha = "North Carolina"              if hospstate_aha == "36"
replace hospstate_aha = "South Carolina"              if hospstate_aha == "37"
replace hospstate_aha = "Georgia"                     if hospstate_aha == "38"
replace hospstate_aha = "Florida"                     if hospstate_aha == "39"

replace hospstate_aha = "Ohio"                        if hospstate_aha == "41"
replace hospstate_aha = "Indiana"                     if hospstate_aha == "42"
replace hospstate_aha = "Illinois"                    if hospstate_aha == "43"
replace hospstate_aha = "Michigan"                    if hospstate_aha == "44"
replace hospstate_aha = "Wisconsin"                   if hospstate_aha == "45"

replace hospstate_aha = "Kentucky"                    if hospstate_aha == "51"
replace hospstate_aha = "Tennessee"                   if hospstate_aha == "52"
replace hospstate_aha = "Alabama"                     if hospstate_aha == "53"
replace hospstate_aha = "Mississippi"                 if hospstate_aha == "54"
replace hospstate_aha = "Arkansas"                    if hospstate_aha == "55"
replace hospstate_aha = "Louisiana"                   if hospstate_aha == "56"
replace hospstate_aha = "Oklahoma"                    if hospstate_aha == "57"
replace hospstate_aha = "Texas"                       if hospstate_aha == "58"

replace hospstate_aha = "Minnesota"                   if hospstate_aha == "61"
replace hospstate_aha = "Iowa"                        if hospstate_aha == "62"
replace hospstate_aha = "Missouri"                    if hospstate_aha == "63"
replace hospstate_aha = "North Dakota"                if hospstate_aha == "64"
replace hospstate_aha = "South Dakota"                if hospstate_aha == "65"
replace hospstate_aha = "Nebraska"                    if hospstate_aha == "66"
replace hospstate_aha = "Kansas"                      if hospstate_aha == "67"

replace hospstate_aha = "Arkansas"                    if hospstate_aha == "71"
replace hospstate_aha = "Louisiana"                   if hospstate_aha == "72"
replace hospstate_aha = "Oklahoma"                    if hospstate_aha == "73"
replace hospstate_aha = "Texas"                       if hospstate_aha == "74"

replace hospstate_aha = "Montana"                     if hospstate_aha == "81"
replace hospstate_aha = "Idaho"                       if hospstate_aha == "82"
replace hospstate_aha = "Wyoming"                     if hospstate_aha == "83"
replace hospstate_aha = "Colorado"                    if hospstate_aha == "84"
replace hospstate_aha = "New Mexico"                  if hospstate_aha == "85"
replace hospstate_aha = "Arizona"                     if hospstate_aha == "86"
replace hospstate_aha = "Utah"                        if hospstate_aha == "87"
replace hospstate_aha = "Nevada"                      if hospstate_aha == "88"

replace hospstate_aha = "Washington"                  if hospstate_aha == "91"
replace hospstate_aha = "Oregon"                      if hospstate_aha == "92"
replace hospstate_aha = "California"                  if hospstate_aha == "93"
replace hospstate_aha = "Alaska"                      if hospstate_aha == "94"
replace hospstate_aha = "Hawaii"                      if hospstate_aha == "95"


/***********************************************************************
* 2. System-level block (same cleaning steps, separate tempfile)        *
***********************************************************************/
preserve

keep SYSID SYSNAME SYSADDR SYSCITY SYSST SYSZIP sysid sysname sysaddr syscity sysst syszip

*--- IDs & names --------------------------------------------------------
gen sysname_aha      = SYSNAME
replace sysname_aha = sysname if mi(sysname_aha)
gen sysid_aha        = SYSID
tostring sysid_aha, replace
replace sysid_aha = sysid if mi(sysid_aha)
gen sysname_aha_trim = trim(lower(sysname_aha))
duplicates drop sysname_aha_trim sysid_aha, force   

*--- ZIPs ---------------------------------------------------------------
gen syszip_aha  = SYSZIP
replace syszip_aha = syszip if mi(syszip_aha)
replace syszip_aha  = strtrim(syszip_aha)
gen syszip5_aha = substr(syszip_aha,1,5)
replace syszip5_aha = substr("00000"+syszip_aha,-5,5) if strlen(syszip_aha)<5

*--- address / city / state --------------------------------------------
gen sysaddr_aha = trim(lower(SYSADDR))
replace sysaddr_aha = trim(lower(sysaddr)) if mi(sysaddr_aha)
gen syscity_aha = trim(lower(SYSCITY))
replace syscity_aha = trim(lower(syscity)) if mi(syscity_aha)

gen sysstate_aha = SYSST
replace sysstate_aha = sysst if sysstate_aha == ""

* two-letter postal codes  ➜  full names (PR → Puerto Rico, etc.)
replace sysstate_aha = "Alabama"                   if trim(sysstate_aha) == "AL"
replace sysstate_aha = "Alaska"                    if trim(sysstate_aha) == "AK"
replace sysstate_aha = "Arizona"                   if trim(sysstate_aha) == "AZ"
replace sysstate_aha = "Arkansas"                  if trim(sysstate_aha) == "AR"
replace sysstate_aha = "California"                if trim(sysstate_aha) == "CA"
replace sysstate_aha = "Colorado"                  if trim(sysstate_aha) == "CO"
replace sysstate_aha = "Connecticut"               if trim(sysstate_aha) == "CT"
replace sysstate_aha = "Delaware"                  if trim(sysstate_aha) == "DE"
replace sysstate_aha = "District of Columbia"      if trim(sysstate_aha) == "DC"
replace sysstate_aha = "Florida"                   if trim(sysstate_aha) == "FL"
replace sysstate_aha = "Georgia"                   if trim(sysstate_aha) == "GA"
replace sysstate_aha = "Hawaii"                    if trim(sysstate_aha) == "HI"
replace sysstate_aha = "Idaho"                     if trim(sysstate_aha) == "ID"
replace sysstate_aha = "Illinois"                  if trim(sysstate_aha) == "IL"
replace sysstate_aha = "Indiana"                   if trim(sysstate_aha) == "IN"
replace sysstate_aha = "Iowa"                      if trim(sysstate_aha) == "IA"
replace sysstate_aha = "Kansas"                    if trim(sysstate_aha) == "KS"
replace sysstate_aha = "Kentucky"                  if trim(sysstate_aha) == "KY"
replace sysstate_aha = "Louisiana"                 if trim(sysstate_aha) == "LA"
replace sysstate_aha = "Maine"                     if trim(sysstate_aha) == "ME"
replace sysstate_aha = "Maryland"                  if trim(sysstate_aha) == "MD"
replace sysstate_aha = "Massachusetts"             if trim(sysstate_aha) == "MA"
replace sysstate_aha = "Michigan"                  if trim(sysstate_aha) == "MI"
replace sysstate_aha = "Minnesota"                 if trim(sysstate_aha) == "MN"
replace sysstate_aha = "Mississippi"               if trim(sysstate_aha) == "MS"
replace sysstate_aha = "Missouri"                  if trim(sysstate_aha) == "MO"
replace sysstate_aha = "Montana"                   if trim(sysstate_aha) == "MT"
replace sysstate_aha = "Nebraska"                  if trim(sysstate_aha) == "NE"
replace sysstate_aha = "Nevada"                    if trim(sysstate_aha) == "NV"
replace sysstate_aha = "New Hampshire"             if trim(sysstate_aha) == "NH"
replace sysstate_aha = "New Jersey"                if trim(sysstate_aha) == "NJ"
replace sysstate_aha = "New Mexico"                if trim(sysstate_aha) == "NM"
replace sysstate_aha = "New York"                  if trim(sysstate_aha) == "NY"
replace sysstate_aha = "North Carolina"            if trim(sysstate_aha) == "NC"
replace sysstate_aha = "North Dakota"              if trim(sysstate_aha) == "ND"
replace sysstate_aha = "Ohio"                      if trim(sysstate_aha) == "OH"
replace sysstate_aha = "Oklahoma"                  if trim(sysstate_aha) == "OK"
replace sysstate_aha = "Oregon"                    if trim(sysstate_aha) == "OR"
replace sysstate_aha = "Pennsylvania"              if trim(sysstate_aha) == "PA"
replace sysstate_aha = "Rhode Island"              if trim(sysstate_aha) == "RI"
replace sysstate_aha = "South Carolina"            if trim(sysstate_aha) == "SC"
replace sysstate_aha = "South Dakota"              if trim(sysstate_aha) == "SD"
replace sysstate_aha = "Tennessee"                 if trim(sysstate_aha) == "TN"
replace sysstate_aha = "Texas"                     if trim(sysstate_aha) == "TX"
replace sysstate_aha = "Utah"                      if trim(sysstate_aha) == "UT"
replace sysstate_aha = "Vermont"                   if trim(sysstate_aha) == "VT"
replace sysstate_aha = "Virginia"                  if trim(sysstate_aha) == "VA"
replace sysstate_aha = "Washington"                if trim(sysstate_aha) == "WA"
replace sysstate_aha = "West Virginia"             if trim(sysstate_aha) == "WV"
replace sysstate_aha = "Wisconsin"                 if trim(sysstate_aha) == "WI"
replace sysstate_aha = "Wyoming"                   if trim(sysstate_aha) == "WY"
replace sysstate_aha = "Puerto Rico"               if trim(sysstate_aha) == "PR"
replace sysstate_aha = "Virgin Islands"            if trim(sysstate_aha) == "VI"
replace sysstate_aha = "Guam"                      if trim(sysstate_aha) == "GU"
replace sysstate_aha = "American Samoa"            if trim(sysstate_aha) == "AS"
replace sysstate_aha = "Northern Mariana Islands"  if trim(sysstate_aha) == "MP"
replace sysstate_aha = "Marshall Islands"          if trim(sysstate_aha) == "MH"

* mark as system-level and store to a temporary file --------------------
label define level 1 "hospital" 2 "system"
gen level = 2
label values level level

tempfile sys
save `sys', replace
restore


/***********************************************************************
* 3. Append system block below hospital block & merge info             *
***********************************************************************/
append using `sys'

* keep only variables we need for matching -----------------------------
keep hospname_aha hospname_aha_trim hospid_aha hospzip_aha hospzip5_aha hospaddr_aha hospcity_aha hospstate_aha ///
     sysname_aha sysname_aha_trim sysid_aha syszip_aha syszip5_aha sysaddr_aha syscity_aha sysstate_aha ///
     level ///
     MNAME ID MLOCZIP MLOCADDR MLOCCITY MLOCSTCD SYSID SYSNAME SYSADDR SYSCITY SYSST SYSZIP

replace level = 1 if level == .                   // default block = hospital

* combine hospital & system fields (hospital first; fallback = system) --
gen name_raw  = hospname_aha
replace name_raw = sysname_aha  if mi(name_raw)

gen name_trim = hospname_aha_trim
replace name_trim = sysname_aha_trim if mi(name_trim)

gen id = hospid_aha
tostring sysid_aha, replace
replace id = sysid_aha if mi(id)

gen addr = hospaddr_aha
replace addr = sysaddr_aha if mi(addr)

gen city = hospcity_aha
replace city = syscity_aha if mi(city)

gen state = hospstate_aha
replace state = sysstate_aha if mi(state)

gen zip = hospzip_aha
replace zip = syszip_aha if mi(zip)

gen zip5 = hospzip5_aha
replace zip5 = syszip5_aha if mi(zip5)

duplicates drop id name_trim, force             

drop if id == "."

bysort id (id): gen obs_num = _n

tostring id, replace force
tostring obs_num, replace

gen aha_unique_id = id + "-" + obs_num

cd "****"

save "aha_match_keys.dta", replace


