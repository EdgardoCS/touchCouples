"""
author: EdgardoCS @FSU Jena
date: 08.05.2025
"""

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from numpy.ma.core import zeros

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

df = pd.read_csv("source/only_couples_data.csv", delimiter=",")
index_options = {"0x": 0,
                 "1-5x": 1,
                 "6-10x": 2,
                 "11-20x": 3,
                 "21-50x": 4,
                 "> 50x": 5}

df["kiss_diff"] = None
for i in range(0, len(df)):
    print(i, index_options[df['ptf_kiss'][i]] - index_options[df['tf_kiss'][i]])
    if index_options[df['tf_kiss'][i]] == index_options[df['ptf_kiss'][i]]:
        df.loc[i, "kiss_diff"] = 0
    elif index_options[df['tf_kiss'][i]] > index_options[df['ptf_kiss'][i]] < 2:
        df.loc[i, "kiss_diff"] = 1
    elif (index_options[df['tf_kiss'][i]] - index_options[df['ptf_kiss'][i]]) >= 2:
        df.loc[i, "kiss_diff"] = 2
    elif index_options[df['tf_kiss'][i]] < index_options[df['ptf_kiss'][i]] < 2:
        df.loc[i, "kiss_diff"] = -1
    elif (index_options[df['ptf_kiss'][i]] - index_options[df['tf_kiss'][i]]) >= 2:
        df.loc[i, "kiss_diff"] = -2
print(df)

#     if df['tf_hold'][i] == df['ptf_hold'][i]:
#         kiss_diff[i] = 0
# value = label_to_value[selected_option]
#
# print(df["match"])

# fig1, axes = plt.subplots(2, 1)
# fig1.suptitle("OMO15 - Touch frequency kiss last week")
# sns.countplot(ax=axes[0], data=df, x="omo15i1_w2b", hue="type",
#               order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
#                      "More than 50 times"])
# axes[0].set_title("Received")
# axes[0].set_xlabel("Frequency")
# axes[0].set_ylabel("Count")
# axes[0].set_ylim([0, 2500])
#
# sns.countplot(ax=axes[1], data=df, x="omo15i2_w2b", hue="type",
#               order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
#                      "More than 50 times"])
# axes[1].set_title("Desired")
# axes[1].set_xlabel("Frequency")
# axes[1].set_ylabel("Count")
# axes[1].set_ylim([0, 2500])
#
# fig2, axes = plt.subplots(2, 1)
# fig2.suptitle("OMO16 - Touch frequency put arm around shoulder last week")
# sns.countplot(ax=axes[0], data=df, x="omo16i1_w2b", hue="type",
#               order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
#                      "More than 50 times"])
# axes[0].set_title("Received")
# axes[0].set_xlabel("Frequency")
# axes[0].set_ylabel("Count")
# axes[0].set_ylim([0, 2500])
#
# sns.countplot(ax=axes[1], data=df, x="omo16i2_w2b", hue="type",
#               order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
#                      "More than 50 times"])
# axes[1].set_title("Desired")
# axes[1].set_xlabel("Frequency")
# axes[1].set_ylabel("Count")
# axes[1].set_ylim([0, 2500])
#
# fig3, axes = plt.subplots(2, 1)
# fig3.suptitle("OMO17 - Touch frequency intimate hug last week")
# sns.countplot(ax=axes[0], data=df, x="omo17i1_w2b", hue="type",
#               order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
#                      "More than 50 times"])
# axes[0].set_title("Received")
# axes[0].set_xlabel("Frequency")
# axes[0].set_ylabel("Count")
# axes[0].set_ylim([0, 2500])
#
# sns.countplot(ax=axes[1], data=df, x="omo17i2_w2b", hue="type",
#               order=["Not at all", "1 to 5 times", "6 to 10 times", "11 to 20 times", "21 to 50 times",
#                      "More than 50 times"])
# axes[1].set_title("Desired")
# axes[1].set_xlabel("Frequency")
# axes[1].set_ylabel("Count")
# axes[1].set_ylim([0, 2500])
# plt.show()
