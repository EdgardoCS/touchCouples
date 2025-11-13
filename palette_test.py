import seaborn as sns
import matplotlib.pyplot as plt

palette = [
    "#D18CA6", "#B76A8D",  # Group 1
    "#4DB6AC", "#00897B", "#00695C",  # Group 2
    "#7986CB", "#5C6BC0", "#3949AB"  # Group 3
]

cb_teal_purple = [
    "#4DB6AC",  # soft teal (anchor from your palette)
    "#2A9D8F",  # deeper green-teal
    "#7986CB",  # lavender-blue
    "#5C6BC0",  # deep periwinkle
    "#C47A9E"  # muted rose-magenta
]
cb_extended5 = [
    "#009688",  # deep teal
    "#0072B2",  # clear blue (BBC / Okabe-Ito safe)
    "#E69F00",  # warm amber-gold (good separation from blues)
    "#CC79A7",  # strong magenta-rose
    "#56B4E9"  # light sky blue for a bright accent
]

four_cords = [
    "#B76A8D",  # rose mauve (kept)
    "#009688",  # balanced teal (slightly brighter)
    "#C4A000",  # deeper gold, more luminance contrast
    "#355C9C"   # slightly lighter indigo for improved differentiation
]

four_cords2 = [
    "#BDBDBD",
    "#B76A8D",
    "#009688",
    "#355C9C"
]

four_cords3 = [
        "#C4A000",
    "#BDBDBD",
    "#009688",
    "#355C9C"
]

target_pal = four_cords3

sns.set_palette(target_pal)
sns.palplot(target_pal)
plt.show()
