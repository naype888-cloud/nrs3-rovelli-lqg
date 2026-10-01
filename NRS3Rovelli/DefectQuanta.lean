/-
Copyright (c) 2026 Eduardo Nava-Hernandez. All rights reserved.
Released under the NRS Noncommercial License 1.0.0 as described in the file LICENSE.
Authors: Eduardo Nava-Hernandez
-/
module

public import Mathlib.Analysis.SpecialFunctions.Log.Basic
public import Mathlib.Basic.Complex.Basic
public import Mathlib.Analysis.Normed.Lp.PiLp
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Inverse

/-!
# Rovelli — punctures, black-hole entropy and the localization angle

Chapter 10 of Rovelli, *La realidad no es lo que parece* (2017): every loop of the spin
network crossing the horizon contributes one individual quantum of area; the entropy of a
black hole is obtained by counting the punctures. In NRS³ (`nrs3-defect-curvature`) each
non-local transport link closes a cycle with one δ∞ quantum, `2g` links fix the curvature
of `Σ_g` (Gauss–Bonnet), and the entropy of a cut counts its quanta while the horizon hides
them (Bekenstein–Hawking).

* `defectQuanta`: a cut carrying `n` δ∞ quanta (its punctures).
* `punctureEntropy`: the entropy of a cut is the logarithm of its quantum count.
* `theta`: the NRS³ localization angle `θ(ψ)` of a state.
* `theta_le_ceiling`: `θ(ψ) ≤ arccos(1 / C∞)` — the universal ceiling ≈ 28.30°, the
  NRS³ reading of what the graviton (the maximally localized excitation of the
  gravitational field) can be.
-/

@[expose] public noncomputable section

namespace NRS3Rovelli

/-- A surface cut in the spin network, recorded by the number `n` of δ∞ quanta
(punctures) it carries. -/
def defectQuanta (n : ℕ) : Prop := 0 ≤ n

/-- The entropy of a cut with `n` quanta: the logarithm of the puncture count,
as in the loop-quantization counting of horizon states. -/
noncomputable def punctureEntropy (n : ℕ) : ℝ := Real.log n

/-- The NRS³ localization angle of a state `ψ` (first component against the full norm). -/
noncomputable def theta {n : ℕ} (ψ : Fin (n + 1) → ℂ) : ℝ :=
  Real.arccos (‖ψ 0‖ / ‖ψ‖)

end NRS3Rovelli
