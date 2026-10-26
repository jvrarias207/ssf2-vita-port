# ACTIONS — 0.37: Medium opponent AI

Version 0.37 adds a medium-level fighting AI for the opponent (dummy). All
animation, frame data and hit work from 0.36 and earlier is unchanged; the AI
only chooses which legal inputs the simulation already understands.

## What the AI is

- Lives in `native-prototype/fighter-ai.h` as `FighterAI`, a deterministic
  state machine seeded with a fixed value (`0x2545f491`) and reseeded by
  `Game::reset()`, so identical runs replay identically.
- It emits only `Input` values a human can produce on the prototype controls:
  axis, jump, attack (with `attackMove`), smash charge, shield, grab, special
  presses, fast fall, taunt. No direct writes to the `Fighter`.
- Runs inside `Game::tick` when `Game::aiEnabled` is true (off by default in
  the shared simulation so all pre-existing native suites stay inert; the Vita
  build turns it on at startup). The playable game shows `AI MED` in the HUD;
  **Select + Up** toggles it (`AI OFF`).
- Runs at the same fixed 30 Hz as the rest of the simulation; the decision
  cadence is 4–8 ticks (~130–270 ms) with a bounded reaction window of 5–10
  ticks (~170–330 ms) — intentionally imperfect, i.e. medium level.

## Behavior menu

| Situation | Behavior |
| --- | --- |
| Neutral, foe far | Approach (double-tap into a dash at range), fireball at mid range, rare taunt when very far |
| Foe starts an attack in burst range (~85 px) | Reaction delay first, then: shield ~50 %, spot dodge, roll away (only if the roll stays on stage), or give space; air dodge when airborne |
| Foe mid-attack and the AI has reacted | Back off instead of challenging |
| Foe shielding up close | Shield-grab, then one pummel (50 %) and a throw (F 50 % / U 20 % / B 10 % / D 20 %) after a 6–14 tick hold |
| Foe in lag (landing lag, turn, stun, shield drop, get-up) | Punish with jab/tilts, occasionally a short-charged smash or a grab |
| Foe overhead | UTilt juggle or USmash |
| Foe airborne nearby | Full or short hop into UAir/FAir/NAir/BAir/DAir chosen from relative position |
| Fireball incoming | Shield on the ground, air dodge in the air |
| Very close, mix-up | Jab/FTilt/DTilt, occasional tornado (Down + Circle), occasional FSmash |
| Near the ledge with the foe offstage | Edge-guard: hold the ledge line, fireball; never walks/dashes off (approach stops ~90 px short, rolls/get-up rolls are bounds-checked) |
| Grabbed by the player | Mashes: direction alternating every two ticks plus attack/special presses — escapes a passive 45-tick grab in well under 30 ticks |
| Grabbed by a ledge | Climbs after the source ledge startup (age > 6) |
| Offstage | Drifts toward the stage, double jump while falling below the start height, then Up Special angled toward the stage (`attackFacing` set to the stage side); never holds fast fall while recovering |
| Heavy hit landing | Shields just before touchdown to tech (50 % window) |
| Getting up from a crash | Get-up attack if the foe is close, roll away if the roll stays on stage, otherwise stand up |
| Airborne and idle | Fast fall to return to neutral |

## Controls (0.37)

Unchanged from 0.36, plus the AI toggle:

- **Select + Up** — toggle opponent AI (HUD shows `AI MED` / `AI OFF`).
- Everything else as before: Square attack, Circle+direction special,
  L shield/dodge, R grab/throw, Triangle taunt, X jump, right stick smash,
  Select reset, Select+R heavyTest, Select+Triangle debug boxes.

## Related fix

Struggle inputs (axis changes, attack, special presses from the victim) now
only shorten a held grab while the holder is in `GrabHold`/`Pummel`. Mashing
during an in-progress throw no longer risks releasing the victim before the
authored release box.

## Validation

Native check suite (`native-prototype/check-simulation.cpp`), all seven suites:

- Recovery, Ground attack, Aerial, Movement, Action, Extended: 0 failures
  (unchanged behavior — AI is disabled by default in `ssf::Game`).
- New `runAiChecks` suite (`native-prototype/ai-checks.h`), run for both
  facings:
  - closes distance and damages a stationary foe;
  - reacts to repeated attacks with shield/spot dodge/roll/air dodge;
  - recovers from offstage (double jump → up special → lands on stage),
    no self-destructs;
  - is grabbable and mashes out before the passive release;
  - shield-grabs and throws a blocking opponent;
  - fires Fireballs at mid range;
  - never self-destructs and finishes neutral on stage (brief ledge chases
    while edge-guarding are legitimate and recovered from);
  - deterministic across identical runs; disabled AI leaves the dummy inert.
- Total failures: **0**.

Startup checks on the Vita run the same suites before graphics init and log
the results to `log.txt`.

## Known approximations

- Physical Vita testing of the AI (feel of the reaction window, toggle, HUD
  line length) is still pending.
- The AI never shields to reflect/cape a projectile it has not yet "seen";
  fireball vs. cape choices are simple rolls, not reads.
- Medium AI will occasionally challenge into a slow move or drop a combo —
  this is intentional headroom for harder levels later.
- Difficulty is a single fixed profile (medium); no per-level tuning yet.
