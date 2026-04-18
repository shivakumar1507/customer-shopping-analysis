import pandas as pd
import numpy as np

# 1. Load data
df = pd.read_csv("C:/Users/SHIVA/OneDrive/Documents/Customer_Shopping_Analysis/Data/customer_shopping_behavior.csv")

# 2. Clean column names
df.columns = df.columns.str.strip().str.lower().str.replace(' ', '_')

# 3. Convert data types
df['age'] = pd.to_numeric(df['age'], errors='coerce')
df['purchase_amount'] = pd.to_numeric(df['purchase_amount'], errors='coerce')
df['previous_purchases'] = pd.to_numeric(df['previous_purchases'], errors='coerce')
df['review_rating'] = pd.to_numeric(df['review_rating'], errors='coerce')

# 4. Handle missing values
df = df.dropna()

# 5. Remove duplicates
df = df.drop_duplicates()

# 6. Clean categorical columns
df['gender'] = df['gender'].str.strip().str.title()
df['category'] = df['category'].str.strip()
df['location'] = df['location'].str.strip()
df['payment_method'] = df['payment_method'].str.strip()
df['shipping_type'] = df['shipping_type'].str.strip()

# 7. Handle incorrect values
df = df[df['age'] > 0]
df = df[df['purchase_amount'] > 0]

# 8. Feature Engineering
df['customer_value'] = df['purchase_amount'] * df['previous_purchases']

df['is_repeat'] = np.where(df['previous_purchases'] > 1, 1, 0)

df['has_discount'] = np.where(df['discount_applied'] == 'Yes', 1, 0)

df['age_group'] = pd.cut(
    df['age'],
    bins=[0, 25, 40, 60, 100],
    labels=['Young', 'Adult', 'Mid', 'Senior']
)

# 9. Remove outliers (top 1%)
df = df[df['purchase_amount'] < df['purchase_amount'].quantile(0.99)]

# 10. Final check
print("Final Shape:", df.shape)
print(df.info())
print(df.describe())

# 11. Save cleaned data
df.to_csv("C:/Users/SHIVA/OneDrive/Documents/Customer_Shopping_Analysis/Data/customer_shopping_behavior_cleaned.csv", index=False)

print("Data cleaning completed and saved!")