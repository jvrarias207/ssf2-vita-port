# Version 0.34 corrected — source timeline repair

This replaces the former 0.34 package without changing its installation title ID or version. The title and startup log identify it as `0.34 corrected`. A copy of the previous VPK and key edited inputs was retained in `C:/Users/javon/AppData/Local/Temp/opencode/ssf2-before-corrected-034`.

## Source mapping

| Animation | Symbol | Source frames (one-based) | Transition |
| --- | --- | --- | --- |
| Run | 1102 | 1–15 | Frame 15 script redirects to run frame 1 |
| Dash-start | 1102 | 16–21 | Frame 21 script redirects to run |
| Turn | 1102 | 22–31 | Frame 31 script redirects to run; reverse facing on completion |
| Skid | 1103 | 1–7 | Frame 7 ends the state |
| Normal Land | 1108 | 1–3 | Frame 3 restores control |
| Dodge Land artwork (stored, unused) | 1108 | 4–8 | Separate `dodgeland` label, not normal landing lag |

Sources are `resource-scripts/DAT357/scripts/mario_fla/Turn_15.as`, `Skid_16.as`, `Land_21.as`, and `prototype-assets/mario.xml`. Terminal frame scripts run before rendering in this native implementation: e.g. Skid's images 1–6 display and frame 7 ends it. This intentionally does not display terminal redirect frames as an extra held image.

Index entries now reference the real source classes, and sliced frames retain their original source numbers. Full 1102 SVGs are preserved together in `prototype-assets/animation-svg/DefineSprite_1102_mario_fla.Turn_15`. Existing user exports and old folders were not deleted.

## Behavior repaired

- Skid selection precedes ordinary locomotion after releasing a run. It advances rather than remaining on image 1.
- Ordinary falling/jumping landings and aerial autocancels enter normal Land. Landing recovery does not run through the dodge-land artwork. Aerial-specific landing continuations are preserved.
- Dash startup uses original `AccelStartDash * MaxXSpeed = 1.1 * 11 = 12.1`; subsequent acceleration/deceleration approaches run speed 11. Walking starts at `0.5 * 4 = 2`, not 1.1. Ground acceleration remains 1.1 and ground deceleration 1.04. Air-control speed uses Mario's max_jumpSpeed 7, with acceleration 0.7.
- Quick reversals during initial Dash retain the user-requested momentum reversal (custom dash dance) without the invented minimum-speed boost of 6. Reversing an established run uses the authored Turn segment, braking during it and changing facing once upon returning to Run. This is not a complete port of SSF2's movement state machine or platform-friction rules.
- Directional smash input explicitly sets attack facing, even if it interrupts a turn.
- Collision helpers for every pose are freshly extracted from the SVG helper transforms. Walk hurtboxes are no longer substituted for Run/Turn/Skid/Land. Enlarged up-air attack boxes were restored to original SVG geometry. The invented distance-dependent back-air sourspot was removed; its early/late source stats remain.
- Full smash charge takes 60 charging ticks and holds for up to 120 more ticks before automatic release. Damage stops at 1.4x and the HUD at 100%. These timing limits and the right-stick/custom button mappings are user choices, not claims of source equivalence.

## Validation

### Initial-dash release follow-up

On releasing direction during initial Dash, a pending-stop flag preserves the remaining startup frames and the acceleration/run-speed target. Its terminal event enters Skid instead of Run and clears run intent. With no input, normal ground deceleration brings Mario to rest. A single direction press switches to Walk; two fresh presses within the existing 12-tick window restart Dash at its startup frame/speed. Releasing the previous dash clears its old tap history so it cannot incorrectly turn the first new press into a double tap. Attack, jump/airborne transitions, and reset clear the pending stop. Full-run release and held-direction reversals retain their prior behavior. Regression tests exercise release at startup, deferred skid, stopping, walking and renewed double taps in both directions.

### Fast-fall follow-up

Added only fast fall; the requested dash modification was subsequently cancelled, so dash logic is unchanged. Source references: Mario `resource-scripts/DAT357/scripts/Main.as` lines 42, 47–48 (`gravity=1.3`, `max_ySpeed=13`, `fastFallSpeed=16`), and engine `ssf2 exports/scripts/com/mcleodgaming/ssf2/engine/Character.as`, `m_charFall`, lines 6473–6498. The source adds gravity only below the normal cap and sets vertical speed directly to 16 on a newly pressed Down while descending, excluding injured/flying states. Preserving speeds already above 13 allows fast fall to persist after release, without a separate fast-fall timer. Landing resets vertical speed through collision; jumping overwrites it with upward speed. Down edges are tracked per fighter at simulation tick frequency. The native prototype still does not implement every excluded source state, attack-specific AirEase, or midair constant-jump timer.

Regression coverage verifies immediate 16-unit descent, release persistence, ascent/held-Down rejection, re-press activation, normal cap, up-air compatibility, injury exclusion, landing and respawn. All existing movement/dash tests are retained.

Renderer-independent Windows regression checks cover recovery, ground attacks, aerials, movement startup/turn/skid/normal land, both facings, directional smash overrides, capped charged hit damage, and the exact 60+120 charge boundary. They are also invoked at Vita startup and logged to `ux0:data/SSF2P0001/log.txt`.

`check-animation-data.py` verifies source frame slices/events and matching enum/geometry/atlas ordering. `regenerate-authored-boxes.cjs --check` independently re-extracts SVG helpers and compares against the saved geometry. All 817 images were rasterized without clipped cell edges and passed packed-texture round-trip checks; the sprite texture remains 8 MiB.

Hardware gameplay has not been verified for this replacement. Test short-hop up-air and autocancel, normal jumps/landings, run release/skid, initial dash dance, full-run turns in both directions, right-stick reverse smash, and capped charge/automatic release. The prototype still approximates collision, recovery/state exceptions, hitbox priority, costume colors and effects; it is not a complete Flash engine reproduction.
