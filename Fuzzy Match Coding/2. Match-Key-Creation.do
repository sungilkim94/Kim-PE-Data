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



