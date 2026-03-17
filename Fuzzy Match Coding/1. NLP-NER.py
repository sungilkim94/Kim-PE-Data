import pandas as pd
import spacy
import os
import getpass
import warnings
warnings.filterwarnings("ignore")

# spacy model (publicly available NLP)
nlp = spacy.load("en_core_web_sm")

# File Import Setup
username = getpass.getuser()
user_configs = {
    "***": {
        "AHA-Deal": r"C:\***",
    },
}

if username not in user_configs:
    raise ValueError(f"Username '{username}' not recognized. Please add your config.")

AHA_Deal = user_configs[username]["AHA_Deal"]

AP_raw_data_dir = os.path.join(AHA_Deal, "raw_data")
AP_work_data_dir = os.path.join(AHA_Deal, "work_data")
AP_final_data_dir = os.path.join(AHA_Deal, "final_data")
os.makedirs(AP_raw_data_dir, exist_ok=True)
os.makedirs(AP_work_data_dir, exist_ok=True)
os.makedirs(AP_final_data_dir, exist_ok=True)

# Using Deal Database 
Deal_file = os.path.join(AP_raw_data_dir, "Deal.dta")
df = pd.read_stata(Deal_file)

# Keyword list for inclusive filtering of entities
hospital_keywords = ["hospital", "health system", "medical center", "health group", "hospitals", "facilities", " health centers", "long-term acute care", "acute care", "surgery", " healthcare center", "center", "medicine centers", "centers", " medical facilities", " inpatient", "heathcare", "emergency room", "emergency", "ER", "surgical center", "health", "behavioral care"]

# Define our NER(Named Entity Recognition) function to check for hospital entities
def contains_hospital_entity(text):
    if pd.isnull(text) or not isinstance(text, str):
        return False
    doc = nlp(text)
    for ent in doc.ents:
        if ent.label_ == "ORG" and any(kw in ent.text.lower() for kw in hospital_keywords):
            return True
    return False

# Apply the function to desired columns (target name, target description, etc.)
df["ner_flag"] = (
    df["company_name"].apply(contains_hospital_entity) |
    df["deal_description"].apply(contains_hospital_entity) |
    df["firm_about"].apply(contains_hospital_entity) 
)

# Save to Excel
output_file = os.path.join(AP_work_data_dir, "Deal_NER.xlsx")
df.to_excel(output_file, index=False)
print(f"✅ Saved NER results to: {output_file}")
