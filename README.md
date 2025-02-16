# 🏢 Défaillances d'entreprises  
![Economy](https://img.shields.io/badge/Economie-Business_Failures-red?style=flat&logo=bar-chart)
![Data Analysis](https://img.shields.io/badge/Data_Analysis-Statistics-blue?style=flat&logo=python) 
![France](https://img.shields.io/badge/Region-Normandie-blue?style=flat&logo=flag)

---

## 📊 Nombre de défaillances d'entreprises en Normandie  
📌 **Secteur étudié** : Hébergement et Restauration 🍽️🏨  
📌 **Source des données** : [INSEE](https://www.insee.fr/fr/accueil)  
📌 **Période de collecte** : **1990 - 2020**  

---

## 🎯 Objectifs de l'analyse  

- 🔍 **Analyser l'évolution des défaillances d'entreprises** dans le secteur de l’hébergement et de la restauration  
- 📈 **Identifier les tendances économiques** et les périodes de crise  
- 🛠️ **Proposer des visualisations** et des insights à partir des données collectées  

---

## 📂 Structure des données  

Les données étudiées incluent :  

| Année | Nombre de défaillances | Secteur | Région |
|--------|-----------------------|----------|---------|
| 1990  | 450  | Hébergement & Restauration | Normandie |
| 2000  | 520  | Hébergement & Restauration | Normandie |
| 2010  | 600  | Hébergement & Restauration | Normandie |
| 2020  | 720  | Hébergement & Restauration | Normandie |

📌 **Données brutes disponibles au format `.csv` ou `.xlsx`**  

---

## 🔬 Analyse exploratoire  

📊 **Exemple de chargement et visualisation des données en Python**  

```python
import pandas as pd
import matplotlib.pyplot as plt

# Chargement des données
url = "chemin_vers_votre_fichier.csv"
df = pd.read_csv(url)

# Visualisation des tendances
plt.figure(figsize=(10,5))
plt.plot(df["Année"], df["Nombre de défaillances"], marker="o", linestyle="-", color="red")
plt.xlabel("Année")
plt.ylabel("Nombre de défaillances")
plt.title("Évolution des défaillances d'entreprises (Normandie)")
plt.grid(True)
plt.show()
```

---

## 📢 Conclusion & Perspectives  

📌 **Observations** :  
- 📈 Augmentation progressive du nombre de défaillances  
- 📉 Périodes de crise identifiables (2008, 2020)  
- 🔍 Nécessité d'une analyse plus fine des facteurs économiques  

📌 **Pistes d'amélioration** :  
✅ **Analyse par sous-secteurs (Hôtels, Restaurants, Cafés)**  
✅ **Corrélation avec d'autres facteurs économiques (PIB, chômage, tourisme)**  
✅ **Modélisation prédictive pour anticiper les tendances futures**  

---

📌 **Auteur** : smdlabtech  
📜 **Licence** : Open-Source  

---
