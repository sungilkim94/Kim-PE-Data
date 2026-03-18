# System Expansion

To obtain a hospital-level deal universe, we expand system-level deals into
their constituent hospitals. This process proceeds in two stages.

## Stage 1: Automatic Expansion
Automatic expansion is performed using the AHA hospital-system link in the year prior
to the deal. All hospitals listed under the matched system in that AHA vintage
are included as constituent hospitals of the deal. This is performed on a per-deal
basis, producing a workbook for each deal that facilitates any further manual
adjustment needed in Stage 2.

## Stage 2: Manual Expansion
Manual expansion is triggered in two situations:

1. **Zero hospitals returned**: The automatic expansion yields N = 0 hospitals for
   the system (e.g., the system is not found in AHA in the year prior to the deal).
2. **Hospital count discrepancy**: The number of affiliated hospitals implied by AHA
   is substantially different from the hospital counts reported in the deal source.

In these cases, we verify and recover the constituent hospitals using earlier AHA
files, 10-K/8-K SEC filings, press releases, local news reports and any other reliable external sources.

## Note
This step requires access to the AHA Annual Survey. The automatic expansion logic
is documented in the accompanying code. Manual expansion decisions are recorded in
the manual workbook template provided in this folder.

