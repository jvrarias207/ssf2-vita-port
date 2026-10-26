# 0.38 — AI review and controls

## Controls
- Square or Triangle: jump (hold for full hop).
- Circle: normal attack; fresh direction + Circle in the same controller sample:
  directional smash; direction held before Circle: directional tilt. Running
  attacks retain the existing dash-attack rule.
- Hold Circle to charge a Circle-initiated smash; release to strike. Right-stick
  smashes charge while the stick is deflected and release on returning to neutral.
- X + direction: specials (neutral Fireball, side Cape, up Super Jump Punch,
  down Tornado). X taps provide Tornado lift.
- Right stick airborne: up/down aerial; horizontal forward/back aerial relative
  to facing. Neutral Circle gives neutral aerial. A new stick direction triggers
  once, including direction changes without centering; holding does not spam.
- Right trigger: shield/dodge. Left trigger: grab/pummel/throw.
- Select: reset. Select+R: heavy test. Select+Triangle: debug boxes.
  Select+Up: AI toggle. Start: pause. L while paused: single simulation step.
  Triangle is no longer the taunt button.

## AI corrections
- Corrected facing sign for incoming melee threats and velocity sign for incoming
  projectiles; departing projectiles no longer count as incoming.
- Low shield chooses a dodge rather than repeatedly trying to shield.
- Short hops now release jump; previously their shared hold counter forced full hops.
- Recovery interrupts stale plans, persists until landing, and aerial approaches
  brake before the ledge so long uncancellable aerials do not drift into a fall.
- Removed the 62–70-unit approach dead zone; ground strikes face the target.
- A reacted spacing plan transitions to defense without reselecting unrelated
  plans every tick.

## References and verification
Reference: exported `ssf2 exports/scripts/com/mcleodgaming/ssf2/engine/Character.as`
(direction/smash timers around lines 6930–6966), original Mario timelines and the
existing generated animation data. The requested standalone master data sheet was
not found locally; no claim of checking that sheet is made. Same-sample smash
selection follows the requested control scheme; the original source has a wider
direction timing window. Existing animation frames, damage, dash/fast-fall physics,
60-tick full charge, 120-tick maximum hold and 1.4x damage cap are retained.

Regression coverage adds approaching/departing projectiles, melee facing, low
shield, interrupted recovery, short/full hop distinction, and requires an observed
throw rather than merely damage in the shield-grab test. Physical Vita testing
of the new layout and difficulty feel remains pending.
