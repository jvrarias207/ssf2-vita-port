# 0.50 — Audio playback repair and source extraction

## Why the previous audio was silent

The Vita SDK's `psp2/audioout.h` explicitly requires the MAIN audio port to run
at **48,000 Hz**. The old code opened MAIN at 44,100 Hz, so port initialization
could fail before loading or playback. It also opened two ports and wrote
partial tails in a fixed-size API, making playback unreliable.

## Runtime audio changes

- One MAIN port is opened at 48 kHz, stereo, 1024 frames per output block.
- `PcmMixer` linearly resamples source PCM from 44.1 kHz to 48 kHz, loops music,
  mixes up to eight overlapping SFX voices, and clips output to signed 16-bit.
- SFX are queued by clip index (not copied audio vectors) and mixed over the
  background theme; playback submits a complete block every time.
- `sceAudioOutOutput` errors and block counts are recorded every five seconds
  in `ux0:data/SSF2P0001/log.txt`. Startup logs show port initialization and
  how many of the 63 SFX files loaded.
- Audio calls are guarded when startup or individual file loading fails.

## JPEXS extraction (performed)

JPEXS Free Flash Decompiler 26.4.0 exported all **63** Mario sound symbols from
`prototype-assets/swf/DAT357.swf` (the SWF's 64th sound is its stream header,
not a Mario SFX). ffmpeg converts JPEXS FLV/Nellymoser exports to raw
16-bit, 44.1-kHz stereo PCM using `extract-audio.ps1`.

The extracted files are staged in `vita-prototype/ux0_data_SSF2_jpexs/` without
overwriting the pre-existing `assets/*.pcm` files. `package-audio.ps1` gathers
the extracted 63 sounds and supplied Brawl main theme into
`SSF2-audio-transfer/`. Transfer its contents to `ux0:data/SSF2/` on Vita.
The Brawl main theme is not a symbol in DAT357; the separately supplied theme
PCM is copied into the staging folder unchanged.

## Verification and hardware diagnostics

- PCM unit checks verify stereo-channel preservation, 44.1→48-kHz interpolation,
  simultaneous SFX mixing, SFX termination, and looping music.
- Simulation suites and animation-data checks are run independently; they do
  not prove that Vita hardware emitted audio.
- After installing the VPK and copying external data, check `log.txt` for
  `Audio ready`, `Music loaded`, `Mario SFX loaded: 63/63`, increasing `blocks`,
  and `error=0x00000000`. Missing files, port errors, and output-thread errors
  are separately logged.
- **Physical Vita listening test remains required.** If still silent, send the
  audio-related log lines and confirm that all 64 PCM files are directly in
  `ux0:data/SSF2/` (not nested in a subdirectory).
