## Venn Diagram
This script creates a visual Venn diagram showing the relationship between two sets. It displays items that are unique to each set as well as items that are shared between them.

### Dependencies
- `matplotlib`: Plotting library
- `matplotlib_venn`: Venn diagram extension for matplotlib

### Requirements
- Install dependencies: `pip install matplotlib matplotlib-venn`

### Arguments
- `set_a`: Comma-separated items in the first set.
- `set_b`: Comma-separated items in the second set.
- `--label-a`: Label for the first set. Defaults to `Set A`.
- `--label-b`: Label for the second set. Defaults to `Set B`.

### Example Usage
```
python venn_diagram.py "A1,A2,Shared" "B1,B2,Shared"
```