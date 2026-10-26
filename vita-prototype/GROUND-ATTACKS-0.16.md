# Ground attacks source audit

Original data: resource-scripts/DAT357/scripts/Main.as and mario_fla/{FTilt_25,UTilt_30,DTilt_70,FSmash_26,USmash_29,DSmash_31}.as. All frame numbers below are one-based authored timeline frames.

| Move | Symbol | Active frames | End callback | Damage | Angle | Power | KB constant |
|---|---|---|---|---|---|---|---|
| Forward tilt | 1116 | 3–4 | 14 | 9 | 35 | 10 | 100 |
| Up tilt | 1119 | 3–6 | 14 | 8 | 96 | 26 | 125 |
| Down tilt | 1199 | 3–4 | 16 | 10 | 70 | 30 | 80 |
| Forward smash | 1117 | 48–49 | 65 | 17 outer / 14 inner | 50 / 60 | 25 | 103 / 99 |
| Up smash | 1118 | 46–49 | 66 | 15 | 83 | 32 | 97 |
| Down smash | 1120 | 43–44 front; 47–48 rear | 65 | 14 / 10 | 30 | 30 / 35 | 100 / 75 |

Smash charge labels: forward frame 3, up frame 5, down frame 3. Release labels: forward frame 44, up frame 46, down frame 43. The source maximum charge is 40, with forceUseAtMaxCharge default false. While held, charge animation loops at its authored loop callback and charge remains capped; release jumps to attack. Damage multiplier is 1 + charge/40 * 0.4 (Utils.calculateChargeDamage). Knockback then uses the resulting damage and the validated shared formula.

AttackBox IDs are now preserved in generated geometry instead of collapsing them to a boolean. Forward smash uses attackBox/attackBox2 independently. When both overlap, this prototype chooses the lowest numbered box; the full engine's collision ordering/priority is not yet ported. FSmash_26 assigns a customData object with different inner-hitbox parameters, but no applying call or consumer of those parameters was found in the recovered runtime collision path. This build uses the actual Main.as attackBox2 values (14 damage, 60 degrees, power 25, KBC 99), rather than treating the unused object assignment as an applied stat update. Down smash explicitly calls updateAttackBoxStats on frame 47; that update is applied.

The target impact pause and attacker pause use Utils' damage-dependent defaults for these moves. Existing jab overrides and physics are unchanged. Up tilt's 96-degree backward horizontal component is retained by reversible-angle handling.

Checks: extracted 630 total frames, measured all helper geometry, rasterized without edge clipping, and round-tripped visible pixels/alpha. New artwork was inspected in ground-attacks-preview.png. Source-script effects (including forward-smash explosion), sound, angled forward tilts, aerials, move staling and all special collision interactions remain outside this build.

Execution: Vita compilation/package checks passed. On-device startup checks are compiled and will run on next launch. Windows binary remains the older build; Windows execution has not been retried after the user requested skipping it.

Hardware acceptance: neutral Square still chains all three jabs; direction + Square selects the correct tilt. Check forward attacks both ways, up tilt's rear/up launch, down tilt, quick smash taps, full charge and release, inner/outer forward-smash hits, and down-smash rear hits on a target behind Mario. Reset between tests. Confirm movement/jumps/respawns, heavy recovery and FPS remain stable with the 8 MiB atlas. Send log.txt if any startup check warning appears.
