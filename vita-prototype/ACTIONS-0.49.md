# 0.49 — Grab collision and audio review

## Grabs

- Standing Grab and DashGrab only catch targets grounded **on the Final
  Destination surface**. This is centralized in `fighterGrabbable`, so AI
  shield-grab decisions and collision use the same rule. Fighters with an
  airborne animation retained for the landing tick (notably deferred aerial
  landings) cannot be caught before the landing transition.
- Original Mario grab boxes are imported from authored frame markers, **not
  expanded**: standing Grab is active only on source frame **4**; DashGrab
  only on source frame **6** (one-based). Startup and recovery frames cannot
  connect.
- Original `Character.as` `reactionGrab` (~10323–10344) and `Capture`
  (~1273–1277) reject certain protected/crash/hanging states, but do *not*
  universally forbid grabbing an airborne target. The ground-only condition
  here is the requested rule for this Mario prototype, not a claim that the
  entire SSF2 engine forbids air catches.
- Native checks exercise both facings and both grab types: authored marker
  frames, grounded captures, airborne *overlapping* hurtboxes, stale grounded
  flags above stage, simulated ticks and deferred aerial landing poses.

## External audio review

- Supplied Mario PCM files are already stereo (duplicated L/R); loading them
  as mono previously duplicated samples a second time and misplayed them.
- Clip IDs now come from the actual successful load per file; a missing Brawl
  song or one missing SFX cannot silently shift the remaining sound mapping.
- Music uses the Vita BGM port, SFX the MAIN port. Audio init errors are
  recorded in `ux0:data/SSF2P0001/log.txt`, including the return code.
- Both output threads now provide full 2048-frame stereo buffers, padding
  partial SFX tails and looping music without reading past the end of PCM.
  PCM clips are no longer recopied into the music state or SFX queue. Duplicate
  animation-triggered audio events were removed.
- `package-audio.ps1` collects 63 Mario effects plus the Brawl theme into a
  separate transfer directory; the VPK contains no PCM data. The audio files
  must be copied to `ux0:data/SSF2/` on the Vita.

## Validation / limitations

Eight native simulation suites and the animation-data consistency check pass.
The VPK packaging checks confirm version 00.49 and that assets were packaged
as specified. They **cannot** confirm actual audio output, the PCM sample rate,
SFX mixing, or how the CPU feels on a physical Vita. SFX are still queued
sequentially on one port rather than mixed; frame-perfect event sounds and
two-fighter sound routing need a subsequent pass. Hardware testing remains
the next priority.
