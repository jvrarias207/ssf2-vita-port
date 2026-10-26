# Jab physics audit — 0.15

Compared supplied Mario Main.as and mario_fla/Jab_23.as with engine Utils.as, Character.as, InteractiveSprite.as and AttackDamage.as. No original synced files were modified.

| Phase | Damage | Base angle | Weight KB | Power | KB constant | Target action pause |
|---|---|---|---|---|---|---|
| 1 | 3 | 80 degrees | 20 | 0 | 100 | 3 ticks |
| 2 | 2 | 70 degrees | 20 | 0 | 100 | 3 ticks |
| 3 | 5 | 45 degrees | 0 | 40 | 100 | 3 ticks |

Jab frame 9 updates attackBox 1 only; source geometry shows it is the only active box in jab 2. Frame 19 updates both boxes for jab 3. The fresh, unstaled base total remains 10%. The prototype does not implement move staling, DI or special damage modifiers.

Root cause: the previous code stored knockback in normal vx/vy. Gravity, ordinary friction and the fall-speed cap then modified the launch vector incorrectly, and knockback ran only once per tick. Source Character.m_forces applies two successive knockback movements/decays at 30 FPS; normal gravity is separate. Decay magnitude comes from Utils.VELOCITY_SCALE (3.488) times WEIGHT2_BASE (0.051).

Implementation now stores kx/ky and projected decay separately, performs two collision-aware knockback substeps, then applies normal movement/gravity. Utils.calculateReversedAngle's default reversable behavior sends the receiver away from the attack origin. The usual five-tick overlapping-hit stacking path uses component summing for opposite signs and the stronger component for equal signs. Same-frame special-case stacking and other attack types remain outside this prototype.

Hit timing: source HitStun means action-shot freeze; HitLag means moving recovery. The corrected short pause from 0.14 is retained. Heavy flight/tumble transition now follows recovery expiration instead of vertical-velocity sign. Light injured recovery uses the source's 12-tick grounded and 15-tick airborne gates within the simplified state machine; it is not a complete port of collision/landing cancellation logic.

Added startup checks exercise the real C++ simulation for all phases and both facings, plus independently calculated two-substep displacement/decay values. They run on Vita and log PASS/FAIL. No local execution claim is made: Windows verification remains skipped. Package validation is recorded separately in package-validation.json.
