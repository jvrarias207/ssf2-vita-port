# SSF2 native gameplay experiment

This is a small Windows C++ prototype built from the inspected SSF2 1.4.0.1 resources. It is not the complete game and is not a Vita build.

## Run

Open `ssf2-prototype.exe`, keeping `assets/mario-atlas.png` beside it in the assets folder. No Flash or Adobe AIR runtime is used by this executable.

| Key | Action |
|---|---|
| A / D or left / right | Walk |
| Space | Jump; release during startup for a short hop; press again for one midair jump |
| S or down | Fast fall while descending |
| J | First jab, while grounded |
| R | Reset both fighters |
| B | Show authored attack and hurt bounds |
| P | Pause / resume |
| N | Advance one simulation tick while paused |
| Escape | Close |

The stationary opponent reacts to hits but does not attack. Move closer before pressing J. Switching away from the window pauses the test; press P to resume.

## Data carried over

- Mario's seven inspected animation resources, 312 authored frames, rendered into a 192-pixel-cell PNG atlas.
- Original parent transforms for each animation, including their scale and translation. These align the animation and hitboxes to the character origin.
- Authored per-frame attack and hurt bounds, transformed into character-local coordinates.
- Final Destination's terrain outline and upper platform surface.
- A 30 Hz simulation, Mario movement constants, and the first jab's damage, angle, weight-based knockback, and hitlag formulas.

## Deliberately incomplete behavior

- This is a selected reimplementation, not execution of all recovered ActionScript. Only the first jab is implemented; combo branches and other attacks are omitted.
- Terrain uses a sampled body-perimeter collision approximation. It is not SSF2's full collision solver. Ledge grabs, shields, DI, knockback decay states, landing lag and fighter-to-fighter body pushing are not yet reproduced.
- KO limits are an approximate rectangular interpretation of the authored boundary placement. Starts use two convenient training positions rather than a full match setup.
- Ground walk acceleration, animation selection and recovery are simplified. The raw source constants and formulas alone do not establish frame-perfect behavior.
- Source costume colors are shown without the original runtime palette selection. Stage art, backgrounds, audio and effects are omitted.
- Simulation updates at 30 Hz; rendering is independent and currently does not interpolate between states.
- This renderer uses Windows GDI+. `simulation.h` and generated geometry data are platform-independent; the window, input and rendering layer must be replaced for VitaSDK/vitaGL. The atlas will need memory profiling and likely repacking for Vita.

## Verification and next comparison

Run `ssf2-prototype.exe --test` to write `test-results.txt`. Run `ssf2-prototype.exe --capture` to save an offscreen native-renderer preview.

Before expanding the prototype, compare full-jump height and duration, walking distance over a fixed number of frames, first-jab timing and target reaction with the original game. The user's prior approval covered the inspection viewer's animations, not these newly implemented mechanics.

The extraction input files remain unchanged. No network calls are made by this prototype.
