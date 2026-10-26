# Jab combo milestone / Vita 0.12

## Source mapping

Source: `../resource-scripts/DAT357/scripts/Main.as`, `mario_fla/Jab_23.as`, `mario_fla/Hurts_72.as`; formulas: the decompiled engine's `Utils.calculateKnockback` and `calculateVelocity`.

Frame numbers below are one-based source timeline numbers. Simulation indices are zero-based.

| Phase | Start | Active hitbox frames | End callback | Damage | Direction | Knockback |
|---|---|---|---|---|---|---|
| Jab 1 | 1 | 2–3 | 8 | 3 | 80 degrees | weightKB 20, power 0 |
| Jab 2 | 9 | 12 | 18 | 2 | 70 degrees | weightKB 20, power 0 |
| Jab 3 | 19 | 21–23 | 30 | 5 | 45 degrees | weightKB 0, power 40 |

All phases use kbConstant 100 and Mario weight 100. Jab 3 sets forward speed 7 on source frame 21. Each phase refreshes hit eligibility; overlapping multiple boxes never duplicates a hit. The second hitbox is present only in the third phase, where both boxes use the same stats. No geometry regeneration was needed.

Hurt sequences are frames 1–9, 11–19 and 21–29, ending at their authored done labels. Selection cycles deterministically instead of randomizing as the source does. The target retains a hurt pose during knockback instead of incorrectly switching to a jump animation. Recovery waits for the done frame, stun expiration and ground contact. Full heavy-hit tumble, techs and get-up states remain outside this milestone.

## Validation status

- Vita 0.12: compiled and packaged successfully; see `../vita-prototype/package-validation.json`.
- Atlas and box data unchanged from the previously validated extraction.
- Windows: compilation attempted but compiler temporary files were blocked. User explicitly requested skipping Windows verification. Existing `test-results.txt` and executable describe the previous version, not this change.
- Added regression cases in `main.cpp` for full combos in both directions, once-per-phase damage, finisher knockback, no automatic chaining, source frame timing, continuation expiration, hitlag, hurt recovery and stage-edge restraint. These cases have not been run.
- Vita 0.12 gameplay and timing need the user's hardware test. Version 0.11 was hardware-confirmed before this change.

## Hardware acceptance

Reset and move within jab range. Tap Square, release, and tap again as the punch recovers; repeat for the kick. Check 3%, 5%, then 10% cumulative damage and three hits. Repeat facing left. Let the target land and confirm it returns to idle. Confirm that a single tap does not automatically chain, waiting beyond the continuation window starts jab 1, and the kick does not carry Mario off the platform. Check movement/jumping/respawn and FPS again. Use Triangle for hitboxes and Start + L to inspect one simulation tick at a time.
