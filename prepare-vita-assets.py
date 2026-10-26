from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import hashlib,json,math
BASE=Path(__file__).resolve().parent
OUT=BASE/'vita-prototype'
(OUT/'assets').mkdir(parents=True,exist_ok=True)
(OUT/'sce_sys/livearea/contents').mkdir(parents=True,exist_ok=True)
source=Image.open(BASE/'native-prototype/assets/mario-atlas.png').convert('RGBA')
unique=[]; lookup={}; frames=[]
frameCount=sum(a['count'] for a in json.loads((BASE/'native-prototype/assets/atlas-layout.json').read_text())['animations'])
for index in range(frameCount):
    cell=source.crop(((index%16)*192,(index//16)*192,(index%16+1)*192,(index//16+1)*192))
    bbox=cell.getbbox() or (0,0,1,1)
    crop=cell.crop(bbox)
    key=(crop.size,hashlib.sha256(crop.tobytes()).hexdigest())
    if key not in lookup:
        lookup[key]=len(unique);unique.append(crop)
    frames.append((lookup[key],bbox[0]-96,bbox[1]-128))
width=1024;x=y=row=0;positions=[]
for im in unique:
    w,h=im.size
    if x+w+2>width:x=0;y+=row;row=0
    positions.append((x+1,y+1));x+=w+2;row=max(row,h+2)
height=2**math.ceil(math.log2(y+row))
atlas=Image.new('RGBA',(width,height))
for im,(x,y) in zip(unique,positions):atlas.paste(im,(x,y))
atlas.save(OUT/'assets/mario-atlas-preview.png')
(OUT/'assets/mario.rgba').write_bytes(atlas.tobytes())
rows=[]
for uid,dx,dy in frames:
    x,y=positions[uid];w,h=unique[uid].size
    rows.append((x,y,w,h,dx,dy))
header=['#pragma once',f'constexpr int ATLAS_W={width},ATLAS_H={height};',
        'struct FrameImage {int x,y,w,h,dx,dy;};',
        'const FrameImage IMAGES[]={'+','.join('{'+','.join(map(str,r))+'}' for r in rows)+'};']
(OUT/'atlas.h').write_text('\n'.join(header))
# Exact round-trip check for all trimmed source cells.
for index,(uid,dx,dy) in enumerate(frames):
    x,y=positions[uid];w,h=unique[uid].size
    restored=Image.new('RGBA',(192,192));restored.paste(atlas.crop((x,y,x+w,y+h)),(dx+96,dy+128))
    old=source.crop(((index%16)*192,(index//16)*192,(index%16+1)*192,(index//16+1)*192))
    # Transparent RGB is irrelevant; compare alpha and visible pixels.
    assert restored.getchannel('A').tobytes()==old.getchannel('A').tobytes()
    assert Image.alpha_composite(Image.new('RGBA',old.size,(0,0,0,255)),restored).tobytes()==Image.alpha_composite(Image.new('RGBA',old.size,(0,0,0,255)),old).tobytes()
font=ImageFont.truetype('C:/Windows/Fonts/consola.ttf',15)
fontAtlas=Image.new('RGBA',(256,128));draw=ImageDraw.Draw(fontAtlas)
for code in range(32,128):
    i=code-32;draw.text(((i%16)*12,(i//16)*20),chr(code),font=font,fill='white')
(OUT/'assets/font.rgba').write_bytes(fontAtlas.tobytes())
icon=Image.new('RGBA',(128,128),(15,24,39,255));d=ImageDraw.Draw(icon)
d.rounded_rectangle((3,3,124,124),radius=20,outline=(110,215,185),width=3)
d.text((17,12),'SSF2',font=ImageFont.truetype('C:/Windows/Fonts/consolab.ttf',30),fill='white')
sprite=unique[frames[0][0]];sprite=sprite.resize((sprite.width*2,sprite.height*2),Image.Resampling.NEAREST)
icon.alpha_composite(sprite,((128-sprite.width)//2,40));icon.save(OUT/'sce_sys/icon0.png')
bg=Image.new('RGB',(840,500),(15,24,39));d=ImageDraw.Draw(bg)
d.text((50,70),'SSF2 / VITA PROTOTYPE',font=ImageFont.truetype('C:/Windows/Fonts/consolab.ttf',38),fill='white')
d.text((50,140),'Mario + Final Destination',font=ImageFont.truetype('C:/Windows/Fonts/consola.ttf',25),fill=(120,215,190))
d.text((50,205),'Cross: jump   Square: jab\nD-pad / stick: move\nStart: pause   Select: reset',font=ImageFont.truetype('C:/Windows/Fonts/consola.ttf',22),fill='white',spacing=15)
bg.save(OUT/'sce_sys/livearea/contents/bg.png')
startup=Image.new('RGB',(280,158),(24,44,55));ImageDraw.Draw(startup).text((50,52),'PLAY TEST',font=ImageFont.truetype('C:/Windows/Fonts/consolab.ttf',30),fill='white');startup.save(OUT/'sce_sys/livearea/contents/startup.png')
(OUT/'sce_sys/livearea/contents/template.xml').write_text('''<?xml version="1.0" encoding="utf-8"?>
<livearea style="a1" format-ver="01.00" content-rev="1"><livearea-background><image>bg.png</image></livearea-background><gate><startup-image>startup.png</startup-image></gate></livearea>''')
# Vita LiveArea expects indexed PNGs. Gameplay textures remain lossless RGBA.
for path in (OUT/'sce_sys').rglob('*.png'):
    with Image.open(path) as image:
        indexed=image.convert('RGB').quantize(colors=256)
    indexed.save(path,bits=8)
report={'sourceFrames':frameCount,'uniqueCrops':len(unique),'textureWidth':width,'textureHeight':height,'textureBytes':width*height*4,'previousTextureBytes':source.width*source.height*4,'roundTripFramesPassed':frameCount}
(OUT/'asset-validation.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))
