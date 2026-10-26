"""Read-only checks of source slices, script bindings and generated frame indices."""
from pathlib import Path
import json,re

BASE=Path(__file__).resolve().parent
def load(path):
    return json.loads((BASE/path).read_text(encoding='utf-8-sig'))
meta=load('prototype-assets/viewer/animation-data.json')['animations']
geometry=load('prototype-assets/viewer/authored-hitboxes.json')['animations']
layout=load('native-prototype/assets/atlas-layout.json')['animations']
header=(BASE/'native-prototype/generated-assets.h').read_text()
simulation=(BASE/'native-prototype/simulation.h').read_text()
enum=re.search(r'enum Anim \{([^}]+)',simulation)[1].split(',')
aliases={'Hurt':'Hurts','Flying':'SentFlying','Tumble':'TumbleFall'}
assert [aliases.get(n,n) for n in enum]==[a['name'] for a in meta]==[a['name'] for a in geometry]==[a['name'] for a in layout]
def array(name):
    return list(map(int,re.search(rf'{name}\[\] = \{{([^}}]+)',header)[1].split(',')))
assert array('ANIM_START')==[a['start'] for a in layout]
assert array('ANIM_COUNT')==[len(a['frames']) for a in meta]==[len(a['frames']) for a in geometry]==[a['count'] for a in layout]
offset=0
for a,g,l in zip(meta,geometry,layout):
    assert l['start']==offset
    assert all(f['sourceFrame']>0 for f in a['frames'])
    offset+=len(a['frames'])
by={a['name']:a for a in meta}
for name,start,end in [('Run',1,15),('Dash',16,21),('Turn',22,31),('Skid',1,7),('Land',1,8)]:
    frames=by[name]['frames']
    assert [f['sourceFrame'] for f in frames]==list(range(start,end+1)),name
    assert frames[0]['eventMethod']==f'frame{start}',name
    assert frames[-1]['eventMethod']==f'frame{end}',name
    assert frames[-1]['eventSource'].strip(),name
assert by['Land']['frames'][3]['labels']==['dodgeland']
assert 'endAttack' in by['Land']['frames'][2]['eventSource']
assert 'setLandingLag(false)' in by['UAir']['frames'][8]['eventSource']
assert by['Crouch']['frames'][3]['labels']==['loop']
assert by['Shield']['frames'][2]['labels']==['pause']
assert by['ShieldDrop']['frames'][0]['sourceFrame']==5
assert by['Uncrouch']['frames'][0]['sourceFrame']==65
for name in ['NSpecial','NSpecialAir']:
    assert 'fireProjectile("mario_fireball",22,-20)' in by[name]['frames'][8]['eventSource']
for name in ['SSpecial','SSpecialAir']:
    assert 'mario_cape' in by[name]['frames'][5]['eventSource']
for name in ['USpecial','USpecialAir']:
    assert 'setIntangibility(true)' in by[name]['frames'][1]['eventSource']
    assert '"damage":3' in by[name]['frames'][11]['eventSource']
    assert 'toHelpless' in by[name]['frames'][21]['eventSource']
assert '"damage":5' in by['DSpecial']['frames'][20]['eventSource']
assert by['Fireball']['frames'][1]['labels']==['loop']
images=(BASE/'vita-prototype/atlas.h').read_text()
assert len(re.findall(r'\{-?\d+,-?\d+,-?\d+,-?\d+,-?\d+,-?\d+\}',images))==offset
assert 'chargeTicks/40' not in simulation
print(f'PASS: source slices, terminal events, enum/layout order, geometry frame counts, and {offset} texture indices')
