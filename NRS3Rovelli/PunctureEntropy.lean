/-
Copyright (c) 2026 Eduardo Nava-Hernandez. All rights reserved.
Released under the NRS Noncommercial License 1.0.0 as described in the file LICENSE.
Authors: Eduardo Nava-Hernandez
-/
module

public import NRS3Rovelli.AreaSpectrum
public import Mathlib.Analysis.SpecialFunctions.Log.Basic

/-!
# Rovelli — black-hole entropy by counting punctures

Chapter 10 of Rovelli, *La realidad no es lo que parece* (2017): every loop of the spin network
crossing the horizon is one quantum of area, and the entropy of the hole counts the states of
those punctures. A puncture of spin `j` has `2 j + 1` states, so `n` punctures of spin `j` have
`(2 j + 1)ⁿ` states and entropy `n log (2 j + 1)`: linear in the number of quanta, as the
entropy of a cut in `nrs3-defect-curvature` is linear in its `δ∞` quanta.

## Main results

* `punctureEntropy_eq_log_card` : the entropy is the logarithm of the state count.
* `punctureEntropy_add` : the entropy is additive in the punctures.
* `entropy_proportional_to_area` : at spin `1/2`, `S = (log 2 / A(1/2)) · A`.
* `bekensteinHawking_iff_immirzi` : `S = A / (4 ℓ_P²)` holds iff `γ = log 2 / (π √3)`.
-/

@[expose] public noncomputable section

namespace NRS3Rovelli

open Real

/-- The entropy of `n` punctures of spin `j`: `n log (2 j + 1)`. -/
def punctureEntropy (n : ℕ) (j : ℝ) : ℝ := n * Real.log (2 * j + 1)

/-- The entropy is the logarithm of the number `(2 j + 1)ⁿ` of puncture states. -/
theorem punctureEntropy_eq_log_card (n : ℕ) (j : ℝ) :
    punctureEntropy n j = Real.log ((2 * j + 1) ^ n) := by
  rw [punctureEntropy, Real.log_pow]

/-- The entropy is additive: `S(n + m) = S(n) + S(m)`. -/
theorem punctureEntropy_add (n m : ℕ) (j : ℝ) :
    punctureEntropy (n + m) j = punctureEntropy n j + punctureEntropy m j := by
  simp only [punctureEntropy]
  push_cast
  ring

/-- **Entropy ∝ area.** With `n` punctures of spin `1/2` and `A(1/2) ≠ 0`, the entropy is
`(log 2 / A(1/2))` times the area of the surface. -/
theorem entropy_proportional_to_area {lp γ : ℝ} (h : areaSpectrum lp γ (1 / 2) ≠ 0) (n : ℕ) :
    punctureEntropy n (1 / 2) =
      Real.log 2 / areaSpectrum lp γ (1 / 2) * surfaceArea lp γ (List.replicate n (1 / 2)) := by
  rw [surfaceArea_replicate, punctureEntropy]
  field_simp
  norm_num

/-- **Bekenstein–Hawking fixes the Immirzi parameter.** For `n ≥ 1` spin-`1/2` punctures and
`ℓ_P ≠ 0`, `S = A / (4 ℓ_P²)` holds exactly when `γ = log 2 / (π √3)`. -/
theorem bekensteinHawking_iff_immirzi {lp γ : ℝ} (hlp : lp ≠ 0) {n : ℕ} (hn : 0 < n) :
    punctureEntropy n (1 / 2) = surfaceArea lp γ (List.replicate n (1 / 2)) / (4 * lp ^ 2) ↔
      γ = Real.log 2 / (π * √3) := by
  have hπ : π * √3 ≠ 0 := by positivity
  have hn' : (n : ℝ) ≠ 0 := by exact_mod_cast hn.ne'
  rw [surfaceArea_replicate, areaSpectrum_half, punctureEntropy, eq_div_iff hπ]
  constructor
  · intro h
    field_simp at h
    norm_num at h
    linear_combination -h
  · intro h
    field_simp
    norm_num
    rw [← h]
    ring

end NRS3Rovelli
