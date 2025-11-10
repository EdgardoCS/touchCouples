import seaborn as sns
import matplotlib.pyplot as plt

palette = [
    "#D18CA6", "#B76A8D",                           # Group 1
    "#4DB6AC", "#00897B", "#00695C",    # Group 2
     "#7986CB", "#5C6BC0", "#3949AB"    # Group 3
    ]

cb_teal_purple = [
    "#4DB6AC",  # soft teal (anchor from your palette)
    "#2A9D8F",  # deeper green-teal
    "#7986CB",  # lavender-blue
    "#5C6BC0",  # deep periwinkle
    "#C47A9E"   # muted rose-magenta
]
cb_extended5 = [
    "#009688",  # deep teal
    "#0072B2",  # clear blue (BBC / Okabe-Ito safe)
    "#E69F00",  # warm amber-gold (good separation from blues)
    "#CC79A7",  # strong magenta-rose
    "#56B4E9"   # light sky blue for a bright accent
]


target_pal =cb_extended5

sns.set_palette(target_pal)
sns.palplot(target_pal)
plt.show()