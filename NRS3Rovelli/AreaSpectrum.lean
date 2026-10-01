/-
Copyright (c) 2026 Eduardo Nava-Hernandez. All rights reserved.
Released under the NRS Noncommercial License 1.0.0 as described in the file LICENSE.
Authors: Eduardo Nava-Hernandez
-/
module

public import Mathlib.Analysis.SpecialFunctions.Pow.Real
public import Mathlib.Algebra.BigOperators.Group.List.Basic

/-!
# Rovelli — the LQG area spectrum

Chapter 6 of Rovelli, *La realidad no es lo que parece* (2017): each loop of the spin
network crossing a surface contributes one quantum of area, and the area operator has the
eigenvalues

`A(j) = 8 π γ ℓ_P² √(j (j + 1))`, `j ∈ ½ ℕ`,

with Immirzi parameter `γ` (kept generic here; the figures use `γ = 1`). A surface pierced by
punctures of spins `j₁, …, jₙ` has area `A(j₁) + ⋯ + A(jₙ)`.

## Main results

* `areaSpectrum_strictMono` : for `γ ℓ_P² > 0` the levels of nonnegative spins are strictly
  increasing.
* `areaSpectrum_half` : the lowest level is `A(1/2) = 4 π √3 γ ℓ_P²`.
* `areaSpectrum_min` : every level with `j ≥ 1/2` is at least `A(1/2)`.
* `surfaceArea_ge` : a surface with `n` punctures of spin `≥ 1/2` has area at least
  `n · A(1/2)`; no surface carries a fraction of the minimal quantum.
-/

@[expose] public noncomputable section

namespace NRS3Rovelli

open Real

/-- The LQG area spectrum `A(j) = 8 π γ ℓ_P² √(j (j + 1))` (`lp`: Planck length). -/
def areaSpectrum (lp γ j : ℝ) : ℝ := 8 * π * γ * lp ^ 2 * √(j * (j + 1))

/-- The area of a surface pierced by punctures of spins `js`. -/
def surfaceArea (lp γ : ℝ) (js : List ℝ) : ℝ := (js.map (areaSpectrum lp γ)).sum

/-- `j (j + 1) ≥ 3 / 4` for every spin `j ≥ 1/2`, with equality at `j = 1/2`. -/
theorem three_quarters_le_mul {j : ℝ} (h : 1 / 2 ≤ j) : 3 / 4 ≤ j * (j + 1) := by
  nlinarith [sq_nonneg (j - 1 / 2)]

/-- **Separated levels.** For `γ ℓ_P² > 0` and `0 ≤ j < k`, `A(j) < A(k)`. -/
theorem areaSpectrum_strictMono {lp γ : ℝ} (hγ : 0 < γ * lp ^ 2) {j k : ℝ} (hj : 0 ≤ j)
    (hjk : j < k) : areaSpectrum lp γ j < areaSpectrum lp γ k := by
  have h8 : 0 < 8 * π * γ * lp ^ 2 := by
    have := pi_pos
    calc (0 : ℝ) < 8 * π * (γ * lp ^ 2) := by positivity
      _ = _ := by ring
  have h : √(j * (j + 1)) < √(k * (k + 1)) :=
    Real.sqrt_lt_sqrt (by positivity) (by nlinarith)
  exact mul_lt_mul_of_pos_left h h8

/-- The lowest level: `A(1/2) = 4 π √3 γ ℓ_P²`. -/
theorem areaSpectrum_half (lp γ : ℝ) : areaSpectrum lp γ (1 / 2) = 4 * π * √3 * γ * lp ^ 2 := by
  have h : √((1 / 2 : ℝ) * (1 / 2 + 1)) = √3 / 2 := by
    rw [show (1 / 2 : ℝ) * (1 / 2 + 1) = 3 / 2 ^ 2 by norm_num, Real.sqrt_div' _ (by norm_num),
      Real.sqrt_sq (by norm_num)]
  rw [areaSpectrum, h]
  ring

/-- **The minimal quantum.** For `γ ℓ_P² ≥ 0` and `j ≥ 1/2`, `A(1/2) ≤ A(j)`. -/
theorem areaSpectrum_min {lp γ : ℝ} (hγ : 0 ≤ γ * lp ^ 2) {j : ℝ} (hj : 1 / 2 ≤ j) :
    areaSpectrum lp γ (1 / 2) ≤ areaSpectrum lp γ j := by
  have h8 : 0 ≤ 8 * π * γ * lp ^ 2 := by
    have := pi_pos
    calc (0 : ℝ) ≤ 8 * π * (γ * lp ^ 2) := by positivity
      _ = _ := by ring
  have h : √((1 / 2 : ℝ) * (1 / 2 + 1)) ≤ √(j * (j + 1)) :=
    Real.sqrt_le_sqrt (by nlinarith [three_quarters_le_mul hj])
  exact mul_le_mul_of_nonneg_left h h8

/-- **No fraction of a quantum.** A surface with `n` punctures, all of spin `≥ 1/2`, has area at
least `n · A(1/2)`. -/
theorem surfaceArea_ge {lp γ : ℝ} (hγ : 0 ≤ γ * lp ^ 2) (js : List ℝ)
    (hjs : ∀ j ∈ js, 1 / 2 ≤ j) :
    js.length * areaSpectrum lp γ (1 / 2) ≤ surfaceArea lp γ js := by
  induction js with
  | nil => simp [surfaceArea]
  | cons j js ih =>
    have h1 := areaSpectrum_min hγ (hjs j (by simp))
    have h2 := ih (fun k hk => hjs k (by simp [hk]))
    simp only [surfaceArea, List.map_cons, List.sum_cons, List.length_cons] at h2 ⊢
    push_cast
    linarith

/-- With all punctures at the lowest spin the area is exactly `n · A(1/2)`. -/
theorem surfaceArea_replicate (lp γ : ℝ) (n : ℕ) :
    surfaceArea lp γ (List.replicate n (1 / 2)) = n * areaSpectrum lp γ (1 / 2) := by
  simp [surfaceArea, List.map_replicate, List.sum_replicate]

end NRS3Rovelli
