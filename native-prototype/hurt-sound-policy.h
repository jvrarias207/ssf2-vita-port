#pragma once

// Main.as / Character.takeDamage: light hurt sound is random 40%; bad hurt is
// guaranteed. The prototype additionally rate-limits voices per fighter so
// rapid multi-hit sequences do not become a repetitive chatter loop.
struct HurtSoundGate {
 int lastTick=-1000;
 unsigned rng=0x6d2b79f5u;
 unsigned random(){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
 bool allow(int tick,bool bad){
  if(tick-lastTick<12)return false;
  lastTick=tick;
  return bad||(random()%100)<40;
 }
};
