"""Figure for LinkPuncture: a link is a puncture (numpy, matplotlib).

Writes docs/figures/link_puncture.png.

Left: the number M of crossing links of every cut of paths with up to 30 sites, against the
2j + 1 states of a puncture; the entropy of k quanta is k log M on the cut and k log(2j + 1) for
the punctures, the same number when M = 2j + 1 (Lean: cutEntropy_eq_punctureEntropy). The cut
after 0 on four sites has M = 2 (numCross_three_zero). Right: under the one Bekenstein–Hawking
bridge, a link carries the area 4 ℓ_P² log M; the LQG level A(j) at γ = log 2 / (π √3) is
8πγ ℓ_P² √(j(j + 1)). Their ratio is 1 exactly at M = 2, j = 1/2 (link_area_eq_puncture).
Exact values.

Run:  python3 docs/simulation/figures_link_puncture.py
"""

import matplotlib.pyplot as plt
import numpy as np

from style import BLUE, INK, INK2, MUTED, ORANGE, OUT, SURFACE


def num_cross(n, c):
    return sum(1 for a in range(n + 1) for b in range(n + 1) if a <= c < b and a + 2 <= b)


def fig_link_puncture():
    fig, (ax, bx) = plt.subplots(1, 2, figsize=(12.2, 4.7), dpi=150)

    ms = sorted({num_cross(n, c) for n in range(3, 30) for c in range(0, n - 1)})
    ms = [m for m in ms if m <= 40]
    k = 5
    ax.plot([0, 42], [0, 42 * 0 + k * np.log(42)], alpha=0)
    for m in ms:
        ax.plot(m, k * np.log(m), "o", color=BLUE, ms=5.5, mec=SURFACE, mew=0.8)
    jj = np.arange(1, 80) / 2
    ax.plot(2 * jj + 1, k * np.log(2 * jj + 1), color=ORANGE, lw=1.6,
            label=f"punctures: S = k log(2j + 1), k = {k}")
    ax.plot([], [], "o", color=BLUE, label=f"cuts: S = k log M, k = {k}")
    ax.plot(2, k * np.log(2), "o", ms=11, mfc="none", mec=INK, mew=1.4)
    ax.annotate("cut after 0 on four sites:\nM = 2 ↔ j = 1/2", (2, k * np.log(2)), (7, 2.2),
                color=INK2, fontsize=9.5, arrowprops=dict(arrowstyle="->", color=INK2, lw=0.9))
    ax.set_xlim(0, 42)
    ax.set_xlabel("M crossing links  =  2j + 1 puncture states")
    ax.set_ylabel("entropy of k quanta")
    ax.legend(loc="lower right", fontsize=9)
    ax.set_title("One entropy: a cut with M = 2j + 1 is k spin-j punctures", loc="left",
                 fontsize=11.5)

    gbh = np.log(2) / (np.pi * np.sqrt(3))
    mm = np.arange(2, 41)
    j = (mm - 1) / 2
    ratio = 4 * np.log(mm) / (8 * np.pi * gbh * np.sqrt(j * (j + 1)))
    bx.plot(mm, ratio, "o-", color=BLUE, ms=4, lw=1.4)
    bx.axhline(1, color=INK, lw=0.9, ls=":")
    bx.plot(2, 1, "o", ms=11, mfc="none", mec=ORANGE, mew=1.6)
    bx.text(3, 1.03, "1 exactly at M = 2, j = 1/2", color=ORANGE, fontsize=9.5)
    bx.set_xlabel("M = 2j + 1")
    bx.set_ylabel("link area 4ℓ_P² log M  /  A(j) at γ_BH")
    bx.set_ylim(0, 1.15)
    bx.set_title("One bridge: a link has the area of a spin-½ puncture", loc="left",
                 fontsize=11.5)

    fig.suptitle("A link is a puncture — NRS³ cuts and LQG punctures count the same states",
                 x=0.01, ha="left", fontsize=13, color=INK)
    fig.tight_layout()
    fig.savefig(OUT / "link_puncture.png", facecolor=SURFACE)
    plt.close(fig)


if __name__ == "__main__":
    fig_link_puncture()
