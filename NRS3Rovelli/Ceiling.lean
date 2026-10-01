/-
Copyright (c) 2026 Eduardo Nava-Hernandez. All rights reserved.
Released under the NRS Noncommercial License 1.0.0 as described in the file LICENSE.
Authors: Eduardo Nava-Hernandez
-/
module

public import NavaRobertsonIndependent.Mathematics.D37b_NRSAngle

/-!
# Granularity as dimensional uncertainty: the NRS³ angle and its ceiling

In NRS³ the granularity that LQG finds in space (Chapter 6 of Rovelli) is the dimensional
uncertainty of the transport pair `(T_d, P_d)` on `T_d:P_d`, measured by the NRS angle
`θ_NRS(d) = arccos (1 / C_Nava(d))` of the base repository (`D37b`). Everything here is a
theorem of the base repository, restated; nothing is declared.

* `angleNRS_four` (base): the floor `θ_NRS(4) = arccos (1 / √((99 − 42√5)/5)) ≈ 7.43°`.
* `angle_lt_ceiling` : `θ_NRS(d) < arccos (1 / C_∞) ≈ 28.30°` for every `d ≥ 4`.
* `ceiling_not_attained` : no `d` reaches the ceiling.
* `tendsto_angle_ceiling` : `θ_NRS(d) → arccos (1 / C_∞)` (Szegő limit, `D8`).
* `ceiling_isLUB` : the ceiling is the least upper bound of the angles of every `d ≥ 4`.

**Reading (not a theorem).** The ceiling is a limit, never a state: the maximally localized
excitation that LQG calls the graviton has no finite-`d` realization at `arccos (1 / C_∞)`;
every axis stays strictly below it.
-/

@[expose] public section

namespace NRS3Rovelli

open Real Filter Topology NRSAngle Gnomon

/-- The universal ceiling `arccos (1 / C_∞)`, with `C_∞ = √(π² / 3 − 2)`. -/
noncomputable def ceiling : ℝ := arccos (1 / CoherenceConstantInf)

/-- **The ceiling bounds every axis.** `θ_NRS(4) ≤ θ_NRS(d) < arccos (1 / C_∞)` for `d ≥ 4`. -/
theorem angle_lt_ceiling {d : ℕ} (hd : 4 ≤ d) :
    angleNRS 4 ≤ angleNRS d ∧ angleNRS d < ceiling :=
  ⟨(angle_floor hd).2.1, angleNRS_lt_limit hd⟩

/-- **The ceiling is never attained.** -/
theorem ceiling_not_attained {d : ℕ} (hd : 4 ≤ d) : angleNRS d ≠ ceiling :=
  (angleNRS_lt_limit hd).ne

/-- **The ceiling is the limit.** `θ_NRS(d) → arccos (1 / C_∞)` as `d → ∞`. -/
theorem tendsto_angle_ceiling : Tendsto angleNRS atTop (𝓝 ceiling) := by
  have hC : Tendsto (fun d => arccos (1 / CoherenceConstant d)) atTop (𝓝 ceiling) := by
    have h := (tendsto_CoherenceConstant.inv₀ NRSAngle.CoherenceConstantInf_pos.ne').const_mul 1
    simp only [← div_eq_mul_inv] at h
    exact (continuous_arccos.tendsto _).comp h
  refine hC.congr' ?_
  filter_upwards [eventually_ge_atTop 2] with d hd
  exact (angleNRS_eq hd).symm

/-- **The ceiling is the supremum.** It is the least upper bound of `{θ_NRS(d) | d ≥ 4}`. -/
theorem ceiling_isLUB : IsLUB (angleNRS '' {d | 4 ≤ d}) ceiling := by
  refine ⟨?_, fun b hb => ?_⟩
  · rintro _ ⟨d, hd, rfl⟩
    exact (angleNRS_lt_limit hd).le
  · refine le_of_tendsto tendsto_angle_ceiling ?_
    filter_upwards [eventually_ge_atTop 4] with d hd
    exact hb ⟨d, hd, rfl⟩

end NRS3Rovelli
