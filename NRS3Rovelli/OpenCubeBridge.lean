/-
Copyright (c) 2026 Eduardo Nava-Hernandez. All rights reserved.
Released under the NRS Noncommercial License 1.0.0 as described in the file LICENSE.
Authors: Eduardo Nava-Hernandez
-/
module

public import NRS3Rovelli.CubeXYZ
public import NavaRobertsonIndependent.Mathematics.D4_WhyNotDiagonal

/-!
# The Rovelli count on a face of the open NRS cube

`CubeXYZ` counts the transport fibers across a transverse cut as `dy · dz`. Here that count is
tied to the positions of the open cube `PathGraph3D.Site3D dx dy dz = Fin dx × Fin dy × Fin dz`
of the base repository: the face `x = c` has exactly `dy · dz` positions, so the fibers of
`CubeXYZ` are the positions of that face, and the area is the one of the Minkowski fiber of
scale `a`.

Susskind and Maldacena proposed Minkowski space as `ℝ³`, infinite continuous space, with an
`S¹` fiber compactified in `t`; that is the frame of `CubeXYZ`. Nothing else of theirs is used or
claimed, and every statement below is a theorem about the cube. (Exact source to be added by the
author.)

Nothing is declared and nothing beyond the base repository and `CubeXYZ` is used.

## Main results

* `faceSites` : the positions of the cube on the face `x = c`.
* `card_faceSites` : the face has `dy · dz` positions, i.e. `transverseFibers dy dz`.
* `faceArea_eq_surfaceArea` : with `a² = 4 ℓ_P² log 2`, the area `a² · (|face| · k)` is the
  LQG area of the punctures on the face.
-/

@[expose] public noncomputable section

namespace NRS3Rovelli

open Real

/-- The positions of the open cube on the face `x = c`. -/
def faceSites (dx dy dz : ℕ) (c : Fin dx) : Finset (PathGraph3D.Site3D dx dy dz) :=
  Finset.univ.filter fun p => p.1 = c

/-- The face `x = c` of the cube has `dy · dz` positions. -/
theorem card_faceSites (dx dy dz : ℕ) (c : Fin dx) :
    (faceSites dx dy dz c).card = transverseFibers dy dz := by
  have h : (Finset.univ : Finset (Fin dy × Fin dz)).card = dy * dz := by simp
  rw [transverseFibers, ← h]
  refine Finset.card_nbij' (fun p => (p.2.1, p.2.2)) (fun q => (c, q.1, q.2)) ?_ ?_ ?_ ?_
  · intro p _
    simp
  · intro q _
    simp [faceSites]
  · intro p hp
    simp only [faceSites, Finset.mem_coe, Finset.mem_filter, Finset.mem_univ, true_and] at hp
    ext <;> simp [hp]
  · intro q _
    rfl

/-- With `a² = 4 ℓ_P² log 2`, the area of the Minkowski fibers on a face of the cube equals the
LQG area of the `|face| · k` punctures. -/
theorem faceArea_eq_surfaceArea {lp a : ℝ} (ha : a ^ 2 = 4 * lp ^ 2 * Real.log 2)
    (dx dy dz k : ℕ) (c : Fin dx) :
    a ^ 2 * (((faceSites dx dy dz c).card * k : ℕ) : ℝ) =
      surfaceAreaXYZ lp (Real.log 2 / (π * √3)) dy dz k := by
  rw [card_faceSites]
  exact minkowski_transverse_area_eq_surfaceArea ha dy dz k

end NRS3Rovelli
