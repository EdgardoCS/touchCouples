"""
author: EdgardoCS @FSU Jena
date: 08.05.2025
"""

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

"""
List of variables
age, page = Age - anchor/partner 
sex, psex = Sex - anchor/partner
reldur = Relationship duration in years
reldur_class = Relationship duration [years]
cohab = Cohabitation
nkidsliv_class = Number of all children living with Anchor 
relsat, prelsat = Relationship satisfaction - anchor/partner
relin prelint =  Relationship quality - anchor/partner
tf_kiss, ptf_kiss = Touch frequency: Kissing - anchor/partner 
tf_hold, ptf_hold = Touch frequency: Holding - anchor/partner 
tf_hug, ptf_hug = Touch frequency: Hugging - anchor/partner 

omo15i1_w2b, pomo15i1_w2b = Touch frequency kiss last week - anchor/partner 
omo16i1_w2b, pomo16i1_w2b = Touch frequency put arm around shoulder last week - anchor/partner 
omo17i1_w2b, pomo17i1_w2b = Touch frequency intimate hug last week - anchor/partner 

omo15i2_w2b, pomo15i2_w2b = Desire to touch kiss last week - anchor/partner 
omo16i2_w2b, pomo16i2_w2b = Desire to touch put arm around shoulder last week - anchor/partner 
omo17i2_w2b, pomo17i2_w2b = Desire to touch intimate hug last week - anchor/partner 
"""

df = pd.read_csv("source/FReDA.csv", delimiter=";")

sns.countplot(data=df, x="omo15i1_w2b", hue="type",
              order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
                     "More than 50 times"])
plt.title("OMO15 - Touch frequency kiss last week / Received")
plt.xlabel("Frequency")
plt.ylabel("Count")

# sns.countplot(data=df, x="omo15i2_w2b", hue="type",
#               order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
#                      "More than 50 times"])
# plt.title("OMO15 - Touch frequency kiss last week / Desired")
# plt.xlabel("Frequency")
# plt.ylabel("Count")

plt.show()

# TODO: GIT UNTRACK

"""
fig, axes = plt.subplots(1, 3, figsize=(15, 5), sharey=True)
fig.suptitle('Initial Pokemon - 1st Generation')

# Bulbasaur
sns.barplot(ax=axes[0], x=bulbasaur.index, y=bulbasaur.values)
axes[0].set_title(bulbasaur.name)

# Charmander
sns.barplot(ax=axes[1], x=charmander.index, y=charmander.values)
axes[1].set_title(charmander.name)

# Squirtle
sns.barplot(ax=axes[2], x=squirtle.index, y=squirtle.values)
axes[2].set_title(squirtle.name)
"""