"""
author: EdgardoCS @FSU Jena
date: 08.05.2025
"""

import numpy as np
import scipy as sp
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from numpy.ma.core import zeros
from scipy.ndimage import label
pd.options.mode.chained_assignment = None

"""
List of variables
age =  Age - anchor/partner 
sex = Sex - anchor/partner
reldur = Relationship duration in years
reldur_class = Relationship duration [years]
cohab = Cohabitation
nkidsliv_class = Number of all children living with Anchor 
relsat = Relationship satisfaction - anchor/partner
relin =  Relationship quality - anchor/partner
tf_kiss = Touch frequency: Kissing - anchor/partner 
tf_hold = Touch frequency: Holding - anchor/partner 
tf_hug = Touch frequency: Hugging - anchor/partner 

omo15i1_w2b, pomo15i1_w2b = Touch frequency kiss last week - anchor/partner 
omo16i1_w2b, pomo16i1_w2b = Touch frequency put arm around shoulder last week - anchor/partner 
omo17i1_w2b, pomo17i1_w2b = Touch frequency intimate hug last week - anchor/partner 

omo15i2_w2b, pomo15i2_w2b = Desire to touch kiss last week - anchor/partner 
omo16i2_w2b, pomo16i2_w2b = Desire to touch put arm around shoulder last week - anchor/partner 
omo17i2_w2b, pomo17i2_w2b = Desire to touch intimate hug last week - anchor/partner 
"""

df = pd.read_excel("source/only_couples_data.xlsx")
index_options = {"0x": 0,
                 "1-5x": 1,
                 "6-10x": 2,
                 "11-20x": 3,
                 "21-50x": 4,
                 "> 50x": 5}

rel_options = {"0 - Not at all satisfied": 0,
               1: 1,
               2: 2,
               3: 3,
               4: 4,
               5: 5,
               6: 6,
               7: 7,
               8: 8,
               9: 9,
               "10 - Completely satisfied": 10}

df["kiss_diff"] = None
df["hold_diff"] = None
df["hug_diff"] = None

for i in range(0, len(df)):
    try:
        df.loc[i, "relsat"] = rel_options[df["relsat"][i]]
    except KeyError as err:
        pass

for i in range(0, len(df)):
    # print(i, index_options[df['ptf_kiss'][i]] - index_options[df['tf_kiss'][i]])
    if index_options[df['tf_kiss'][i]] == index_options[df['ptf_kiss'][i]]:
        df.loc[i, "kiss_diff"] = 0
    if index_options[df['tf_kiss'][i]] > index_options[df['ptf_kiss'][i]]:
        df.loc[i, "kiss_diff"] = 1
    if (index_options[df['tf_kiss'][i]] - index_options[df['ptf_kiss'][i]]) > 2:
        df.loc[i, "kiss_diff"] = 2
    if index_options[df['tf_kiss'][i]] < index_options[df['ptf_kiss'][i]]:
        df.loc[i, "kiss_diff"] = -1
    if (index_options[df['ptf_kiss'][i]] - index_options[df['tf_kiss'][i]]) > 2:
        df.loc[i, "kiss_diff"] = -2

    if index_options[df['tf_hold'][i]] == index_options[df['ptf_hold'][i]]:
        df.loc[i, "hold_diff"] = 0
    if index_options[df['tf_hold'][i]] > index_options[df['ptf_hold'][i]]:
        df.loc[i, "hold_diff"] = 1
    if (index_options[df['tf_hold'][i]] - index_options[df['ptf_hold'][i]]) > 2:
        df.loc[i, "hold_diff"] = 2
    if index_options[df['tf_hold'][i]] < index_options[df['ptf_hold'][i]]:
        df.loc[i, "hold_diff"] = -1
    if (index_options[df['ptf_hold'][i]] - index_options[df['tf_hold'][i]]) > 2:
        df.loc[i, "hold_diff"] = -2

    if index_options[df['tf_hug'][i]] == index_options[df['ptf_hug'][i]]:
        df.loc[i, "hug_diff"] = 0
    if index_options[df['tf_hug'][i]] > index_options[df['ptf_hug'][i]]:
        df.loc[i, "hug_diff"] = 1
    if (index_options[df['tf_hug'][i]] - index_options[df['ptf_hug'][i]]) > 2:
        df.loc[i, "hug_diff"] = 2
    if index_options[df['tf_hug'][i]] < index_options[df['ptf_hug'][i]]:
        df.loc[i, "hug_diff"] = -1
    if (index_options[df['ptf_hug'][i]] - index_options[df['tf_hug'][i]]) > 2:
        df.loc[i, "hug_diff"] = -2

df1 = df[df["reldur_class"] != "."]
df1.rename(columns={'reldur_class': 'Relationship length'}, inplace=True)
hue_ = ["0-2", "3-5", "6-10", "11-20", "21+"]

# for i in range(0, len(df)):
#     if df["hug_diff"][i] >= 2:
#         print(df["reldur"][i], df["kiss_diff"][i], df["hold_diff"][i])


# fig1, axes = plt.subplots(1, 3)
# sns.kdeplot(data=df1, x="kiss_diff", hue="reldur_class",
#             hue_order=hue_,
#             ax=axes[0])
#
# sns.kdeplot(data=df1, x="hold_diff", hue="reldur_class",
#             hue_order=hue_,
#             ax=axes[1])
#
# sns.kdeplot(data=df1, x="hug_diff", hue="reldur_class",
#             hue_order=hue_,
#             ax=axes[2])
# axes[0].set_ylim([0, 0.25])
# axes[1].set_ylim([0, 0.25])
# axes[2].set_ylim([0, 0.25])
# plt.show()


fig, ax = plt.subplots(1, 3)
sns.histplot(
    data=df1, x="kiss_diff", hue="Relationship length",
    hue_order=hue_, ax=ax[0],
    multiple="dodge", discrete=True, shrink=.8
)
ax[0].set_xlabel("Kiss difference")

sns.histplot(
    data=df1, x="hold_diff", hue="Relationship length",
    hue_order=hue_, ax=ax[1],
    multiple="dodge", discrete=True, shrink=.8
)
ax[1].set_xlabel("Hold difference")
sns.histplot(
    data=df1, x="hug_diff", hue="Relationship length",
    hue_order=hue_, ax=ax[2],
    multiple="dodge", discrete=True, shrink=.8,
)
ax[2].set_xlabel("Hug difference")
# plt.show()




"""
fig1, axes = plt.subplots(2, 1)
fig1.suptitle("OMO15 - Touch frequency kiss last week")
sns.countplot(ax=axes[0], data=df, x="omo15i1_w2b", hue="type",
              order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
                     "More than 50 times"])
axes[0].set_title("Received")
axes[0].set_xlabel("Frequency")
axes[0].set_ylabel("Count")
axes[0].set_ylim([0, 2500])

sns.countplot(ax=axes[1], data=df, x="omo15i2_w2b", hue="type",
              order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
                     "More than 50 times"])
axes[1].set_title("Desired")
axes[1].set_xlabel("Frequency")
axes[1].set_ylabel("Count")
axes[1].set_ylim([0, 2500])

fig2, axes = plt.subplots(2, 1)
fig2.suptitle("OMO16 - Touch frequency put arm around shoulder last week")
sns.countplot(ax=axes[0], data=df, x="omo16i1_w2b", hue="type",
              order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
                     "More than 50 times"])
axes[0].set_title("Received")
axes[0].set_xlabel("Frequency")
axes[0].set_ylabel("Count")
axes[0].set_ylim([0, 2500])

sns.countplot(ax=axes[1], data=df, x="omo16i2_w2b", hue="type",
              order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
                     "More than 50 times"])
axes[1].set_title("Desired")
axes[1].set_xlabel("Frequency")
axes[1].set_ylabel("Count")
axes[1].set_ylim([0, 2500])

fig3, axes = plt.subplots(2, 1)
fig3.suptitle("OMO17 - Touch frequency intimate hug last week")
sns.countplot(ax=axes[0], data=df, x="omo17i1_w2b", hue="type",
              order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
                     "More than 50 times"])
axes[0].set_title("Received")
axes[0].set_xlabel("Frequency")
axes[0].set_ylabel("Count")
axes[0].set_ylim([0, 2500])

sns.countplot(ax=axes[1], data=df, x="omo17i2_w2b", hue="type",
              order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
                     "More than 50 times"])
axes[1].set_title("Desired")
axes[1].set_xlabel("Frequency")
axes[1].set_ylabel("Count")
axes[1].set_ylim([0, 2500])
plt.show()
"""
