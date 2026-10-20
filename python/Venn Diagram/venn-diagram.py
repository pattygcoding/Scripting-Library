import matplotlib.pyplot as plt
from matplotlib_venn import venn2

# Example sets
set_A = {"CategoryA_Item1", "CategoryA_Item2", "CategoryA_Item3", "CategoryA_Item4", "SharedItem"}
set_B = {"CategoryB_Item1", "CategoryB_Item2", "CategoryB_Item3", "CategoryB_Item4", "SharedItem"}

plt.figure(figsize=(8, 8))
venn = venn2([set_A, set_B], set_labels=('Set A Label', 'Set B Label'))

# Left-only set
venn.get_label_by_id('10').set_text(
    "Item A1\n"
    "Item A2\n"
    "Item A3\n"
    "Item A4\n"
    "Any item unique to Set A"
)

# Right-only set
venn.get_label_by_id('01').set_text(
    "Item B1\n"
    "Item B2\n"
    "Item B3\n"
    "Item B4\n"
    "Any item unique to Set B"
)

# Intersection set
venn.get_label_by_id('11').set_text("Shared Item(s)")

# Adjust label positions
venn.get_label_by_id('A').set_position((-0.2, 0.5))
venn.get_label_by_id('B').set_position((0.2, 0.5))

plt.show()
