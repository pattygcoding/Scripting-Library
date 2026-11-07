#!/usr/bin/env python3
"""Draw a Venn diagram of two sets.

Requires the third-party packages ``matplotlib`` and ``matplotlib-venn``. Each
set is given as a comma-separated list of items.
"""

from __future__ import annotations

import argparse
import sys

import matplotlib.pyplot as plt
from matplotlib_venn import venn2


def _parse_set(value: str) -> set[str]:
    """Turn a comma-separated string into a set of items."""
    return {item.strip() for item in value.split(",") if item.strip()}


def draw_venn(set_a: set[str], set_b: set[str], label_a: str, label_b: str) -> None:
    """Show a two-set Venn diagram."""
    plt.figure(figsize=(8, 8))
    venn = venn2([set_a, set_b], set_labels=(label_a, label_b))

    only_a = venn.get_label_by_id("10")
    only_b = venn.get_label_by_id("01")
    both = venn.get_label_by_id("11")

    if only_a:
        only_a.set_text("\n".join(sorted(set_a - set_b)))
    if only_b:
        only_b.set_text("\n".join(sorted(set_b - set_a)))
    if both:
        both.set_text("\n".join(sorted(set_a & set_b)))

    venn.get_label_by_id("A").set_position((-0.2, 0.5))
    venn.get_label_by_id("B").set_position((0.2, 0.5))

    plt.show()


def main() -> int:
    parser = argparse.ArgumentParser(description="Draw a Venn diagram of two sets.")
    parser.add_argument("set_a", nargs="?", default="Item A1,Item A2,Shared", help="Comma-separated items in set A.")
    parser.add_argument("set_b", nargs="?", default="Item B1,Item B2,Shared", help="Comma-separated items in set B.")
    parser.add_argument("--label-a", default="Set A", help="Label for the first set.")
    parser.add_argument("--label-b", default="Set B", help="Label for the second set.")
    args = parser.parse_args()

    draw_venn(_parse_set(args.set_a), _parse_set(args.set_b), args.label_a, args.label_b)
    return 0


if __name__ == "__main__":
    sys.exit(main())
