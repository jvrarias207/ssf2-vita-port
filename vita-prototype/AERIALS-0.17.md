# Mario aerials — version 0.17

Source: supplied DAT357 Main.as attack data and mario_fla frame scripts, with geometry extracted from DAT357.swf. Frame numbers below are one-based source timeline frames. Simulation runs at 30 ticks/second.

| Move | Active source frames | Damage | Launch angle |
|---|---|---|---|
| Neutral air | 3–13 | 12%, then 8% from frame 5 | 40°, then 55° |
| Forward air | 9–10 | 16% | Frame 9 boxes 1/3: 300° meteor; box 2: 55°. Frame 10: 55° |
| Back air | 4–8 | 13%, then 9% from frame 6 | 40°, directed away from attacker |
| Up air | 3–5 | 7% | Box 1: 60°; box 2: 45° |
| Down air | 6, 7, 9, 11, 13; landing 21 | 2% per successful hit | 80° |

Down air refreshes attack identity at frames 7, 9, 11 and 13, and again on landing. Each identity hits the target once. There is no invented strong finisher. Landing box 1 uses weight-based knockback 40; box 2 retains 30. Forward-air meteor boxes do not reverse their angle around the attacker; a grounded target receives the source-style reflected upward trajectory.

## Landing and control

| Move | Landing-lag window | Landing continuation starts |
|---|---|---|
| Neutral air | 3–16 | 22 |
| Forward air | 2–24 | 31 |
| Back air | 3 through aerial end | 24 |
| Up air | 2–8 | 17 |
| Down air | 3–16 | 21 |

Outside those windows, landing uses a two-tick normal landing control lock with the idle pose. Dedicated normal-landing artwork is not included. Forward air permits a late jump/attack cancel from frame 25. Aerial drifting preserves facing so backward input can select back air. Circle remains a grounded smash input.

The shared physics documented in `../PHYSICS-BASELINE.md` remains the baseline for future fighters. Aerial-specific recovery multipliers are 1.1 for neutral/back air, 1.2 for up air, 1.23 for down air; forward air uses 1 for non-reversing boxes and 1.1 for box 2. These scale the moving recovery timer, not the short impact pause.

## Verification and scope

Vita build and package validation passed. All 771 extracted frames passed atlas round-trip checks and no clipping was detected; the packed sprite texture is 8 MiB. Startup checks cover both facings, early damage, once-per-identity hits, landing continuation/autocancel, backward drift, late stat changes and down-air refreshes. These checks are compiled but await execution on Vita. Windows verification was skipped at the user's request.

Test all five moves facing both directions, early/late landing, down-air repeated hits, and forward air against grounded and airborne targets. A startup warning indicates failed checks; copy `ux0:data/SSF2P0001/log.txt` before relaunching.

This remains a prototype: no DI, move staling, sound or attack effects, and stage collision/normal landing remain approximations. Overlapping hitboxes select the lowest numeric box ID rather than reproducing all original collision priority rules.
