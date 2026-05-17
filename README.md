# Kim-PE-Data
This repository contains the PE deal dataset produced in **Kim, S., et al. (2026).** *A Practitioner’s Guide to Using Data on Private Equity Hospital Acquisitions*. Health Affairs Scholar. [Paper Link](https://academic.oup.com/healthaffairsscholar/advance-article/doi/10.1093/haschl/qxag071/8626085)

We provide our deal list for download both in Stata .dta and Excel .xlsx form.

The data is presented in deal list form. Each row coresponds to a hospital-deal entry. Hospitals can undergo multiple PE deals and each deal is presented as a row for that hospital. Further details about data construction can be found in the article and appendix.

## Response Form

Please utilize the reponse form if a potential error is identified. We are committed to transparaceny and would welcome any feedback you may have. We have provided this dataset as a public good; we hope this dataset empowers continued thoughtful scholarship on PE's exposure in the US acute care hospital market. 

[Response Form Link](https://docs.google.com/forms/d/e/1FAIpQLSfOj7X_2yxh5k2mOnYxdfvynAHG0QzSLk0sBD1mxzkrbvbzcA/viewform?usp=sharing&ouid=102986527072698648321)

## Variables

We provide a detailed variable description pdf file and sumamrize the variables below:

hospital_id - string, this is a consitent hospital identifer that survives CMS and AHA identifier changes, it can be used to track hospitals across acquisitions.

hospital_cms_id - string, this is the CMS identifer for each hospital gained through use of our improved identifier crosswalks, entries with the identifier "M000000" represent hospitals that have been combined with other CMS identifiers for the purposes of reporting.

deal_id - string, this is a consistent deal identifier that allows for identification of cosntitutient hospitals in each deal

deal_year - numeric, this is the year of each deal

hospital_name - string, this is the name of each hospital

hospital_city - string, this is the city of each hospital

hospital_state - string, this is the state of each hospital

hospital_address - string, this is the address of each hospital

hospital_zip - numeric, this is the zip code of each hospital

deal_system_level - numeric, this is an indicator that = 1 when a deal is at the system level and = 0 when a deal is at the hospital level

system_name - string, this is the name of the system involved in a system deal

deal_type - string, this is the deal type for each deal, values include "LBO", "Growth Equity", and "PIPE"

deal_announcement_date - date, this is the confirmed announcement date for each deal

deal_closing_date - date, this is the confirmed date of completion for each deal

deal_announcement_link - link, this is the link for the source of deal_announcement_date for each deal

deal_closing_link - link, this is the link for the source of deal_closing_date for each deal

deal_exit_date - date, this is the confirmed date of PE exit for each deal

deal_exit_type - string, this is the exit type of PE exit for each deal

deal_exit_link - link, this is the link for the source of deal_exit_type for each deal

hca_flag - numeric, this is an indicator that = 1 when included in HCA PE deal, = 0 when not

## Workflow

Consistent with the paper, this repository documents the fuzzy match thresholds,
rule-based checks, and manual decisions used in our matching process. Appendix A of
the paper contains additional technical details of the workflow.

This repository provides the code and documentation for our matching
 workflow for transparency and reproducibility. Due to data use restrictions, raw
data files from proprietary sources (e.g., Levin Associates, PitchBook, AHA Annual
Survey) cannot be shared. Researchers wishing to replicate this workflow should
obtain access to these sources independently. CMS-relevant data (etc., HCRIS, POS)
are publicly available and can be downloaded directly from the CMS website or NBER.

## Deal List Changes and Update Log

April 23, 2026 - Exit links and exit type classification were added 

May 17, 2026 - Four hospitals were removed after being determined to be non-short-term 
acute care hospitals. The hospital CMS IDs were: 042000, 452049, 032007, and 032008.

