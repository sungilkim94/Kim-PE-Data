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


## Notes for Practitioners

**Note 1: Dataset-specific quirks**  
Each deal database has unique characteristics that require tailored preprocessing
before fuzzy matching. The generic workflow provided here may need to be adapted
accordingly. For example:

- **Levin**: Many deal records describe multi-hospital acquisitions using aggregated
  language (e.g., "5 HCA Hospitals", "3 Chicago Hospitals") rather than individual
  hospital names. Additionally, Levin does not include a direct PE-deal indicator,
  requiring extra steps for PE-deal identification and individual hospital name
  extraction prior to matching.
- **PitchBook**: The "Clinical/Outpatient" industry classification in PitchBook
  captures many non-hospital entities (e.g., imaging centers, outpatient clinics).
  Even with our extensive keyword filtering, some non-hospital entities persists
  through the matching process and must be filitered out manually during the final
  verification step.

Researchers applying this workflow to other deal databases should expect similar
dataset-specific adjustments.

**Note 2: Manual search for unmatched and rejected cases**  
Our manual verification goes beyond reviewing fuzzy match candidates. For any deal
entity that either (a) received no candidate match from the algorithm, or (b) received
a candidate match that was subsequently rejected during manual review, we conducted
an additional manual search to attempt to identify the correct AHA hospital link —
provided we were sufficiently confident the entity was a hospital. This second-pass
manual effort is an important part of achieving high match rates and should be
factored into the workflow when applying it to new data.

**Note 3: Match key standardization**  
Standardizing name strings before fuzzy matching can meaningfully improve algorithm
performance. Useful transformations include expanding common abbreviations to their
full form (e.g., "St." → "Saint", "Hosp" → "Hospital") and removing common suffixes
and legal entity descriptors (e.g., "LLC", "Corp", "Inc"). For example, "St. Vincent
Hosp" and "St. Vincent Hospital" will match poorly without normalization, and "HCA,
LLC" and "HCA" may fail to link without suffix removal.

However, removing too many general words can hurt performance by stripping meaningful
distinguishing information from names. Researchers should experiment with different
standardization rules on their own data to find the approach that works best for
their specific matching context.
