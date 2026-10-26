# Mario actions 0.36 — grabs, recovery, ledges and dynamic camera

0.36 completes the ordinary moveset audit and replaces the fixed camera with the
source follow/zoom model. All frame data still comes from the original SSF2
scripts and FFDec sprite exports; nothing is hand-authored.

## Grabs, pummel and throws
- **R** grabs (running grab becomes DashGrab with the source `max_xSpeed`
  startup). Contact uses the exported `grabBox` helper against hurt boxes;
  shielding is bypassed, not damaged.
- Grab duration follows `Utils.calculateGrabLength`: `(90 + damage*1.7)/2`
  ticks, drained by victim mashing (4 frames per direction/attack/special
  input group, per `Character.Struggle`).
- Pummel returns to the hold pose at source frame 51 and deals `grabDamage`
  1 exactly on its authored active box (frame 46 event).
- Throws: forward 9% / 45°, back 12% / 145°, up 8% / 85°, down 9% / 80° from
  `Main.as`. The victim stays attached until the throw's authored release box,
  follows the exported touch-box placement, and inherits the source per-frame
  rotation/flip/spin events (`FThrow_46.as` etc.). Back throw flips the
  thrower's facing at the source terminal event, as in the original script.

## Dodges, techs and get-up
- Shield + direction = DodgeRoll (source startup speed 15), Down = SpotDodge,
  airborne shield = AirDodge (6.5 default, decelerating, one per airtime) with
  the separate `dodgeland` branch on touchdown.
- Heavy landing inside a 10-frame shield-press window techs into TechRoll
  (22 startup, 0.8 decay) or the in-place TechGround.
- Crash get-up accepts get-up roll (direction) or get-up attack after the
  source 13-frame delay.

## Ledges
- Hand helper geometry (`hand` markers) against the exported stage ledge
  markers (`ledge_mc_left__17` / `ledge_mc_right__16`) attaches Hang at the
  true ledge position, facing inward, with 14-tick intangibility and the
  4×30-frame hang timer.
- Options match source: **Up** HangClimb, **L** HangRoll, **Square** HangAttack,
  **Down**/away drop (regrab cooldown 15), **X** jump (restores midair jump),
  automatic drop at the timer limit. One fighter per ledge.

## Camera
- Ported from `Vcam.as` / `VcamSettings.as`: pan ease 5.6 with 50-unit cap,
  zoom ease 8 with 1-unit snap, minimum view height 200, clamped to the
  exported `camBoundary` of Final Destination, aspect-adapted to the Vita
  gameplay viewport (960×396 between the HUD bands).
- Source `camera.shake(n)` frame events (e.g. throw impacts) shake with the
  same random ±strength per tick.

## Other additions
- Dash attack: source `setXSpeed(14)` startup, 9%→7% across frame 5.
- Taunts: Side (frames 1–42), Neutral (43–115), Up/Down (116–161) of
  `Taunts_94.as`; **Triangle** (+Up/Down for the vertical taunt).
- Tumble-fall becomes actionable after moving recovery expires: midair jump,
  aerial/special input, and fast fall all work (source TUMBLE_FALL behavior).
- Edge-lean idle pose near the stage borders.

## Validation
- Six native suites pass with 0 failures: Recovery, Ground attack, Aerial,
  Movement, Action, and the new Extended suite (grabs/throws/dodges/tech/
  ledge/camera assertions, both facings).
- Asset pipeline: 68 animations / 1662 frames, rasterize reports no clipping,
  1662-frame round trip passes, `check-animation-data.py` passes.
- Not yet tested on physical Vita hardware.
