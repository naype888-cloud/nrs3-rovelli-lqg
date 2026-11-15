/-
Copyright (c) 2026 Eduardo Nava-Hernandez. All rights reserved.
Released under the NRS Noncommercial License 1.0.0 as described in the file LICENSE.
Authors: Eduardo Nava-Hernandez
-/
module

public import NRS3Rovelli.AreaSpectrum
public import NRS3Rovelli.PunctureEntropy
public import NRS3Rovelli.LinkPuncture
public import NavaRobertsonIndependent.Mathematics.D16g_CutEntropy
public import NavaRobertsonIndependent.Mathematics.D37_PathGraph3D

/-!
# Cube XYZ: Continuous Space ℝ³, Minkowski ℝ³ × S¹ and the Fiber at Scale a

Space ℝ³ is open, continuous and infinite. There is no rigid wire mesh or discrete lattice
of spacetime: what is discretized is the resolution dimension `d` of the metric transport
generator `(T_d, P_d)` along each continuous Cartesian axis `X, Y, Z`, forming the tensor
product state space `ℋ_{d³} = ℋ_d^{(x)} ⊗ ℋ_d^{(y)} ⊗ ℋ_d^{(z)}` of 3D motion in continuous space.

Spacetime is Minkowski `ℝ³ × S¹` with a proper time fiber on `S¹` at generator scale `a`:
* Pure 3D space (`d ≤ 3`): the Gram defect vanishes identically (`defectGram = 0`, `C_N = 1`),
  motion is luminal (`dτ = 0`), and photons travel without mass or internal clock.
* Proper time fibration (`d = 4`): advancing along the proper time fiber (`dτ > 0`) activates
  the 4th dimension, turning on the Dirac Clifford matrices and the irreducible Szegő defect
  `C_M(4) = (94 − 42√5)/5 ≈ 0.017029 > 0`.
* Positivity lock: Hilbert space positivity (`⟨ψ|ψ⟩ ≥ 0`) guarantees `defectGram(d) ≥ 0`;
  there are no negative defects and no causal retrocession.

Across a transverse plane in continuous space spanned by axes `Y` and `Z` with sampling
resolutions `dy, dz`, the transverse count of transport fibers is `dy · dz`. Each fiber across
a cut at scale `a` carries `k` link quanta, giving `(dy · dz) · k` spin-1/2 punctures.

## Main results

* `transverseFibers` : the transverse fiber count `dy · dz`.
* `punctureCountXYZ` : total spin-1/2 punctures across the transverse slice: `(dy · dz) · k`.
* `punctureEntropyXYZ` : total entropy `(dy · dz) · S_1D = (dy · dz · k) log 2`.
* `surfaceAreaXYZ` : total LQG discrete area `(dy · dz · k) · A(1/2)`.
* `immirzi_bekensteinHawking_iff` : `S = A / (4 ℓ_P²)` holds iff `γ = log 2 / (π √3)`.
* `minkowski_fiber_area_eq_lqg_quantum` : the Minkowski fiber area `a² = 4 ℓ_P² log 2` is
  identically the lowest LQG area quantum `A(1/2)` at `γ_BH`.
* `minkowski_transverse_area_eq_surfaceArea` : the total geometric transverse area `a² · (dy·dz·k)`
  matches the LQG puncture area.
* `cosmologicalConstantXYZ` : `Λ = 3 π / (ℓ² S) = 3 π / (ℓ² dy dz k log 2)`.
* `cosmologicalConstantXYZ_pos` : strictly positive cosmological constant (`Λ > 0`).
* `cosmologicalConstantXYZ_strictAnti_area` : larger transverse area gives smaller `Λ`.
* `horizonAreaXYZ_eq` : horizon area `12 π / Λ = a² · (dy · dz · k)` with `a² = 4 ℓ² log 2`.
-/

@[expose] public noncomputable section

namespace NRS3Rovelli

open Real Filter Topology CutEntropy

/-- The number `dy · dz` of transport fibers across the transverse continuous plane. -/
def transverseFibers (dy dz : ℕ) : ℕ := dy * dz

lemma transverseFibers_pos {dy dz : ℕ} (hy : 1 ≤ dy) (hz : 1 ≤ dz) :
    0 < transverseFibers dy dz :=
  Nat.mul_pos hy hz

/-- Total spin-1/2 punctures across the transverse slice with `k` quanta per fiber. -/
def punctureCountXYZ (dy dz k : ℕ) : ℕ := transverseFibers dy dz * k

lemma punctureCountXYZ_pos {dy dz k : ℕ} (hy : 1 ≤ dy) (hz : 1 ≤ dz) (hk : 1 ≤ k) :
    0 < punctureCountXYZ dy dz k :=
  Nat.mul_pos (transverseFibers_pos hy hz) hk

/-- Total entropy of the transverse slice: `(dy · dz) · S_1D`. -/
def punctureEntropyXYZ (dy dz k : ℕ) : ℝ :=
  (transverseFibers dy dz : ℝ) * punctureEntropy k (1 / 2)

/-- The discrete area law on continuous space: entropy is proportional to transverse fibers. -/
theorem punctureEntropyXYZ_eq_area_mul (dy dz k : ℕ) :
    punctureEntropyXYZ dy dz k = (transverseFibers dy dz : ℝ) * punctureEntropy k (1 / 2) := rfl

/-- Explicit formula for the transverse puncture entropy: `(dy · dz · k) log 2`. -/
theorem punctureEntropyXYZ_eq_log (dy dz k : ℕ) :
    punctureEntropyXYZ dy dz k = (punctureCountXYZ dy dz k : ℝ) * Real.log 2 := by
  unfold punctureEntropyXYZ punctureCountXYZ punctureEntropy
  push_cast
  norm_num
  ring

lemma punctureEntropyXYZ_pos {dy dz k : ℕ} (hy : 1 ≤ dy) (hz : 1 ≤ dz) (hk : 1 ≤ k) :
    0 < punctureEntropyXYZ dy dz k := by
  rw [punctureEntropyXYZ_eq_log]
  have hc : (0 : ℝ) < (punctureCountXYZ dy dz k : ℕ) := by
    exact_mod_cast (punctureCountXYZ_pos hy hz hk)
  have hl : (0 : ℝ) < Real.log 2 := Real.log_pos one_lt_two
  exact mul_pos hc hl

/-- Total surface area of the punctures across the transverse slice. -/
def surfaceAreaXYZ (lp γ : ℝ) (dy dz k : ℕ) : ℝ :=
  (punctureCountXYZ dy dz k : ℝ) * areaSpectrum lp γ (1 / 2)

theorem surfaceAreaXYZ_eq (lp γ : ℝ) (dy dz k : ℕ) :
    surfaceAreaXYZ lp γ dy dz k =
      surfaceArea lp γ (List.replicate (punctureCountXYZ dy dz k) (1 / 2)) := by
  rw [surfaceArea_replicate, surfaceAreaXYZ]

/-- **Bekenstein–Hawking fixes the Immirzi parameter on Cube XYZ.** For any transverse slice
(`1 ≤ dy`, `1 ≤ dz`), `1 ≤ k` links per fiber, and `ℓ_P ≠ 0`, `S = A / (4 ℓ_P²)` holds
if and only if `γ = log 2 / (π √3)`. -/
theorem immirzi_bekensteinHawking_iff {lp γ : ℝ} (hlp : lp ≠ 0) {dy dz k : ℕ}
    (hy : 1 ≤ dy) (hz : 1 ≤ dz) (hk : 1 ≤ k) :
    punctureEntropyXYZ dy dz k = surfaceAreaXYZ lp γ dy dz k / (4 * lp ^ 2) ↔
      γ = Real.log 2 / (π * √3) := by
  have hp : 0 < punctureCountXYZ dy dz k := punctureCountXYZ_pos hy hz hk
  rw [punctureEntropyXYZ_eq_log, surfaceAreaXYZ]
  have h_punct : punctureEntropy (punctureCountXYZ dy dz k) (1 / 2) =
      (punctureCountXYZ dy dz k : ℝ) * Real.log 2 := by
    unfold punctureEntropy; norm_num
  rw [← h_punct, ← surfaceArea_replicate]
  exact bekensteinHawking_iff_immirzi hlp hp

/-- **The Minkowski fiber area matches the LQG quantum**: with fiber scale `a`,
`a² = 4 ℓ_P² log 2` is identically the lowest LQG area quantum `A(1/2)` at `γ_BH`. -/
theorem minkowski_fiber_area_eq_lqg_quantum {lp : ℝ} {a : ℝ}
    (ha : a ^ 2 = 4 * lp ^ 2 * Real.log 2) :
    a ^ 2 = areaSpectrum lp (Real.log 2 / (π * √3)) (1 / 2) := by
  rw [areaSpectrum_half, ha]
  have : π * √3 ≠ 0 := by positivity
  field_simp

/-- The total geometric transverse area `a² · (dy · dz · k)` matches the LQG puncture area. -/
theorem minkowski_transverse_area_eq_surfaceArea {lp : ℝ} {a : ℝ}
    (ha : a ^ 2 = 4 * lp ^ 2 * Real.log 2) (dy dz k : ℕ) :
    a ^ 2 * (punctureCountXYZ dy dz k : ℝ) =
      surfaceAreaXYZ lp (Real.log 2 / (π * √3)) dy dz k := by
  rw [surfaceAreaXYZ, minkowski_fiber_area_eq_lqg_quantum ha]
  ring

/-- Under the base Bekenstein–Hawking bridge, the defect area of one link matches `A(1/2)`. -/
theorem base_bridge_link_area_eq_quantum {lp : ℝ} (H : HBekensteinHawking 3 0)
    (hlp : H.planckArea = lp ^ 2) :
    H.areaPerDefect * Gnomon.deltaInf =
      areaSpectrum lp (Real.log 2 / (π * √3)) (1 / 2) :=
  link_area_eq_puncture H hlp numCross_three_zero

/-- The cosmological constant fixed by the transverse puncture entropy: `3 π / (ℓ² S)`. -/
def cosmologicalConstantXYZ (dy dz k : ℕ) (ℓ : ℝ) : ℝ :=
  3 * π / (ℓ ^ 2 * punctureEntropyXYZ dy dz k)

/-- Explicit form: `Λ = 3 π / (ℓ² · (dy · dz · k) · log 2)`. -/
theorem cosmologicalConstantXYZ_eq (dy dz k : ℕ) (ℓ : ℝ) :
    cosmologicalConstantXYZ dy dz k ℓ =
      3 * π / (ℓ ^ 2 * ((punctureCountXYZ dy dz k : ℝ) * Real.log 2)) := by
  unfold cosmologicalConstantXYZ
  rw [punctureEntropyXYZ_eq_log]

/-- Strict positivity of the cosmological constant (`Λ > 0`) on continuous space ℝ³. -/
theorem cosmologicalConstantXYZ_pos {dy dz k : ℕ} (hy : 1 ≤ dy) (hz : 1 ≤ dz) (hk : 1 ≤ k)
    {ℓ : ℝ} (hℓ : ℓ ≠ 0) : 0 < cosmologicalConstantXYZ dy dz k ℓ := by
  unfold cosmologicalConstantXYZ
  have htop : (0 : ℝ) < 3 * π := by positivity
  have hbot : (0 : ℝ) < ℓ ^ 2 * punctureEntropyXYZ dy dz k :=
    mul_pos (sq_pos_of_ne_zero hℓ) (punctureEntropyXYZ_pos hy hz hk)
  exact div_pos htop hbot

/-- Larger transverse area gives a strictly smaller cosmological constant. -/
theorem cosmologicalConstantXYZ_strictAnti_area {dy₁ dy₂ dz k : ℕ} (hy₁ : 1 ≤ dy₁)
    (hdy : dy₁ < dy₂) (hz : 1 ≤ dz) (hk : 1 ≤ k) {ℓ : ℝ} (hℓ : ℓ ≠ 0) :
    cosmologicalConstantXYZ dy₂ dz k ℓ < cosmologicalConstantXYZ dy₁ dz k ℓ := by
  rw [cosmologicalConstantXYZ_eq, cosmologicalConstantXYZ_eq]
  have htop : (0 : ℝ) < 3 * π := by positivity
  have hℓ2 : (0 : ℝ) < ℓ ^ 2 := sq_pos_of_ne_zero hℓ
  have hlog : (0 : ℝ) < Real.log 2 := Real.log_pos one_lt_two
  have hc₁ : (0 : ℝ) < (punctureCountXYZ dy₁ dz k : ℝ) := by
    exact_mod_cast (punctureCountXYZ_pos hy₁ hz hk)
  have hc_lt : (punctureCountXYZ dy₁ dz k : ℝ) < (punctureCountXYZ dy₂ dz k : ℝ) := by
    unfold punctureCountXYZ transverseFibers
    push_cast
    have hz_pos : (0 : ℝ) < (dz : ℝ) := by positivity
    have hk_pos : (0 : ℝ) < (k : ℝ) := by positivity
    have hdy_lt : (dy₁ : ℝ) < (dy₂ : ℝ) := by exact_mod_cast hdy
    have h1 : (dy₁ : ℝ) * (dz : ℝ) < (dy₂ : ℝ) * (dz : ℝ) :=
      mul_lt_mul_of_pos_right hdy_lt hz_pos
    exact mul_lt_mul_of_pos_right h1 hk_pos
  have hbot₁ : (0 : ℝ) < ℓ ^ 2 * ((punctureCountXYZ dy₁ dz k : ℝ) * Real.log 2) :=
    mul_pos hℓ2 (mul_pos hc₁ hlog)
  have hbot_lt : ℓ ^ 2 * ((punctureCountXYZ dy₁ dz k : ℝ) * Real.log 2) <
      ℓ ^ 2 * ((punctureCountXYZ dy₂ dz k : ℝ) * Real.log 2) :=
    mul_lt_mul_of_pos_left (mul_lt_mul_of_pos_right hc_lt hlog) hℓ2
  exact div_lt_div_of_pos_left htop hbot₁ hbot_lt

/-- The horizon area `12 π / Λ` matches the puncture area `a² · (dy · dz · k)` with
`a² = 4 ℓ² log 2`. -/
theorem horizonAreaXYZ_eq {dy dz k : ℕ} (hy : 1 ≤ dy) (hz : 1 ≤ dz) (hk : 1 ≤ k)
    {a ℓ : ℝ} (hℓ : ℓ ≠ 0) (ha : a ^ 2 = 4 * ℓ ^ 2 * Real.log 2) :
    12 * π / cosmologicalConstantXYZ dy dz k ℓ =
      a ^ 2 * (punctureCountXYZ dy dz k : ℝ) := by
  rw [cosmologicalConstantXYZ_eq, ha]
  have hπ : π ≠ 0 := Real.pi_ne_zero
  have hℓ2 : ℓ ^ 2 ≠ 0 := (sq_pos_of_ne_zero hℓ).ne'
  have hlog : Real.log 2 ≠ 0 := (Real.log_pos one_lt_two).ne'
  have hc : (punctureCountXYZ dy dz k : ℝ) ≠ 0 := by
    exact_mod_cast (punctureCountXYZ_pos hy hz hk).ne'
  field_simp
  ring

end NRS3Rovelli
