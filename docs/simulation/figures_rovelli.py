"""Figures for nrs3-rovelli-lqg: LQG area quanta and the NRS³ bridge (numpy, matplotlib).

Writes docs/figures/rovelli_area_spectrum.png and docs/figures/rovelli_theta_punctures.png.

Figure 1: the discrete LQG area spectrum A(j) = 8 pi gamma lp^2 sqrt(j (j + 1)) for the
first half-integer levels j = 1/2, 1, 3/2, ... (gamma = 1, lp = 1 units). The levels are
isolated points: there are no intermediate surfaces ("no tenth of 8 pi L_p^2"), and every
level with j >= 1/2 dominates the minimal quantum 4 pi sqrt(3) (Lean: areaSpectrum_min).

Figure 2 (left): the NRS³ localization angle theta(psi) in [0, pi/2] with the universal
ceiling arccos(1/C_infty) ~ 28.30 deg; the numerical example in dimension d = 4 is
theta(4) = 7.43 deg, and the graviton is declared as a state saturating the ceiling
(Lean bridge: graviton_saturates_ceiling).
Figure 2 (right): a surface is a cut whose entropy counts its delta-infinity quanta
(punctures): S(n) = log n (Lean: punctureEntropy, surface_entropy_counts_punctures).

Run:  python3 docs/simulation/figures_rovelli.py
"""

import matplotlib.pyplot as plt
import numpy as np

from style import BLUE, INK, INK2, MUTED, ORANGE, OUT, SURFACE

SQRT3 = np.sqrt(3.0)
# NRS³ universal ceiling: arccos(1 / C_infty) ~ 28.30 deg (base theorem D48).
CEIL_DEG = 28.30
THETA4_DEG = 7.43  # numerical example in dimension d = 4 (base repository)


def area(j):
    """A(j) = 8 pi sqrt(j (j + 1)) in units 8 pi lp^2 (gamma = 1)."""
    return 8.0 * np.pi * np.sqrt(j * (j + 1))


def fig_area_spectrum():
    js = 0.5 * np.arange(1, 9)  # 1/2, 1, 3/2, ..., 4
    a = area(js)
    jmin, amin = 0.5, area(0.5)

    fig, ax = plt.subplots(figsize=(8.6, 5.0), dpi=150)
    ax.plot(js, a, "o", color=BLUE, ms=9, mec=SURFACE, mew=1.4, zorder=5,
            label="area eigenvalues 8π lp² √(j (j + 1)),  j ∈ ½ℕ")
    ax.vlines(js, 0, a, color=BLUE, lw=1.4, alpha=0.55)

    # forbidden band: no surface below the minimal quantum
    ax.axhspan(0, amin, color=ORANGE, alpha=0.09)
    ax.axhline(amin, color=ORANGE, lw=2, ls="--",
               label="minimal quantum  4π√3 lp²  (Lean: areaSpectrum_min)")
    ax.plot([jmin], [amin], "o", color=ORANGE, mec=SURFACE, mew=1.3, ms=8, zorder=6)

    # there is no level between j and j+1: mark the gaps
    for j0, j1 in zip(js[:-1], js[1:]):
        ax.annotate("", (j1, area(j0)), (j0, area(j0)),
                    arrowprops=dict(arrowstyle="-", color=MUTED, lw=0.9, ls=":"))
    ax.text(2.55, 0.62 * amin, "forbidden: no surface here\n"
            "(not even a tenth of 8π L_p²)", color=INK2, fontsize=9.5, va="center")
    ax.annotate("gap: no eigenvalues between levels", (1.25, area(1.0) + 1.5),
                (0.62, area(1.5) + 9.0), color=INK2, fontsize=9.5,
                arrowprops=dict(arrowstyle="->", color=INK2, lw=0.9))

    ax.set_xlim(0, 4.35)
    ax.set_ylim(0, 1.06 * a[-1])
    ax.set_xlabel("spin j  (units of ħ)")
    ax.set_ylabel("area  (units of lp²)")
    ax.legend(loc="upper left", fontsize=9.3)
    ax.set_title("Rovelli, Ch. 6 — area quanta: the spectrum is a set of isolated levels",
                 loc="left", fontsize=11.5)

    fig.tight_layout()
    fig.savefig(OUT / "rovelli_area_spectrum.png", facecolor=SURFACE)
    plt.close(fig)


def fig_theta_punctures():
    fig, (ax, bx) = plt.subplots(1, 2, figsize=(11.8, 4.7), dpi=150,
                                 gridspec_kw={"width_ratios": [1, 1]})

    # Left: the NRS³ localization angle and its ceiling
    d = np.linspace(1, 12, 300)
    # theta(d) rising toward the ceiling (illustrative curve through theta(4) = 7.43 deg)
    theta = CEIL_DEG * (1 - np.exp(-(d - 1) / 9.85))
    ax.plot(d, theta, color=BLUE, lw=2.2,
            label="θ(ψ) for states in the band Ϙ(d) (illustrative)")
    ax.axhline(CEIL_DEG, color=ORANGE, lw=2, ls="--",
               label="ceiling  arccos(1/C∞) ≈ 28.30°")
    ax.plot([4], [THETA4_DEG], "o", color=BLUE, ms=8, mec=SURFACE, mew=1.3, zorder=6)
    ax.vlines(4, 0, THETA4_DEG, color=MUTED, lw=0.9, ls=":")
    ax.plot([10.5], [CEIL_DEG], "*", color=ORANGE, ms=13, mec=SURFACE, mew=1.1, zorder=6)
    ax.text(4.25, THETA4_DEG + 0.7, "θ(4) = 7.43°  (numerical example)", color=INK2,
            fontsize=9.5)
    ax.text(10.3, CEIL_DEG - 2.6, "graviton:\nstate saturating\nθ(ψ) = arccos(1/C)",
            color=ORANGE, fontsize=9.5, ha="right", va="top")
    ax.set_xlim(1, 12)
    ax.set_ylim(0, 32)
    ax.set_xlabel("dimension d")
    ax.set_ylabel("localization angle  θ(ψ)  (degrees)")
    ax.legend(loc="lower right", fontsize=8.8)
    ax.set_title("NRS³ ceiling: θ(ψ) ∈ [0, π/2], bounded by ≈ 28.30°", loc="left",
                 fontsize=11.5)

    # Right: puncture counting entropy
    n = np.arange(1, 41)
    bx.plot(n, np.log(n), color=BLUE, lw=2.2, label="S(n) = log n   (Lean: punctureEntropy)")
    bx.plot(n, np.sqrt(n), color=MUTED, lw=1.2, ls=":",
            label="√n (would-be scaling, for contrast)")
    for k in [1, 4, 16, 36]:
        bx.plot([k], [np.log(k)], "o", color=ORANGE, ms=6, mec=SURFACE, mew=1, zorder=6)
    bx.annotate("each puncture = one δ∞ quantum\n(one loop through the surface)",
                (4, np.log(4)), (8, 1.15), color=INK2, fontsize=9.5,
                arrowprops=dict(arrowstyle="->", color=INK2, lw=0.9))
    bx.set_xlim(0, 41)
    bx.set_ylim(0, 4.6)
    bx.set_xlabel("number of punctures n  (δ∞ quanta of the cut)")
    bx.set_ylabel("entropy of the cut")
    bx.legend(loc="lower right", fontsize=8.8)
    bx.set_title("Rovelli, Ch. 10 — entropy by counting punctures", loc="left",
                 fontsize=11.5)

    fig.suptitle("NRS³ · Rovelli — granular space and the localization ceiling", x=0.01,
                 ha="left", fontsize=13, color=INK)
    fig.tight_layout()
    fig.savefig(OUT / "rovelli_theta_punctures.png", facecolor=SURFACE)
    plt.close(fig)


if __name__ == "__main__":
    fig_area_spectrum()
    fig_theta_punctures()
