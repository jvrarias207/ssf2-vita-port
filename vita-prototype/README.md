# SSF2 Vita prototype 0.52

The current build has ground-only Mario standing/dash grabs, a medium CPU,
and external audio. Grab behavior and audio review: `ACTIONS-0.50.md`.
Audio source events now follow Mario's extracted animation event data. SFX are
extracted with JPEXS from DAT357/DAT141, and preconverted to 48-kHz PCM.
**Console testing is still needed** to confirm sound quality and CPU feel.

## Audio setup
Audio files are loaded from `ux0:data/SSF2/` at runtime (not embedded in the VPK).
1. Run `extract-audio.ps1` (JPEXS + ffmpeg) to regenerate the Mario SFX if desired.
2. Run `package-audio.ps1`; it collects 63 effects and Brawl music into `SSF2-audio-transfer/`.
3. Copy the PCM files directly into `ux0:data/SSF2/` on Vita (no nested folder).
4. Check `ux0:data/SSF2P0001/log.txt` for loaded count, output blocks and audio errors.

If audio files are not present, the game runs silently (no crash).

Current timing: see `ACTIONS-0.39.md`; controls and AI review: `ACTIONS-0.38.md`.
Square or Triangle jumps; Circle attacks. Direction then Circle within the source
grace window = smash (up/down: timer <4; side: timer <5 at 30 Hz).
Holding direction beyond the window then pressing Circle selects a tilt (or dash attack while running).
Hold Circle to charge the smash, release Circle to strike. X performs specials.
Right trigger shields; left trigger grabs. Right stick selects directional aerials
while airborne and smashes while grounded. Select+Up toggles AI.

## Historical notes

The 0.37 and older notes below describe previous controls and versions.

Current additions: medium-level opponent AI (approach, defense reactions, shield-grabs/throws, fireballs, edge-guarding, juggles, ledge recovery, mashing, techs, throws), grabs (R), pummel and all four throws, dash attack, shield rolls/spot dodge/air dodge, techs, crash get-up roll/attack, ledge hang/climb/roll/attack/drop, taunts, tumble-fall recovery, edge lean, and the dynamic source camera (follow ease, zoom, shake, stage-bound clamps). Controls: **R** grab/throw (direction selects throw), **L** shield (direction = roll, Down = spot dodge, airborne = air dodge), **Triangle** taunt, **Square** attack (dash + Square = dash attack), **Circle + direction** special, **Down** crouch/fast fall, **X** jump, **Select + Up** toggle AI. Dash, fast fall and smash charge are preserved. See `ACTIONS-0.37.md` for tested behavior and remaining approximations. Notes about 0.36 and earlier are historical.

Fast fall: freshly press D-pad Down or tilt the left stick down **after descent begins**. Mario immediately falls at source speed 16 (normal cap 13, gravity 1.3) and keeps that speed after release until landing or a new upward jump. Holding Down from ascent does not activate fast fall; release and press again while descending.

Releasing direction during initial dash now finishes the acceleration animation, then skids and decelerates to rest. A single direction press cancels the stop into walking; a new double tap restarts dash acceleration. The input that began the previous dash is not counted as the first tap of a new dash after release.

The current VPK intentionally retains APP_VER 00.34 and title ID SSF2P0001. Its in-game banner reads **0.34 corrected** to distinguish it from the previous 0.34 package. See `ANIMATION-REPAIR-0.34.md` for the current repair and validation details. Older release notes below are historical, not the current specification.

This repair adds the source dash-start segment (sprite 1102, frames 16–21), fixes Turn to frames 22–31, advances Skid instead of freezing its first image, and connects ordinary landings to Land's normal branch. Original source frame events are attached to sliced animations using their unsliced frame indices. Run/turn/landing terminal script frames redirect or end rather than displaying every exported image unconditionally.

Collision geometry now comes from each actual SVG pose, including the original up-air reach; the earlier enlarged up-air boxes and distance-based back-air damage override have been removed. Back air weakens on source frame 6. Custom charge timing remains 60 simulation ticks plus at most 120 additional hold ticks, with a capped 1.4 damage multiplier and 100% HUD. These are 30-Hz gameplay ticks, not 60-Hz display refreshes.

Asset regeneration order: `python build-viewer.py`, Node `regenerate-authored-boxes.cjs`, `python prepare-native.py`, Node `rasterize-native.cjs`, then Python/Pillow `prepare-vita-assets.py`. Validate with `python check-animation-data.py` and Node `regenerate-authored-boxes.cjs --check`. Build with `build.ps1`, then run `verify-package.py` separately. `native-prototype/check-simulation.cpp` runs the same recovery/ground/aerial/movement suites compiled into Vita startup.

Version 0.18 changes the attack inputs and adds movement options. Tilts use Square pressed after a direction; smashes use Square and a direction pressed simultaneously, or the right stick (up=up smash, down=down smash, left/right=side smash). Double-tapping a direction dashes. Back air now applies a sourspot when the target is caught by the tip of the hitbox.

Version 0.17 adds Mario's neutral, forward, back, up and down aerial attacks. While airborne, press Square alone for neutral air, or direction + Square for the other four. Forward/back are relative to Mario's facing; drifting backward does not turn him around. Circle remains a grounded smash input.

Includes authored hitboxes, early/late damage changes, landing recovery, down-air hit refreshes and its landing hit, and forward-air meteor behavior against airborne targets. The validated shared knockback, weight and gravity baseline is preserved. See `AERIALS-0.17.md` for timing and limitations.

Validation for 0.17: Vita compilation and package checks passed, along with all 771 frame extraction and atlas round-trip checks. The sprite texture remains 8 MiB. Aerial regression checks are compiled into startup and will report to `ux0:data/SSF2P0001/log.txt` on the next console launch; they have not yet been executed. Windows verification remains skipped as requested. Earlier versions were tested by the user on Vita; this new version still needs gameplay verification.

## Previous versions

Version 0.16 adds Mario's forward/up/down tilts and forward/up/down smashes. Use direction + Square for tilts; neutral Square retains jabs. Use direction + Circle for smashes (neutral Circle selects forward smash), hold Circle to charge, then release. Charge caps at 40 simulation ticks (about 1.33 seconds) after startup, and stays held until release. Full charge multiplies base damage by 1.4. Version 0.16 attacks were grounded only; aerials were added in 0.17.

Base damage: forward tilt 9%, up tilt 8%, down tilt 10%; forward smash 17% outer / 14% inner, up smash 15%, down smash 14% front / 10% rear. Damage and timing follow the supplied attack data and timelines. Source move staling, collision priority details, fire/dust effects and sound are not implemented. Down smash keeps one attack identity across both swings, matching the absence of an ID refresh in its source timeline.

The user validated version 0.15's damage/angles/gravity/weights. That baseline is recorded in `../PHYSICS-BASELINE.md`. Shared physics parameters were preserved; weight and gravity now live explicitly on each fighter for future character additions and survive respawn.

Validation for 0.16: all 630 frame/geometry extraction checks and atlas round trips passed; no artwork clipping was detected. The atlas now uses 8 MiB. Vita compilation and package validation passed. Added on-device checks cover six moves in both directions, once-per-target hits, charge/release/cap, actual charged damage, hitbox variants, and the baseline knockback formula. These checks execute on next launch; local Windows execution remains skipped as requested. Version 0.16 needs hardware gameplay verification.

Version 0.15 corrects jab trajectories by separating normal velocity/gravity from knockback. SSF2's 30-FPS engine applies knockback twice per simulation tick with directional decay of `3.488 * 0.051` per substep; the old prototype applied it once and mixed it with capped fall velocity. Base jab values remain 3% at 80 degrees, 2% at 70 degrees and 5% at 45 degrees. Direction reverses away from the attack origin when a hit connects behind it. Ordinary overlapping-hit knockback stacking uses the source component selection rule after its five-tick timer.

Target impact pause remains three ticks; the moving recovery timer is separately calculated from knockback. Heavy targets switch from flying to tumble when that recovery timer expires. Light-hit recovery now uses the source-inspired 12-tick grounded/15-tick airborne gates instead of waiting for the hurt animation to finish and land in every case. This is still a subset of the engine: DI, move staling, all overlapping-hit exceptions, stage collision details and full landing/tech rules are not reproduced.

Validation: on-device checks were extended for damage, mirrored launch vectors, impact/recovery timers and two-step knockback movement. These compile into the new VPK and execute on the next Vita launch; they have not been run locally. Windows execution remains skipped at the user's request. Test both normal and R-shoulder high-damage resets and send log.txt if a check warning appears.

Version 0.14 corrects excessive impact freezing. Earlier builds mistakenly froze both fighters for `Utils.calculateHitlag`, which SSF2 uses as a moving knockback-recovery timer. The source separately calls `startActionShot` for the actual impact pause: target hitStun=3, attacker default selfHitStun=-1, giving attacker pauses of 2/1/2 ticks for jabs 1/2/3. The target now pauses for 3 ticks (100 ms) and then moves while its recovery timer runs. The attacker's pauses are about 67/33/67 ms and no longer grow with target damage. This corrects the earlier explanation that the long freezes matched the original game.

Version 0.13's tumble/landing/get-up sequence was confirmed on the user's Vita. Version 0.14 compilation and package checks passed; gameplay execution remains pending. Additional on-device startup checks cover the pause lengths and movement resuming. Windows verification remains skipped. Install over the previous VPK and compare normal and R-shoulder heavy tests; send log.txt if any check fails.

Version 0.13 adds heavy-hit flight, tumble, crash landing and automatic get-up using 78 more source frames. Press **R shoulder** to reset into a close-range test with the target at 60%, then perform the three-jab combo. The finisher should launch the target into the new recovery sequence. The target remains down for roughly 3.7 seconds from landing before getting up; this uses the source's 110-tick automatic get-up timer. Select still resets the normal 0% test.

Vita compilation, package validation, browser extraction checks for all 390 frames, and atlas round-trip checks passed. Windows execution remains skipped as requested. Deterministic recovery checks now run on the Vita at startup and write PASS/FAIL results into `ux0:data/SSF2P0001/log.txt`. They have not been executed locally; a failed check also displays a message in the game. Version 0.12's combo was confirmed on the user's Vita; version 0.13 still needs hardware testing.

This milestone includes the source's heavy-hit velocity threshold, authored flying/tumbling poses, landing frames 1–14, get-up frames 16–31, and get-up intangibility through frame 25. Light hits retain the previous hurt reactions. Offstage tumbles still KO and respawn. It does not yet implement tech inputs, get-up attacks/rolls, directional influence, trajectory-aligned sprite rotation, or the full physical ground-bounce model. The training target automatically waits out the source timer rather than choosing an early recovery input.

Version 0.12 adds the three-part jab sequence, its forward step, phase-specific damage/knockback, and complete hurt-to-idle target reactions. Release and press Square again during the recovery of each punch to continue. A fresh press within 12 simulation ticks after a punch ends also continues the combo. Holding Square does not automatically chain. A connected full combo deals 3 + 2 + 5 = 10% before any later attacks.

Validation for 0.12: Vita compilation and package checks passed. Windows compilation was blocked by compiler temporary-file permissions; the user requested skipping Windows verification. The new regression tests are written but **not run**, and the Windows executable still contains the older gameplay. Version 0.11 was confirmed working on the user's Vita; 0.12 still needs hardware validation.

Version 0.11 fixes a startup-check bug: vitaGL's initialization return value signals resolution fallback, not success/failure. Version 0.1 incorrectly exited on the normal false return and printed a misleading shader-compiler warning. Install this VPK over the previous version; the title ID is unchanged.

Native ARM/VitaGL prototype extending the Mario movement and jab test you validated on Windows and Vita. This is a limited playable prototype, not the complete SSF2 game. No Flash runtime is used. The VPK includes its required Mario textures and font; no separate SSF2 data-folder copy is needed.

## Install and launch

1. Use a homebrew-enabled PS Vita with VitaShell.
2. Ensure the decrypted shader compiler `libshacccg.suprx` is installed on your console. This is a [vitaGL prerequisite](https://github.com/Rinnegatamante/vitaGL#prerequisites); follow the extraction guide linked there if it is missing. The usual location is `ur0:data/libshacccg.suprx`. The Sony module is not bundled with this prototype.
3. Transfer `SSF2-Vita-Prototype.vpk` to the Vita using VitaShell USB or FTP, for example into `ux0:download/`.
4. Select the VPK in VitaShell and install it. The application title is **SSF2 Prototype**, title ID **SSF2P0001**.
5. Return to the Vita home screen and launch its bubble. A vitaGL startup screen may appear before the prototype.

## Controls

| Control | Action |
|---|---|
| D-pad / left stick | Move |
| Cross | Jump; press again for midair jump |
| Release Cross early | Short hop |
| Neutral Square on ground | Jab; release/repress to chain jab 2 and jab 3 |
| Direction + Square on ground | Forward / up / down tilt |
| Square in air | Neutral air; direction selects forward / back / up / down air |
| Direction + Circle | Forward / up / down smash; neutral selects forward |
| Hold / release Circle | Charge / release smash |
| Down / stick down | Fast fall |
| Triangle | Toggle collision boxes and debug information |
| Start | Pause / resume |
| Select | Reset the test |
| R shoulder | Reset close-range test with target at 60% |
| L while paused | Advance one simulation tick |
| Start + Select | Exit |

## First hardware test

Check both facing directions, short/full jumps, the midair jump, hitting the target, falling off each edge, and respawning. Try pausing and resuming, then suspending and reopening the app. Watch the FPS display for persistent drops; simulation runs at 30 ticks/second independently of display rendering. CPU time shown excludes the buffer-swap wait and is not a GPU measurement.

For a failure, report the exact error code and whether it happens during installation, startup, or gameplay. The app writes `ux0:data/SSF2P0001/log.txt` at startup and every five seconds; send that file with your observations. Relaunching overwrites the previous log, so copy it first. A crash before the logger starts may leave no log.

## Included / limitations

Mario animation frames, movement, jumping, all three jab phases, damage/knockback, a stationary target, and death/respawn use the shared simulation header. Jab 2/3 use the existing extracted artwork and authored hitboxes. Light hurt variants cycle deterministically through the source's three hurt sequences, play to their done frames, and return to idle after landing and stun expiration. Heavy hits use the recovery sequence described above. Randomized hurt selection is not implemented; separate knockback velocity was added in 0.15. The 12-tick post-punch continuation window is a prototype simplification of the source's timer/global-variable logic.

The stage is the extracted Final Destination collision silhouette, not its finished scenery. Collision and KO boundaries retain the existing prototype approximations. No audio, full moveset, character selection, opponent AI, multiplayer, or menus are included.

The code compiles and the package has been checked locally. **Version 0.17 has not yet been run on physical Vita hardware; earlier builds have.** Installation, shader startup, rendering orientation, controls and performance still require the above console test.

## Build and verification

Run `build.ps1` from PowerShell. It uses the portable SDK at the workspace's `vita-sdk` directory (VitaSDK channel 2026.08, GCC 15.2.0) with the installed vitaGL package and dependencies. The shared headers are in the sibling `native-prototype` folder. Keep that folder relationship when copying source.

`../prepare-vita-assets.py` regenerates the atlases and LiveArea images using Python/Pillow and Windows Consolas. It verifies all 771 source frames against the repacked atlas. The sprite texture uses 8 MiB; the font adds 128 KiB. These are texture-data sizes, not total application memory use.

Run `verify-package.py` using Python with Pillow after building. It checks archive CRCs, packaged file equality, SELF and ARM executable headers, SFO identifiers, texture sizes, and indexed LiveArea artwork. Results are saved in `package-validation.json`; asset round-trip results are in `asset-validation.json`.

Original game content belongs to its respective creators. This local build uses the user's extracted game assets. VitaGL and its dependencies retain their respective licenses; see the local `../vita-build/vitaGL` checkout and the VitaSDK package sources for library details.
