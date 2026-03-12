# Kim-PE-Data
This repository contains the PE deal dataset produced in "A Practitioner’s Guide to Using Data on Private Equity Hospital Acquisitions", Kim et al., 2026.

We provide our deal list for download both in Stata .dta and Excel .xlsx form.

The data is presented in deal list form. Each row coresponds to a hospital-deal entry. Hospitals can undergo multiple PE deals and each deal is presented as a row for that hospital. Further details about data construction can be found in the article and appendix.

## Response Form

Please utilize the reponse form if a potential error is identified. We are committed to transparaceny and would welcome any feedback you may have. We have provided this dataset as a public good; we hope this dataset empowers continued thoughtful scholarship on PE's exposure in the US acute care hospital market. 

Link:

## Variables

hospital_id - string, this is a consitent hospital identifer that survives CMS and AHA identifier changes, it can be used to track hospitals across acquisitions.

hospital_cms_id - string, this is the CMS identifer for each hospital gained through use of our improved identifier crosswalks, entries with the identifier "M000000" represent hospitals that have been combined with other CMS identifiers for the purposes of reporting.

deal_id - string, this is a consistent deal identifier that allows for identification of cosntitutient hospitals in each deal

deal_year - numeric, this is the year of each deal

hospital_name - string, this is the name of each hospital

hospital_city - string, this is the city of each hospital

hospital_address - string, this is the address of each hospital

hospital_zip - numeric, this is the zip code of each hospital

deal_system_level - numeric, this is an indicator that = 1 whena  deal is at the system level and = 0 when a deal is at the hospital level

system_name - string, this is the name of the system involved in a system deal

deal_type - string, this is the deal type for each deal, values include "LBO", "Growth Equity", and "PIPE"

deal_announcement_date - date, this is the confirmed announcement date for each deal

deal_closing_date - date, this is the confirmed date of completion for each deal

deal_announcement_link - link, this is the link for the source of deal_announcement_date for each deal

deal_closing_link - link, this is the link for the source of deal_closing_date for each deal

deal_exit_date - date, this is the confirmed date of PE exit for each deal
