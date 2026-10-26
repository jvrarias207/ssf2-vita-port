from pathlib import Path
import json, re, runpy, xml.etree.ElementTree as ET
BASE=Path(__file__).resolve().parent
m=runpy.run_path(str(BASE/'build-viewer.py'))
OUT=BASE/'native-prototype'
(OUT/'assets').mkdir(parents=True,exist_ok=True)
meta=json.loads((BASE/'prototype-assets/viewer/animation-data.json').read_text())
boxes=json.loads((BASE/'prototype-assets/viewer/authored-hitboxes.json').read_text())
parent=m['timeline'](m['sprites'][1484])
transforms={p['symbolId']:p['matrix'] for f in parent for p in f['placements'] if p.get('name')=='stance'}
headers=['// Generated from supplied SSF2 assets. Coordinates are character-local pixels.', '#pragma once', 'struct Box {float x,y,w,h; int attack;};', 'struct Frame {int offset,count;};']
assert len(meta['animations'])==len(boxes['animations']), 'Regenerate authored hitboxes before preparing native assets'
allboxes=[]; allframes=[]; anims=[]; atlas=0; markers=[]; marker_frames=[]; intangible=[]; throw_rotation=[]; throw_flip=[]; throw_spin=[]; camera_shake=[]
for anim, geometry in zip(meta['animations'],boxes['animations']):
    assert anim['name']==geometry['name']
    # A missing placement is an extraction error, never an excuse to use Walk's transform.
    transform=anim.get('matrix') or transforms[anim.get('transformSymbolId', anim['symbolId'])]
    a,b,c,d,tx,ty=transform
    anims.append({'name':anim['name'],'start':atlas,'count':len(anim['frames']),'matrix':transform})
    invulnerable=False
    for i,frame in enumerate(geometry['frames']):
        event=anim['frames'][i].get('eventSource','')
        changes=re.findall(r'setIntangibility\((true|false)\)',event)
        if changes:invulnerable=changes[-1]=='true'
        intangible.append(int(invulnerable))
        rotations=re.findall(r'this\.enemy\.setRotation\((-?\d+(?:\.\d+)?)\)',event)
        throw_rotation.append(float(rotations[-1]) if rotations else 0.0 if 'this.enemy.resetRotation()' in event else 9999.0)
        throw_flip.append(int('this.enemy.flip()' in event))
        throw_spin.append(int('forceGrabbedHurtFrame("spin")' in event))
        shakes=re.findall(r'SSF2API\.getCamera\(\)\.shake\((\d+)\)',event)
        camera_shake.append(int(shakes[-1]) if shakes else 0)
        start=len(allboxes)
        marker_start=len(markers)
        for box in frame['boxes']:
            kind=next((v for k,v in [('grabBox',1),('touchBox',2),('hand',3)] if box['name'].startswith(k)),0)
            if not kind and not box['name'].startswith(('attackBox','hitBox')): continue
            pts=[(a*p['x']+c*p['y']+tx,b*p['x']+d*p['y']+ty) for p in box['corners']]
            xs,ys=zip(*pts)
            if kind:markers.append((min(xs),min(ys),max(xs)-min(xs),max(ys)-min(ys),kind))
            else:
                attack_id=int(box['name'][9:] or '1') if box['name'].startswith('attackBox') else 0
                allboxes.append((min(xs),min(ys),max(xs)-min(xs),max(ys)-min(ys),attack_id))
        allframes.append((start,len(allboxes)-start)); atlas+=1
        marker_frames.append((marker_start,len(markers)-marker_start))
headers.append('inline const Box BOXES[] = {'+','.join('{'+','.join(str(round(x,6))+'f' if isinstance(x,float) else str(x) for x in v)+'}' for v in allboxes)+'};')
headers.append('inline const Frame FRAMES[] = {'+','.join('{%d,%d}'%v for v in allframes)+'};')
headers.append('inline const int ANIM_START[] = {'+','.join(str(a['start']) for a in anims)+'};')
headers.append('inline const int ANIM_COUNT[] = {'+','.join(str(a['count']) for a in anims)+'};')
headers.append('inline const Box MARKERS[] = {'+','.join('{'+','.join(str(round(x,6))+'f' if isinstance(x,float) else str(x) for x in v)+'}' for v in markers)+'};')
headers.append('inline const Frame MARKER_FRAMES[] = {'+','.join('{%d,%d}'%v for v in marker_frames)+'};')
headers.append('inline const bool FRAME_INTANGIBLE[] = {'+','.join(map(str,intangible))+'};')
headers.append('inline const float FRAME_THROW_ROTATION[] = {'+','.join(str(x)+'f' for x in throw_rotation)+'};')
headers.append('inline const bool FRAME_THROW_FLIP[] = {'+','.join(map(str,throw_flip))+'};')
headers.append('inline const bool FRAME_THROW_SPIN[] = {'+','.join(map(str,throw_spin))+'};')
headers.append('inline const int FRAME_CAMERA_SHAKE[] = {'+','.join(map(str,camera_shake))+'};')
# Extract terrain outline and its placement matrix from FFDec SVG.
svg=ET.parse(BASE/'prototype-assets/stage-svg/DefineSprite_61/1.svg').getroot()
ns={'s':'http://www.w3.org/2000/svg'}
terrain=next(p for p in svg.findall('.//s:path',ns) if p.get('fill')=='#00ff33')
xy=list(map(float,re.findall(r'-?\d+(?:\.\d+)?',terrain.get('d'))))
use=svg.find('s:g/s:use',ns)
mat=list(map(float,re.findall(r'-?\d+(?:\.\d+)?',use.get('transform'))))
a,b,c,d,tx,ty=mat
polygon=[(a*x+c*y+tx,b*x+d*y+ty) for x,y in zip(xy[::2],xy[1::2])]
top=min(y for x,y in polygon)
surface=[x for x,y in polygon if abs(y-top)<.001]
headers += ['struct PointF2 {float x,y;};','inline const PointF2 TERRAIN[] = {'+','.join('{%.6ff,%.6ff}'%p for p in polygon)+'};',f'inline constexpr float GROUND={top:.6f}f, LEFT={min(surface):.6f}f, RIGHT={max(surface):.6f}f;']
for name,prefix in [('camBoundary','CAM'),('deathBoundary','DEATH')]:
    marker=next(u for u in svg.find('s:g',ns) if u.get('id')==name)
    a,b,c,d,tx,ty=map(float,re.findall(r'-?\d+(?:\.\d+)?',marker.get('transform')))
    w,h=float(marker.get('width')),float(marker.get('height'))
    points=[(a*x+c*y+tx,b*x+d*y+ty) for x,y in [(0,0),(w,0),(w,h),(0,h)]]
    xs,ys=zip(*points)
    headers.append(f'inline constexpr float {prefix}_LEFT={min(xs):.6f}f,{prefix}_RIGHT={max(xs):.6f}f,{prefix}_TOP={min(ys):.6f}f,{prefix}_BOTTOM={max(ys):.6f}f;')
for suffix,prefix in [('ledge_mc_left__17','LEDGE_LEFT'),('ledge_mc_right__16','LEDGE_RIGHT')]:
    marker=next(u for u in svg.find('s:g',ns) if u.get('{https://www.free-decompiler.com/flash}characterName','').endswith(suffix))
    a,b,c,d,tx,ty=map(float,re.findall(r'-?\d+(?:\.\d+)?',marker.get('transform')))
    w,h=float(marker.get('width'))*abs(a),float(marker.get('height'))*abs(d)
    headers.append(f'inline constexpr float {prefix}_X={tx:.6f}f,{prefix}_Y={ty:.6f}f,{prefix}_W={w:.6f}f,{prefix}_H={h:.6f}f;')
stage={'polygon':polygon,'surface':{'left':min(surface),'right':max(surface),'y':top},'markers':[]}
for u in svg.find('s:g',ns):
    if u.tag.endswith('use'):
        stage['markers'].append(dict(u.attrib))
(OUT/'assets/stage.json').write_text(json.dumps(stage,indent=2))
(OUT/'assets/atlas-layout.json').write_text(json.dumps({'cell':192,'origin':[96,128],'columns':16,'animations':anims},indent=2))
(OUT/'generated-assets.h').write_text('\n'.join(headers))
print(json.dumps({'frames':len(allframes),'boxes':len(allboxes),'stage':stage['surface'],'transforms':anims},indent=2))
