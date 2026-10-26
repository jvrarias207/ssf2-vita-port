# 0.52 — JPEXS SFX, authored event frames, and cleaner mix

## Source extraction and files used

- Mario clips are extracted with JPEXS from `prototype-assets/swf/DAT357.swf`;
  shared swing/grab/throw clips are extracted from `DAT141.swf`.
- `extract-audio.ps1` converts those source exports through ffmpeg directly to
  signed 16-bit stereo **48-kHz** PCM. The playback mixer now receives the Vita
  MAIN port's native sample rate and does no cheap runtime linear resampling.
- The 63 Mario sounds and 7 shared sounds are staged in
  `ux0_data_SSF2_jpexs_v3/`; `package-audio.ps1` outputs the complete 71-file
  `SSF2-audio-transfer/` folder. Copy those PCM files directly to
  `ux0:data/SSF2/`.
- The requested Brawl Main Theme is not embedded in the local SSF2 SWFs/JPEXS
  exports. It remains the separately supplied track, converted to the same
  48-kHz playback format; the Mario SFX no longer come from the supplied PCM set.

## Source-timed sound effects

`generate-audio-events.py` parses each animation's `eventSource` in
`prototype-assets/viewer/animation-data.json` and writes
`native-prototype/generated-audio-events.h`. Runtime playback keys off the
authored animation frame for both fighters, rather than firing a guessed sound
on animation entry. This fixes repeated tilt sound triggering and follows the
original timing: FTilt/DTilt frame 3 use `brawl_swing_m`; UTilt frame 3 uses
`brawl_swing_l`; Jab swings occur on source frames 2/12/21. Smash, aerial,
special, grab, throw, landing, ledge, movement and taunt sounds are likewise
dispatched on their source event frames where the corresponding asset exists.

## Damage voices and quality

`resource-scripts/DAT357/scripts/Main.as` maps `hurt` to `mario_edgegrab`,
`hurtBad` to `mario_hurtBad`, and `hurtBad2` to `mario_hurtBad2`.
`Character.as` randomizes light hurt voices at 40%; stronger hit sounds depend
on velocity. The prototype follows that distinction and applies a **12-tick
per-fighter cooldown**, preventing dense multi-hit sequences from repeating
voices on every hit. Pummel damage does not trigger a hurt voice.

Music gain was reduced, overlapping SFX are mixed, and a soft limiter replaces
hard clipping. PCM checks cover source-frame tilt/jab mappings, mixed voices,
the limiter, music looping, resampling path and hurt-sound rate/cooldown.
Physical listening is still required to judge the final timbre and level.
