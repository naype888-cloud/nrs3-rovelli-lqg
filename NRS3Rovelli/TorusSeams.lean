/-
Copyright (c) 2026 Eduardo Nava-Hernandez. All rights reserved.
Released under the NRS Noncommercial License 1.0.0 as described in the file LICENSE.
Authors: Eduardo Nava-Hernandez
-/
module

public import NRS3Rovelli.AreaSpectrum
public import NRS3Rovelli.PunctureEntropy
public import NRS3Rovelli.CubeXYZ

/-!
# The seams of the three-torus with loop quantum gravity

On the three-torus (T³), each axis is a closed ring. A cut across the torus plane `x = c` has two
boundaries: the plane cut and the seam cut. Each carries `dy · dz` boundary steps, giving
`2 · dy · dz` boundary steps in total.

Each boundary step is open or closed (two states), matching the `2j + 1 = 2` states of a puncture
of spin `j = 1/2`. The entropy of the cut is the entropy of `n = 2 · dy · dz` spin-1/2 punctures,
and the total area is `n · A(1/2)`. The Bekenstein–Hawking law `S = A / (4 ℓ_P²)` holds iff
`γ = log 2 / (π √3)`: the Immirzi parameter is identical to that of the open cube, with twice
the punctures.

## Main results

- `TorusSeams.cutEntropy_eq_punctureEntropy` : `S_cut = S_punct(2 dy dz, 1/2)`.
- `TorusSeams.torus_immirzi_iff` : `S = A / (4 ℓ_P²)` iff `γ = log 2 / (π √3)`.
- `TorusSeams.cutCosmologicalConstant_eq` : `Λ = 3 π / (2 ℓ² dy dz log 2)`.
- `TorusSeams.cutCosmologicalConstant_eq_half` : closing the axes halves `Λ` compared to open face.
- `TorusSeams.horizonArea_cutCosmologicalConstant` : the horizon area is `a² · 2 dy dz`.
-/

@[expose] public noncomputable section

namespace NRS3Rovelli

namespace TorusSeams

open Real

/-- The number of boundary steps of the cut on the three-torus: `2 · dy · dz`. -/
def crossStepsCount (dy dz : ℕ) : ℕ := 2 * (dy * dz)

lemma crossStepsCount_pos {dy dz : ℕ} (hy : 1 ≤ dy) (hz : 1 ≤ dz) :
    0 < crossStepsCount dy dz := by
  unfold crossStepsCount
  have : 0 < dy * dz := Nat.mul_pos hy hz
  omega

/-- The entropy of the cut on the three-torus: `(2 · dy · dz) · log 2`. -/
def cutEntropy (dy dz : ℕ) : ℝ := (crossStepsCount dy dz : ℝ) * Real.log 2

/-- **The boundary steps are punctures of spin 1/2**: the entropy of the cut is the entropy
of `2 · dy · dz` punctures. -/
theorem cutEntropy_eq_punctureEntropy (dy dz : ℕ) :
    cutEntropy dy dz = punctureEntropy (crossStepsCount dy dz) (1 / 2) := by
  unfold cutEntropy punctureEntropy
  norm_num

/-- The total area of the `2 · dy · dz` spin-1/2 punctures on the torus. -/
def torusSurfaceArea (lp γ : ℝ) (dy dz : ℕ) : ℝ :=
  surfaceArea lp γ (List.replicate (crossStepsCount dy dz) (1 / 2))

theorem torusSurfaceArea_eq (lp γ : ℝ) (dy dz : ℕ) :
    torusSurfaceArea lp γ dy dz = (crossStepsCount dy dz : ℝ) * areaSpectrum lp γ (1 / 2) :=
  surfaceArea_replicate lp γ (crossStepsCount dy dz)

/-- **Bekenstein–Hawking fixes the Immirzi parameter on the torus.** With the boundary steps as
punctures of spin 1/2, `S = A / (4 ℓ_P²)` holds iff `γ = log 2 / (π √3)`. -/
theorem torus_immirzi_iff {lp γ : ℝ} (hlp : lp ≠ 0) {dy dz : ℕ}
    (hy : 1 ≤ dy) (hz : 1 ≤ dz) :
    cutEntropy dy dz = torusSurfaceArea lp γ dy dz / (4 * lp ^ 2) ↔
      γ = Real.log 2 / (π * √3) := by
  have hp : 0 < crossStepsCount dy dz := crossStepsCount_pos hy hz
  rw [cutEntropy_eq_punctureEntropy, torusSurfaceArea]
  exact bekensteinHawking_iff_immirzi hlp hp

/-- The cosmological constant of the cut on the three-torus: `3 π / (ℓ² S_cut)`. -/
def cutCosmologicalConstant (dy dz : ℕ) (ℓ : ℝ) : ℝ :=
  3 * π / (ℓ ^ 2 * cutEntropy dy dz)

/-- **`Λ = 3 π / (2 ℓ² dy dz log 2)`.** -/
theorem cutCosmologicalConstant_eq (dy dz : ℕ) (ℓ : ℝ) :
    cutCosmologicalConstant dy dz ℓ =
      3 * π / (ℓ ^ 2 * ((2 * (dy * dz) : ℕ) * Real.log 2)) := by
  unfold cutCosmologicalConstant cutEntropy crossStepsCount
  push_cast
  rfl

/-- **Closing the axes halves `Λ`** at the same face: the torus constant is half the constant
of the cut of the open cube. -/
theorem cutCosmologicalConstant_eq_half (dy dz : ℕ) (ℓ : ℝ) :
    cutCosmologicalConstant dy dz ℓ =
      (3 * π / (ℓ ^ 2 * ((dy * dz : ℕ) * Real.log 2))) / 2 := by
  rw [cutCosmologicalConstant_eq]
  rcases eq_or_ne ℓ 0 with rfl | hℓ
  · simp
  rcases Nat.eq_zero_or_pos (dy * dz) with h | h
  · simp [h]
  have h1 : (0 : ℝ) < (dy * dz : ℕ) := by exact_mod_cast h
  have h2 := Real.log_pos one_lt_two
  push_cast
  field_simp

/-- Strict positivity of the torus cosmological constant. -/
theorem cutCosmologicalConstant_pos {dy dz : ℕ} (hy : 1 ≤ dy) (hz : 1 ≤ dz)
    {ℓ : ℝ} (hℓ : ℓ ≠ 0) : 0 < cutCosmologicalConstant dy dz ℓ := by
  unfold cutCosmologicalConstant cutEntropy
  have htop : (0 : ℝ) < 3 * π := by positivity
  have hc : (0 : ℝ) < (crossStepsCount dy dz : ℝ) := by
    exact_mod_cast (crossStepsCount_pos hy hz)
  have hbot : (0 : ℝ) < ℓ ^ 2 * ((crossStepsCount dy dz : ℝ) * Real.log 2) :=
    mul_pos (sq_pos_of_ne_zero hℓ) (mul_pos hc (Real.log_pos one_lt_two))
  exact div_pos htop hbot

/-- The horizon area `12 π / Λ` is `a² · 2 dy dz` with `a² = 4 ℓ² log 2`. -/
theorem horizonArea_cutCosmologicalConstant {dy dz : ℕ} (hy : 1 ≤ dy) (hz : 1 ≤ dz)
    {a ℓ : ℝ} (hℓ : ℓ ≠ 0) (ha : a ^ 2 = 4 * ℓ ^ 2 * Real.log 2) :
    12 * π / cutCosmologicalConstant dy dz ℓ =
      a ^ 2 * (2 * (dy * dz) : ℕ) := by
  rw [cutCosmologicalConstant_eq, ha]
  have hπ : π ≠ 0 := Real.pi_ne_zero
  have hℓ2 : ℓ ^ 2 ≠ 0 := (sq_pos_of_ne_zero hℓ).ne'
  have hlog : Real.log 2 ≠ 0 := (Real.log_pos one_lt_two).ne'
  have hc : ((2 * (dy * dz) : ℕ) : ℝ) ≠ 0 := by
    have : 0 < 2 * (dy * dz) := crossStepsCount_pos hy hz
    exact_mod_cast this.ne'
  field_simp
  ring

end TorusSeams

end NRS3Rovelli
