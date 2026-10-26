# Validated combat baseline — retain for future characters

User confirmed Vita 0.15's launch angles, damage calculations, gravity and character weights on 2026-10-22. Treat this as the regression baseline when adding moves/characters. Do not retune the common physics to compensate for incorrect character data.

- 30 simulation ticks/second; movement and gravity are separate from knockback.
- Knockback is applied in two substeps per tick, decaying after each substep.
- Knockback speed = KB * 0.03 * 3.488. Directional decay magnitude = 3.488 * 0.051 per substep.
- With weight-based KB: KB = ((weightKB * 10 * 0.05 + 1) * 1.4 * (200 / (weight + 100)) + 18) * (kbConstant / 100) + power.
- Otherwise: KB = (((oldDamage + hitDamage) * 0.1 + hitDamage * (oldDamage + hitDamage) * 0.05) * 1.4 * (200 / (weight + 100)) + 18) * (kbConstant / 100) + power.
- Mirror the launch using source reversible-angle rules, including backward angles above 90 degrees.
- Normal fall-speed caps do not cap knockback. Clear ordinary velocity on a new hit. Preserve the established stacking behavior.
- Source HitStun is the short stationary action-shot pause; HitLag is a moving recovery timer. Never use the latter to freeze both fighters.
- Moving recovery = floor(KB * 0.4 * (30 / 60)); defaults for action pause and attacker pause are damage-dependent, unless a move overrides them.
- Mario's current defaults: weight 100, gravity 1.3, walk speed 4, jump speed 17.4, short hop 9.5. Future fighters must supply their own character values rather than replacing these globally.
- Mario jab base data: 3/2/5 damage, 80/70/45 degrees; first two weightKB 20, power 0, kbConstant 100; final weightKB 0, power 40, kbConstant 100. Target stationary pause 3 ticks; attacker 2/1/2 ticks.

Scope: native prototype, without move staling, DI, or every original collision/state exception. See vita-prototype/JAB-PHYSICS-0.15.md for source references and limitations. Preserve this distinction when describing fidelity.
