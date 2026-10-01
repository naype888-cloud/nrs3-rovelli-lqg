"""Figures for nrs3-rovelli-lqg: LQG area quanta and the NRS³ ceiling (numpy, matplotlib).

Writes docs/figures/rovelli_area_spectrum.png and docs/figures/rovelli_theta_punctures.png.

Figure 1: the LQG area spectrum A(j) = 8 pi gamma lp^2 sqrt(j (j + 1)), j = 1/2, 1, 3/2, ...
(plotted with gamma = 1, lp = 1). Every level with j >= 1/2 is at least A(1/2) = 4 pi sqrt(3)
(Lean: areaSpectrum_min, areaSpectrum_strictMono).

Figure 2 (left): the exact NRS angle theta_NRS(d) = arccos(1 / C_Nava(d)) of the base
repository (D37b, D8 closed form). theta = 0 at d = 2, 3 (Robertson saturates),
theta_NRS(4) = 7.43 deg, and the ceiling arccos(1 / C_infty) = 28.30 deg is the limit,
never attained (Lean: angle_lt_ceiling, ceiling_not_attained, tendsto_angle_ceiling).
Figure 2 (right): n punctures of spin 1/2 have entropy S = n log 2; Bekenstein-Hawking
S = A / (4 lp^2) holds exactly at gamma = log 2 / (pi sqrt 3) (Lean:
bekensteinHawking_iff_immirzi).

Run:  python3 docs/simulation/figures_rovelli.py
"""

import matplotlib.pyplot as plt
import numpy as np

from style import BLUE, INK, INK2, MUTED, ORANGE, OUT, SURFACE

SQRT3 = np.sqrt(3.0)
# C_Nava(d)^2 in closed form (D8_Szego.CoherenceConstantSq), N = d + 1, t = pi / N.
def coherence_sq(d):
    n = d + 1.0
    t = np.pi / n
    return 2 * (d - 1) / (n * np.cos(t) ** 2) * (((n * n + 2) / 6) * np.sin(t) ** 2 - 1)


def angle_nrs_deg(d):
    """theta_NRS(d) = arccos(1 / C_Nava(d)) in degrees (D37b); 0 at d = 2, 3."""
    return np.degrees(np.arccos(np.clip(1 / np.sqrt(coherence_sq(d)), -1, 1)))


CEIL_DEG = np.degrees(np.arccos(1 / np.sqrt(np.pi ** 2 / 3 - 2)))  # 28.2978 deg
THETA4_DEG = angle_nrs_deg(4)  # 7.4348 deg
GAMMA_BH = np.log(2) / (np.pi * SQRT3)  # 0.12738


def area(j):
    """A(j) = 8 pi sqrt(j (j + 1)) in units 8 pi lp^2 (gamma = 1)."""
    return 8.0 * np.pi * np.sqrt(j * (j + 1))


def fig_area_spectrum():
    js = 0.5 * np.arange(1, 9)  # 1/2, 1, 3/2, ..., 4
    a = area(js)
    jmin, amin = 0.5, area(0.5)

    fig, ax = plt.subplots(figsize=(8.6, 5.0), dpi=150)
    ax.plot(js, a, "o", color=BLUE, ms=9, mec=SURFACE, mew=1.4, zorder=5,
            label="area levels 8πγ ℓ_P² √(j (j + 1)),  j ∈ ½ℕ  (γ = 1)")
    ax.vlines(js, 0, a, color=BLUE, lw=1.4, alpha=0.55)

    # forbidden band: no surface below the minimal quantum
    ax.axhspan(0, amin, color=ORANGE, alpha=0.09)
    ax.axhline(amin, color=ORANGE, lw=2, ls="--",
               label="lowest level A(1/2) = 4π√3 γ ℓ_P²  (Lean: areaSpectrum_min)")
    ax.plot([jmin], [amin], "o", color=ORANGE, mec=SURFACE, mew=1.3, ms=8, zorder=6)

    # there is no level between j and j+1: mark the gaps
    for j0, j1 in zip(js[:-1], js[1:]):
        ax.annotate("", (j1, area(j0)), (j0, area(j0)),
                    arrowprops=dict(arrowstyle="-", color=MUTED, lw=0.9, ls=":"))
    ax.text(2.55, 0.62 * amin, "forbidden: no surface here\n"
            "(not even a tenth of 8π ℓ_P²)", color=INK2, fontsize=9.5, va="center")
    ax.annotate("gap: no eigenvalues between levels", (1.25, area(1.0) + 1.5),
                (0.62, area(1.5) + 9.0), color=INK2, fontsize=9.5,
                arrowprops=dict(arrowstyle="->", color=INK2, lw=0.9))

    ax.set_xlim(0, 4.35)
    ax.set_ylim(0, 1.06 * a[-1])
    ax.set_xlabel("spin j  (units of ħ)")
    ax.set_ylabel("area  (units of ℓ_P²)")
    ax.legend(loc="upper left", fontsize=9.3)
    ax.set_title("Rovelli, Ch. 6 — area quanta of one puncture: separated levels",
                 loc="left", fontsize=11.5)

    fig.tight_layout()
    fig.savefig(OUT / "rovelli_area_spectrum.png", facecolor=SURFACE)
    plt.close(fig)


def fig_theta_punctures():
    fig, (ax, bx) = plt.subplots(1, 2, figsize=(11.8, 4.7), dpi=150)

    # Left: the exact NRS angle and its ceiling
    ds = np.arange(2, 201)
    th = angle_nrs_deg(ds)
    ax.plot(ds, th, "o", color=BLUE, ms=3.2, label="θ_NRS(d) = arccos(1/C_Nava(d))  (D37b)")
    ax.axhline(CEIL_DEG, color=ORANGE, lw=2, ls="--",
               label=f"ceiling arccos(1/C∞) = {CEIL_DEG:.2f}°  (limit, never attained)")
    ax.plot([4], [THETA4_DEG], "o", color=ORANGE, ms=7, mec=SURFACE, mew=1.2, zorder=6)
    ax.annotate(f"θ_NRS(4) = {THETA4_DEG:.2f}°  (floor, d ≥ 4)", (4, THETA4_DEG),
                (5.2, 2.2), color=INK2, fontsize=9.5,
                arrowprops=dict(arrowstyle="->", color=INK2, lw=0.9))
    ax.annotate("d = 2, 3: θ = 0\n(Robertson saturates)", (2.5, 0.2), (2.2, 11.0),
                color=INK2, fontsize=9.5, arrowprops=dict(arrowstyle="->", color=INK2, lw=0.9))
    ax.set_xscale("log")
    ax.set_xlim(1.8, 220)
    ax.set_ylim(0, 32)
    ax.set_xlabel("sites d of the axis  (log scale)")
    ax.set_ylabel("NRS angle  (degrees)")
    ax.legend(loc="center right", bbox_to_anchor=(1.0, 0.42), fontsize=8.6)
    ax.set_title("Granularity as dimensional uncertainty: θ_NRS(d) < 28.30°", loc="left",
                 fontsize=11.5)

    # Right: entropy by counting spin-1/2 punctures vs Bekenstein-Hawking A / (4 lp^2)
    n = np.arange(0, 41)
    a_half = 4 * np.pi * SQRT3  # A(1/2) / gamma, lp = 1
    bx.plot(n, n * np.log(2), color=BLUE, lw=2.4, label="S = n log 2  (2ⁿ puncture states)")
    bx.plot(n, n * GAMMA_BH * a_half / 4, color=ORANGE, lw=1.6, ls="--",
            label=f"A / 4ℓ_P²  at  γ = log 2 / (π√3) = {GAMMA_BH:.4f}")
    bx.plot(n, n * 0.2 * a_half / 4, color=MUTED, lw=1.2, ls=":",
            label="A / 4ℓ_P²  at  γ = 0.2  (no match)")
    bx.set_xlim(0, 40)
    bx.set_ylim(0, 40)
    bx.set_xlabel("number of punctures n  (quanta of area through the horizon)")
    bx.set_ylabel("entropy  (units of k_B)")
    bx.legend(loc="upper left", fontsize=8.6)
    bx.set_title("Rovelli, Ch. 10 — entropy by counting punctures", loc="left",
                 fontsize=11.5)

    fig.suptitle("NRS³ · Rovelli — the localization ceiling and horizon entropy", x=0.01,
                 ha="left", fontsize=13, color=INK)
    fig.tight_layout()
    fig.savefig(OUT / "rovelli_theta_punctures.png", facecolor=SURFACE)
    plt.close(fig)


if __name__ == "__main__":
    fig_area_spectrum()
    fig_theta_punctures()
