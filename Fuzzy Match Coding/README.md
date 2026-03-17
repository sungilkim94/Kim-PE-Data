# Fuzzy Match Coding Workflow
We provide our fuzzy match workflow used to link PE deal data to AHA annual hospital survey data. This workflow uses natural language processing and inclusive/exclusive keywording to generate string matching keys from both PE deal data sources and AHA data. We implament a dual fuzzy matching algorithm in Stata and Python to link targets in PE deals to hospitals and systems in AHA data. We combine and harmonize fuzzy matching results from both Stata and Python and manually verifiy match candiates to create final linkages between AHA and deal datatbases. 

We provide a generic workflow applicable to all six deal databases used in the paper. While this workflow is designed for matching deal data to AHA hospital data, we hope that this workflow proves useful for researchers intrested in fuzzy matching between deal databases and other medical facility datatabases beyond hospitals. Coding files are numbered for convience to reflect the ordering of files. We summarize the input, output, and goal of each file below.

##
###
