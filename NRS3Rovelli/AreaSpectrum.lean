/-
Copyright (c) 2026 Eduardo Nava-Hernandez. All rights reserved.
Released under the NRS Noncommercial License 1.0.0 as described in the file LICENSE.
Authors: Eduardo Nava-Hernandez
-/
module

public import Mathlib.Analysis.SpecialFunctions.Sqrt
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Inverse
public import Mathlib.Analysis.Normed.Lp.PiLp

/-!
# Rovelli — LQG area quanta and the δ∞ defect quanta

Chapter 6 of Rovelli, *La realidad no es lo que parece* (2017): the Faraday lines of the
gravitational field close into loops; each loop crossing a surface contributes one quantum
of area. The eigenvalues of the area operator are

`A(j) = 8 π γ lp² √(j (j + 1))`, `j ∈ ½ ℕ`,

with Immirzi parameter `γ`. There is no surface that is a tenth of `8 π lp²`: space is
granular. In NRS³ (see the base repository) that granularity is read as *dimensional
uncertainty*, quantified by `C_Nava(d)` and the localization angle `θ(ψ)` bounded by
`arccos(1 / C∞) ≈ 28.30°`; the numerical example in dimension `d = 4` is `θ(4) = 7.43°`.

* `areaSpectrum`: the discrete area spectrum with Immirzi parameter `γ`.
* `areaSpectrum_mono`: for nonnegative spins the spectrum is monotone — the eigenvalues
  are separated (discreteness in the sense of ordered, non-accumulating levels).
* `areaSpectrum_min`: every eigenvalue with spin `j ≥ 1/2` dominates the minimal quantum
  `4 π √3 lp² γ` (i.e. `8 π lp² γ √3 / 2`), so no surface is smaller than one quantum.
-/

@[expose] public noncomputable section

namespace NRS3Rovelli

open Real

/-- The LQG area spectrum `A(j) = 8 π γ lp² √(j (j + 1))` (`lp`: Planck length, `γ`: Immirzi). -/
def areaSpectrum (lp γ j : ℝ) : ℝ := 8 * π * γ * lp ^ 2 * Real.sqrt (j * (j + 1))

/-- **Monotonicity of the spectrum**: for `0 ≤ j ≤ k`, `A(j) ≤ A(k)` whenever `γ lp² ≥ 0`,
so the area levels of nonnegative spins are ordered and separated. -/
theorem areaSpectrum_mono (lp γ : ℝ) (hγ : 0 ≤ γ * lp ^ 2) {j k : ℝ}
    (hjk : j ≤ k) (hj : 0 ≤ j) : areaSpectrum lp γ j ≤ areaSpectrum lp γ k := by
  have h1 : j * (j + 1) ≤ k * (k + 1) := by nlinarith
  have h2 := Real.sqrt_le_sqrt h1
  have h8 : 0 ≤ 8 * π * γ * lp ^ 2 := by
    calc 8 * π * γ * lp ^ 2 = 8 * π * (γ * lp ^ 2) := by ring
    _ ≥ 0 := by positivity
  rw [areaSpectrum, areaSpectrum]
  exact mul_le_mul_of_nonneg_left h2 h8

/-- The square `j (j + 1)` dominates `3 / 4` for every half-integer spin `j ≥ 1/2`
(note: the bound is vacuous already at `j = 0`, where the statement still holds). -/
theorem three_quarters_le_mul (j : ℝ) (h : 1 / 2 ≤ j) : 3 / 4 ≤ j * (j + 1) := by
  nlinarith [sq_nonneg (j - 1 / 2)]

/-- **The minimal quantum**: for `j ≥ 1/2` and `γ lp² ≥ 0`, every area eigenvalue is at least
`4 π √3 γ lp² = 8 π γ lp² √3 / 2` — the smallest possible quantum of area. -/
theorem areaSpectrum_min (lp γ : ℝ) (hγ : 0 ≤ γ * lp ^ 2) {j : ℝ}
    (hj : 1 / 2 ≤ j) : 4 * π * √3 * γ * lp ^ 2 ≤ areaSpectrum lp γ j := by
  have h1 : 3 / 4 ≤ j * (j + 1) := three_quarters_le_mul j hj
  have h2 : √3 / 2 ≤ Real.sqrt (j * (j + 1)) := by
    have h0 : √3 / 2 = Real.sqrt (3 / 4 : ℝ) := by
      have hp : 0 < √3 / 2 := by positivity
      have h0' : Real.sqrt (3 / 4 : ℝ) = √3 / 2 := by
        rw [Real.sqrt_eq_iff_mul_self_eq_of_pos hp, div_mul_div_comm,
          Real.mul_self_sqrt (show (0:ℝ) ≤ 3 by norm_num)]
        norm_num
      exact h0'.symm
    rw [h0]
    exact Real.sqrt_le_sqrt h1
  rw [areaSpectrum]
  have h8 : 0 ≤ 8 * π * γ * lp ^ 2 := by
    calc 8 * π * γ * lp ^ 2 = 8 * π * (γ * lp ^ 2) := by ring
    _ ≥ 0 := by positivity
  calc 4 * π * √3 * γ * lp ^ 2
      = 8 * π * γ * lp ^ 2 * (√3 / 2) := by ring
    _ ≤ 8 * π * γ * lp ^ 2 * Real.sqrt (j * (j + 1)) :=
        mul_le_mul_of_nonneg_left h2 h8

end NRS3Rovelli
