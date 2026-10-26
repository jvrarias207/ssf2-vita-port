// Extract collision geometry from the same SVG frames used for artwork.
// Run build-viewer.py first. No recovered ActionScript is executed.
const {chromium}=require('C:/Users/javon/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const fs=require('fs'),path=require('path');
(async()=>{
 const entries=JSON.parse(fs.readFileSync(path.join(__dirname,'prototype-assets/mario-animation-index.json'),'utf8'));
 const metadata=JSON.parse(fs.readFileSync(path.join(__dirname,'prototype-assets/viewer/animation-data.json'),'utf8'));
 const frames=metadata.animations.map(a=>{
  const e=entries.find(e=>e.name.split('.').pop().split('_')[0]===a.name);
  const folder=e.svgFolder||`DefineSprite_${e.symbolId}_${e.name}`;
  return {name:a.name,frames:a.frames.map((f,i)=>fs.readFileSync(path.join(__dirname,'prototype-assets/animation-svg',folder,`${e.svgUsesSourceFrames?f.sourceFrame:i+1}.svg`),'utf8'))};
 });
 const browser=await chromium.launch({headless:true,executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'});
 try{
  const page=await browser.newPage();await page.goto('about:blank');
  const animations=await page.evaluate(data=>data.map(a=>({name:a.name,frames:a.frames.map((text,i)=>{
   const host=document.createElement('div');host.innerHTML=text;document.body.append(host);
   const svg=host.querySelector('svg'),group=Array.from(svg.children).find(e=>e.tagName==='g');
   const boxes=Array.from(group.children).filter(e=>/^(attackBox|hitBox|grabBox|itemBox|hand|range|touchBox|shieldBox|ledgeBox)\d*$/.test(e.id)).map(e=>{
    const b=e.getBBox(),m=e.transform.baseVal.consolidate()?.matrix||new DOMMatrix();
    const corners=[[b.x,b.y],[b.x+b.width,b.y],[b.x+b.width,b.y+b.height],[b.x,b.y+b.height]].map(([x,y])=>{const p=new DOMPoint(x,y).matrixTransform(m);return {x:p.x,y:p.y};});
    const xs=corners.map(p=>p.x),ys=corners.map(p=>p.y),x=Math.min(...xs),y=Math.min(...ys);
    return {name:e.id,corners,aabb:{x,y,width:Math.max(...xs)-x,height:Math.max(...ys)-y}};
   });host.remove();return {frame:i+1,boxes};
  })})),frames);
  const out={coordinateSpace:'Animation-local SVG coordinates; source helper transforms, before character stance placement.',animations};
  const destination=path.join(__dirname,'prototype-assets/viewer/authored-hitboxes.json');
  if(process.argv.includes('--check')){
   const existing=JSON.parse(fs.readFileSync(destination,'utf8'));
   if(JSON.stringify(existing.animations)!==JSON.stringify(animations))throw new Error('Authored collision geometry differs from source SVG frames; regenerate it.');
  }else fs.writeFileSync(destination,JSON.stringify(out,null,2));
  console.log(`${process.argv.includes('--check')?'Verified':'Extracted'} source helper geometry for ${animations.length} animations / ${animations.reduce((n,a)=>n+a.frames.length,0)} frames`);
 }finally{await browser.close();}
})().catch(e=>{console.error(e);process.exit(1)});
