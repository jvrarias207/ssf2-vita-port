# Recovery milestone 0.13

Source assets added: SentFlying_77 (symbol 1208, 8 frames), TumbleFall_87 (1220, 20 frames), GetUp_88 (1221, 50 frames). Extracted with FFDec from the user's DAT357.swf. Their parent stance transforms and helper bounds are included in the native atlas and generated collision data.

Source references: Character.as HEAVY_KNOCKBACK_THRESHOLD (2.4 * 3.488), m_crashTimer (13), m_getUpTimer (110), initiateCrash and automatic CRASH_GETUP transition; GetUp_88.as frames 14/16/26/31. The source's multiple launch-cancellation and physical bounce branches remain simplified: after hitstun, heavy targets fly while rising, tumble while descending, and enter the landing animation on ground contact. The landing artwork contains a visual bounce; a separate physical floor bounce is not simulated.

Validation performed:
- Extracted 390 total frames and measured their helper bounds; viewer checks passed without browser errors.
- Rasterized all frames; no nontransparent pixels touched the atlas cell edges.
- Round-tripped all 390 trimmed frames; alpha and visible pixels matched.
- Inspected the new flight, tumble, landing and get-up poses in recovery-preview.png.
- ARM/Vita build and package integrity, identifiers, asset sizes and launch-art checks passed.

Execution still pending:
- Windows tests remain skipped at the user's request; the Windows executable is stale.
- Recovery simulation checks are compiled into the Vita startup path, logging phase progression, low-hit behavior, recovery timing, intangibility timing and offstage respawn. They have not been run locally or on hardware yet.
- Hardware test: press R shoulder, complete the jab combo, wait for automatic recovery. Repeat facing left, near an edge, and after a normal Select reset. Check FPS and send log.txt, particularly if the recovery-check warning appears.

No changes to the intentional hitlag formula, jab damage or movement tuning were made in this milestone. The atlas increased from 2 MiB to 4 MiB.
