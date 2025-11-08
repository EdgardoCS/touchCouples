import seaborn as sns
import matplotlib.pyplot as plt

palette = [
    "#D18CA6", "#B76A8D",                           # Group 1
    "#4DB6AC", "#00897B", "#00695C",    # Group 2
     "#7986CB", "#5C6BC0", "#3949AB"    # Group 3
    ]

sns.set_palette(palette)

# Example test plot
sns.palplot(palette)
plt.show()