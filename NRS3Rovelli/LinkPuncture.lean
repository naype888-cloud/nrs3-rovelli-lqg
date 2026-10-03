/-
Copyright (c) 2026 Eduardo Nava-Hernandez. All rights reserved.
Released under the NRS Noncommercial License 1.0.0 as described in the file LICENSE.
Authors: Eduardo Nava-Hernandez
-/
module

public import NRS3Rovelli.PunctureEntropy
public import NavaRobertsonIndependent.Mathematics.D16g_CutEntropy

/-!
# A link is a puncture

The entropy of punctures is not a second entropy: it is the entropy of a cut of the base
repository (`D16g`). A cut with `M` crossing links and a puncture of spin `j` count the same
states when `M = 2j + 1`; the cut between the sites `0` and `1` of the path on four sites has
`M = 2`, the count of a spin `1/2` puncture.

There is one Bekenstein–Hawking bridge, `HBekensteinHawking` of the base repository. On a cut
with `M = 2` it gives each link the area `4 ℓ_P² log 2`, which is the LQG level `A(1/2)` exactly
at the Immirzi value `γ = log 2 / (π √3)` of `bekensteinHawking_iff_immirzi`.

## Main results

- `NRS3Rovelli.cutEntropy_eq_punctureEntropy` : `M = 2j + 1` gives `S_cut(k) = S_punct(k, j)`.
- `NRS3Rovelli.numCross_three_zero` : the cut at `0` on four sites has `M = 2`.
- `NRS3Rovelli.cutEntropy_spin_half` : there, `k` links are `k` spin `1/2` punctures.
- `NRS3Rovelli.link_area_eq_puncture` : under the base bridge, one link has the area `A(1/2)`
  at the Bekenstein–Hawking value of `γ`.
-/

@[expose] public noncomputable section

namespace NRS3Rovelli

open Real CutEntropy

/-- **The dictionary**: with `M = 2j + 1`, `k` quanta on the cut have the entropy of `k`
punctures of spin `j`. -/
theorem cutEntropy_eq_punctureEntropy {n c k : ℕ} {j : ℝ}
    (hM : (numCross n c : ℝ) = 2 * j + 1) : entropy n c k = punctureEntropy k j := by
  rw [entropy_eq, punctureEntropy, hM]

theorem numCross_three_zero : numCross 3 0 = 2 := by decide

/-- On the cut at `0` of the path on four sites, `k` links are `k` spin `1/2` punctures. -/
theorem cutEntropy_spin_half (k : ℕ) : entropy 3 0 k = punctureEntropy k (1 / 2) :=
  cutEntropy_eq_punctureEntropy (by rw [numCross_three_zero]; norm_num)

/-- **One link, one puncture.** Under the base Bekenstein–Hawking bridge on a cut with
`M = 2`, the area of one link quantum `a₀ δ_∞` is the LQG level `A(1/2)` at
`γ = log 2 / (π √3)`. -/
theorem link_area_eq_puncture {n c : ℕ} (H : HBekensteinHawking n c) {lp : ℝ}
    (hlp : H.planckArea = lp ^ 2) (hM : numCross n c = 2) :
    H.areaPerDefect * Gnomon.deltaInf = areaSpectrum lp (Real.log 2 / (π * √3)) (1 / 2) := by
  rw [H.areaPerDefect_eq, areaSpectrum_half, hlp, hM]
  have : π * √3 ≠ 0 := by positivity
  field_simp [Gnomon.deltaInf_pos.ne']
  push_cast
  ring

end NRS3Rovelli
