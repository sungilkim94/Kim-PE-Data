# Fuzzy Match Coding Workflow
We provide our fuzzy match workflow used to link PE deal data to AHA annual hospital survey data. This workflow uses natural language processing and inclusive/exclusive keywording to generate string matching keys from both PE deal data sources and AHA data. We implament a dual fuzzy matching algorithm in Stata and Python to link targets in PE deals to hospitals and systems in AHA data. We combine and harmonize fuzzy matching results from both Stata and Python and manually verifiy match candiates to create final linkages between AHA and deal datatbases. 

We provide a generic workflow applicable to all six deal databases used in the paper. While this workflow is designed for matching deal data to AHA hospital data, we hope that this workflow proves useful for researchers intrested in fuzzy matching between deal databases and other medical facility datatabases beyond hospitals. Coding files are numbered for convience to reflect the ordering of files. We summarize the input, output, and goal of each file below.

## 1. NLP-NER.py
Input: Raw Deal Data

Output: NER "Hospital" Filtered Deal Data

Goal: This file uses natural language processing through named entity recognition, combined with inclusive keyword filtering to filter raw deal data to include only targets that are identified as potenital hospitals or hospital systems.

## 2. Match-Key-Creation.do
Input: NER "Hospital" Filtered Deal Data, Raw AHA Data

Output: Deal Match Keys, AHA Match Keys

Goal: This file creates clean match keys to facilitate fuzzy string matching. The deal match keys implaments exclusive keywording to further filter targets to exclude "hospital irrelevant" entries. 

## 3. Python-Fuzzy-Match.ipynb
Input: Deal Match Keys, AHA Match Keys

Output: Python Fuzzy Match between Deal and AHA

Goal: This file implaments a fuzzy string matching in python using rapidfuzz on target/hospital names between AHA and deal databases.

## 4. Stata-Fuzzy-Match.do
Input: Deal Match Keys, AHA Match Keys

Output: Stata Fuzzy Match between Deal and AHA

Goal: This file implaments a fuzzy string matching in Stata using reclink2 on target/hospital names between AHA and deal databases.

## 5. Fuzzy-Match-Verification.do
Input: Python Fuzzy Match between Deal and AHA, Stata Fuzzy Match between Deal and AHA

Ouput: Unified Fuzzy Match between Deal and AHA

Goal: This file combines fuzzy match results from python and Stata to create a single dataset of candiate matches.

## 6. Deal-AHA-Manualwork-WorkedOn(Example).xlsx

Input: Unified Fuzzy Match between Deal and AHA 

Output: Manually-reviewed individual workbooks 

Goal: Template illustrating the structure of the manual review workbook used to resolve
unmatched or ambiguous cases. Multiple RAs work on this independently as a cross-check
to improve accuracy. Deal Data and AHA IDs are anonymized in this example file.


## 7. Finalize.do
Input: Manually-reviewed individual workbooks  

Output: Final verified matches between Deal and AHA  

Goal: This file finalizes our manual verification of the unified fuzzy match to create a final dataset of confirmed matches between AHA and deal data.
