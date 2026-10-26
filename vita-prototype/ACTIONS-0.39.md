# 0.39 — Source smash-input grace

Replaces 0.38's same-controller-sample requirement with the original shared
smash timer. In exported `Character.as`, lines 6930/6966 require timer <4 for
up/down; line 6946 requires timer <5 for side. At 30 Hz these are nominal
133 ms and 167 ms windows (ages 0–3 and 0–4 respectively).

Timer advancement/reset follows lines 15597–15604: directional, attack or special
holds age the timer. A neutral simulation tick rearms it, except while skidding
or landing. Landing kills the timer (99), as in `killSmashTimers`, lines 6725–6731.
Switching held directions does not restart this shared window. Timer updates run
once per simulation step, including paused single steps, never once per render.
Match reset and heavy-test reset reset the input timer too.

Circle pressed during the window selects a smash; after it expires, the existing
tilt/dash-attack rules apply. Circle still charges/releases the chosen smash.
Right-stick shortcuts and aerial selection retain their existing behavior.
This restores the source timing window; it is not a new attack-first input buffer.

Boundary/reset regression checks are part of the ground-attack suite. Physical
Vita testing of the revised timing remains pending.
