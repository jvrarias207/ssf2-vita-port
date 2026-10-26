"""Register original Mario action timelines from a complete FFDec sprite SVG export."""
from pathlib import Path
import json,re,shutil,sys,xml.etree.ElementTree as ET
BASE=Path(__file__).resolve().parent
export=Path(sys.argv[1])
index_path=BASE/'prototype-assets/mario-animation-index.json'
entries=json.loads(index_path.read_text(encoding='utf-8-sig'))
root=ET.parse(BASE/'prototype-assets/mario.xml').getroot()
sprites={int(e.get('spriteId')):e for e in root.iter() if e.get('type')=='DefineSpriteTag'}
actions=[('Crouch','mario_fla.Crouch_69',None),('Uncrouch','mario_fla.Idle_3',(65,68)),
 ('Shield','mario_fla.Guard_82',(1,4)),('ShieldDrop','mario_fla.Guard_82',(5,10)),
 ('NSpecial','mario_fla.NSpecial_32',None),('NSpecialAir','mario_fla.NSpecialAir_33',None),
 ('SSpecial','mario_fla.SSpecial_36',None),('SSpecialAir','mario_fla.SSpecialAir_37',None),
 ('USpecial','mario_fla.USpecial_34',None),('USpecialAir','mario_fla.USpecialAir_35',None),
 ('DSpecial','mario_fla.DSpecial_38',None),('Helpless','mario_fla.SpecialFall_20',None),
 ('SpecialLand','mario_fla.SpecialLand_22',None),('Dizzy','mario_fla.Dizzy_83',None),
 ('Fireball','mario_fla.mario_fireball_mc_219',None),
 ('Grab','mario_fla.Grab_Pummel_71',(1,16)),('DashGrab','mario_fla.Grab_Pummel_71',(17,37)),
 ('GrabHold','mario_fla.Grab_Pummel_71',(38,40)),('Pummel','mario_fla.Grab_Pummel_71',(41,51)),
 ('Caught','mario_fla.Hurts_72',(1,10)),('FThrow','mario_fla.FThrow_46',None),
 ('BThrow','mario_fla.BThrow_48',None),('UThrow','mario_fla.UThrow_45',None),('DThrow','mario_fla.DThrow_47',None),
 ('DashAttack','mario_fla.DashAttack_24',None),('Hang','mario_fla.Hang_78',None),
 ('HangClimb','mario_fla.HangClimb_79',None),('HangRoll','mario_fla.HangRoll_80',None),
 ('HangAttack','mario_fla.HangAttack_81',None),('GetUpRoll','mario_fla.GetUpRoll_89',None),
 ('GetUpAttack','mario_fla.GetUpAttack_90',None),('DodgeRoll','mario_fla.Roll_74',None),
 ('SpotDodge','mario_fla.SpotDodge_76',None),('AirDodge','mario_fla.AirDodge_75',None),
 ('TechGround','mario_fla.TechGround_212',None),('TechRoll','mario_fla.TechRoll_213',None),
 ('EdgeLean','mario_fla.EdgeLean_91',None),('TauntSide','mario_fla.Taunts_94',(1,42)),
 ('TauntNeutral','mario_fla.Taunts_94',(43,115)),('TauntUpDown','mario_fla.Taunts_94',(116,161)),
 ('DodgeLand','mario_fla.Land_21',(4,8)),('CaughtSpin','mario_fla.Hurts_72',(71,80))]
for name,source,rng in actions:
 text=(BASE/'resource-scripts/DAT357/scripts'/(source.replace('.','/')+'.as')).read_text()
 sid=int(re.search(r'symbol="symbol(\d+)"',text)[1])
 folder=f'DefineSprite_{sid}_{source}'
 original=export/folder
 assert original.is_dir(),original
 target=BASE/'prototype-assets/animation-svg'/folder;target.mkdir(exist_ok=True)
 for svg in original.glob('*.svg'):shutil.copy2(svg,target/svg.name)
 entry={'name':f'mario_fla.{name}_{sid}','sourceClass':source,'symbolId':sid,
        'frameCount':rng[1]-rng[0]+1 if rng else int(sprites[sid].get('frameCount')),
        'svgFolder':folder,'svgUsesSourceFrames':True,'labels':[]}
 if rng:entry['frameRange']=list(rng)
 if name=='Fireball':entry['matrix']=[.8899994,0,0,.8899994,-7.5,9.15] # stance in source symbol 221
 entries=[e for e in entries if e['name'].split('.')[-1].split('_')[0]!=name]
 entries.append(entry)
index_path.write_text(json.dumps(entries,indent=2)+'\n')
print(f'Registered {len(actions)} source action timelines')
