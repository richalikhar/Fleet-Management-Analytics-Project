#!/usr/bin/env python
# coding: utf-8

# In[49]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from pathlib import Path

def extract_data(path="fleet_project_datasets_fixed.csv"):
    return pd.read_csv(path)

#df = pd.read_csv("fleet_project_datasets_fixed.csv")



# In[50]:


def clean_data(df):
    df = df.copy()
    # drop exact duplicates
    df = df.drop_duplicates()
    # Standardize date type  
    
    df['purchase_date'] = pd.to_datetime(df['purchase_date'], errors='coerce')
    df['year'] = pd.to_datetime(df['year'], errors='coerce')
    # Fix types
    numeric_cols = ['capacity_kg','current_mileage_km','fuel_efficiency_km_l','driver_performance_score','annual_maintenance_cost']
    for c in numeric_cols:
        if c in df.columns:
            df[c] = pd.to_numeric(df[c], errors='coerce')
    # Fill small missing demographics with medians/modes
    if 'capacity_kg' in df.columns:
        df['capacity_kg'] = df['capacity_kg'].fillna(df['capacity_kg'].median().round(0))
    if 'current_mileage_km' in df.columns:
        df['current_mileage_km'] = df['current_mileage_km'].fillna(df['current_mileage_km'].median().round(0))
    if 'fuel_efficiency_km_l' in df.columns:
        df['fuel_efficiency_km_l'] = df['fuel_efficiency_km_l'].fillna(df['fuel_efficiency_km_l'].median().round(1))
    if 'driver_performance_score' in df.columns:
        df['driver_performance_score'] = df['driver_performance_score'].median().round(0)
    if 'annual_maintenance_cost' in df.columns:
        df['annual_maintenance_cost'] = df['annual_maintenance_cost'].median().round(2)
    # Ensure non-negative where required
    for c in ['capacity_kg','current_mileage_km','fuel_efficiency_km_l','driver_performance_score']:
        if c in df.columns:
            df.loc[df[c] < 0, c] = np.nan
    return df


# In[19]:


df.info()


# In[51]:


def transform_data(df): 


    df = df.copy()
    # vehicle_age_months(from purchase date and year)
    df['purchase_date'] = pd.to_datetime(df['purchase_date'], errors='coerce')
    df['date'] = pd.to_datetime(df['year'].astype(str) + "-01-01")
    df['Purchase_year'] = df['purchase_date'].dt.year
    df['vehicle_age_year'] =  df['Purchase_year'] - df['date'].dt.year 
    df['vehicle_age_months']  = df['vehicle_age_year'] * 12        
    # Cost per km (annual_maintenance_cost / current_mileage_km)
    df['Cost_per_km '] = df['annual_maintenance_cost'] / df['current_mileage_km']
    # Monthly mileage (current_mileage_km / vehicle_age_months)
    df['Monthly mileage'] = (df['current_mileage_km'] / df['vehicle_age_months']).fillna(0)   
    #Efficiency category (High/Medium/Low based on fuel_efficiency_km_l)
    df["Efficiency category"] = np.where(df["fuel_efficiency_km_l"] >= 10, "High", np.where(df["fuel_efficiency_km_l"] >= 7, "Medium", "Low") )
    return df


# In[53]:


def save_data(df, filename="fleet_project_datasets_fixed_new.csv"):
    Path(filename).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(filename, index=False)
    return filename

if __name__ == "__main__":
    df = extract_data("fleet_project_datasets_fixed.csv")
    dfc = clean_data(df)
    dft = transform_data(dfc)
    save_data(dft, "fleet_project_datasets_fixed_new.csv")
    print("Saved fleet_project_datasets_fixed_new.csv")


# In[56]:


df_new = pd.read_csv("fleet_project_datasets_fixed_new.csv")

perf = df_new.groupby(['make', 'model'])['fuel_efficiency_km_l'].mean().reset_index()
print(perf)

plt.figure(figsize=(10, 5))
plt.bar(perf['model'], perf['fuel_efficiency_km_l'])

plt.title("Vehicle Performance by Make and Model")
plt.xlabel("Model")
plt.ylabel("Fuel Efficiency (km/l)")
plt.xticks(rotation=45)

plt.tight_layout()
plt.show()


# In[55]:


#df_new = pd.read_csv("fleet_project_datasets_fixed_new.csv")
   
plt.figure(figsize=(8, 5))
plt.scatter(df_new["vehicle_age_year"], df_new["fuel_efficiency_km_l"])

plt.title("Age vs Fuel Efficiency Correlation")
plt.xlabel("Vehicle Age")
plt.ylabel("Fuel Efficiency (km/l)")

plt.grid(True)
plt.show()


# In[47]:





# In[37]:


cost_trends = df_new.groupby(['make', 'model', "year"])["annual_maintenance_cost"].mean().reset_index()
print(cost_trends)


# In[52]:





# In[53]:





# In[10]:





# In[11]:





# In[39]:


df_new.info()


# In[48]:





# In[ ]:




