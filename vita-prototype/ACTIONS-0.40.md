# 0.40 — Air dodge momentum

Air dodging no longer kills horizontal momentum. The source only zeroes speed
on ground touch (`killAllSpeeds(false,true)` at Character.as line 15125); the
prototype previously applied `vx=approach(vx,0,.15)` every airborne tick, which
was not in the source.

A directional input during air dodge now adds a small nudge (3 units, clamped
to run speed) toward the held direction. Neutral air dodge preserves existing
momentum. Intangibility frames (3-14) and landing behavior are unchanged.

This was requested as a gameplay feel change on top of the source behavior.