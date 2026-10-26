# 0.51 — Authored sound events and mix cleanup

## Audio source data

- Mario animation sound events are generated from
  `prototype-assets/viewer/animation-data.json` `eventSource`, using
  `generate-audio-events.py` → `native-prototype/generated-audio-events.h`.
- Shared engine swing/grab/throw clips are extracted with JPEXS from
  `prototype-assets/swf/DAT141.swf`; Mario voice/move clips are extracted from
  `DAT357.swf`. `extract-audio.ps1` converts these extracted FLVs to PCM in the
  separate external-data transfer folder. Mario's sounds are not loaded from
  the manually supplied Mario PCM set. The Brawl main theme is not embedded in
  the available source SWFs, so that separate supplied theme PCM remains used.
- Added DAT141 `brawl_swing_s/m/l`, `grab_swing4/6`, `throw_woosh`, and
  `brawl_kick_l` for the authored Mario timeline events.

## Event timing and damage voices

- Sounds now trigger on the **authored source animation frame**, not merely
  when an animation starts. Repeated tilts therefore each produce the correct
  `brawl_swing_m` (FTilt/DTilt, source frame 3) or `brawl_swing_l` (UTilt,
  source frame 3). Jab swings, aerials, smashes, specials, grabs, throws,
  movement/landing, ledge actions and taunts use their JSON source events.
- Removed duplicate transition-guess sounds (some previously triggered several
  times for the same action).
- Hit voices follow `resource-scripts/DAT357/scripts/Main.as` sound mapping and
  `Character.as` takeDamage logic: light hurt voice is 40% chance; bad hurt is
  used for stronger impacts. Added a 12 simulation-tick per-fighter voice
  cooldown to avoid repetitive chatter. Grabbed victims do not emit hurt voices
  for pummel damage.
- Mixer music gain reduced; overlapping PCM voices use a soft limiter instead
  of hard-clamping peaks. This addresses crunchy clipping while keeping music
  and SFX mixed on the single 48-kHz Vita MAIN port.

## Validation

- PCM checks cover stereo mix/resampling, music looping, overlapping sound
  mixing, clipping limiter, hurt cooldown/random rate, and authored tilt/jab
  event-frame mappings.
- Native simulation suites remain expected to pass. Package checks verify VPK
  metadata/contents only; **audio quality still requires physical Vita listening**.
- Transfer the 71 files from `SSF2-audio-transfer/` directly into
  `ux0:data/SSF2/`. Startup/runtime logs include source clip counts, audio output
  block counts and error codes.
