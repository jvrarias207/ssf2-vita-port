# SSF2 1.4.0.1: Mario, Luigi, and Final Destination inspection

## Verified extraction

All three supplied SSF containers decompressed into FWS-format SWFs using the loader format recovered from Resource.as. Payload bounds were checked before writing. JPEXS 26.4.0 reported successful script exports:

| Resource | Identity | SWF bytes | Exported AS files | Files registering frame scripts |
|---|---|---:|---:|---:|
| DAT357 | Mario | 3,561,479 | 1,043 | 94 |
| DAT118 | Luigi | 4,412,871 | 1,049 | 102 |
| DAT213 | Final Destination | 3,772,148 | 64 | 22 |

These counts include generated symbol classes and repeated API wrappers; they are not counts of independently implemented gameplay systems. No common decompilation-failure markers were found in these exports. The exports have not been recompiled or behaviorally validated. JPEXS could not open its user-profile log lock in this sandbox, but completed the script exports and generated stage XML.

## Findings

- Main.as and the fighter extension classes expose movement parameters, attack definitions, projectile definitions, sounds, and asset linkage names.
- Mario's Jab_23 frame scripts handle input windows, combo progression, timers, damage/knockback changes, attack IDs, effects, and sounds. Images and static attack tables alone cannot reproduce this behavior.
- Luigi's SSpecial_45 contains hit, shield, and wall callbacks that change movement and jump to animation labels.
- The main engine declares FRAMERATE = 30. A prototype should initially preserve that simulation rate; rendering can be treated separately.
- Final Destination includes terrain, ledge markers, player start/spawn markers, warning bounds, and a boundary clip. Its XML export preserves shape and placement data. The stage symbol contains separate terrain, background, foreground, shadow, and reflection objects.
- Final Destination's visual script includes animated phases and a bitmap-based particle effect. A prototype can initially use a simplified background while preserving stage geometry.
- Fighter frame scripts reference shared effects and sounds such as global_dust_blast and brawl_swing_s. The three resources are not a standalone playable package.

## Recommended next milestone

Build an offline conversion proof before attempting a complete native port:

1. Extract a small set of Mario animations, frame labels, transformed hurtboxes/hitboxes, and frame events.
2. Extract Final Destination collision geometry, starts, ledges, and boundaries from the nested SWF display structure.
3. Implement a desktop reference prototype with a fixed 30 Hz simulation, movement, one attack, collision, damage, knockback, and respawn.
4. Compare timing and behavior against the original game.
5. Bring that small prototype to Vita using VitaSDK and VitaGL, then measure frame time and memory on hardware.

The supplied files are sufficient to start this conversion experiment. More assets will be needed for complete effects, audio, menus, and broader gameplay. No native executable has been built and no Vita performance has been measured.
