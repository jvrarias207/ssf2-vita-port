# Native prototype validation

## Completed

- Compiled a Windows x86-64 executable from C++ using Zig 0.15.2.
- Thirteen deterministic simulation checks pass; see `test-results.txt`.
- Offscreen native rendering saves a PNG and exits successfully.
- A hidden native window starts, runs its fixed-step loop and shuts down successfully.
- The PNG atlas contains 312 frames; the raster conversion found no occupied outer cell-edge pixels.
- A captured native frame was visually inspected for sprite, authored hitbox and platform alignment.

## Not yet established

The new movement and combat implementation has not been measured against the original running SSF2 game. Successful tests establish the intended prototype behavior, not complete equivalence to SSF2. The user's visual confirmation applies to the preceding animation inspection viewer.

Useful comparison measurements for the next iteration:

| Measurement | Prototype | Original-game comparison |
|---|---|---|
| Simulation rate | 30 ticks/second | Source constant agrees |
| Ground walking speed cap | 4 pixels/tick | Source constant agrees; update order not compared |
| Full-jump rise | 107.9 local pixels | Pending |
| Short-hop rise | 30.1001 local pixels | Pending |
| First jab damage | 3 percent | Source attack definition agrees |
| First jab authored attack boxes | Frames 2 and 3 | Extracted from source timeline |
| Jab computed knockback | 33.4 before velocity conversion | Source formula, neutral multipliers |
| Repeated hits per jab | At most one | Selected first-jab prototype behavior |

## Vita status

No Vita executable/VPK has been built. No Vita performance or memory measurements have been made. A Vita port requires a VitaSDK toolchain, a graphics/input backend, asset memory planning and hardware testing. The platform-independent simulation is separated from the Windows renderer to make that subsequent work possible.
