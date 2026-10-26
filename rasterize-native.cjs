const {chromium}=require('C:/Users/javon/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const fs=require('fs'),path=require('path'),{pathToFileURL}=require('url');
(async()=>{
const browser=await chromium.launch({headless:true,executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'});
const page=await browser.newPage();
await page.goto(pathToFileURL(path.join(__dirname,'prototype-assets/viewer/index.html')).href);
const layout=JSON.parse(fs.readFileSync(path.join(__dirname,'native-prototype/assets/atlas-layout.json')));
const result=await page.evaluate(async layout=>{
 const canvas=document.createElement('canvas');canvas.width=layout.cell*layout.columns;canvas.height=layout.cell*Math.ceil(layout.animations.reduce((n,a)=>n+a.count,0)/layout.columns);
 const ctx=canvas.getContext('2d');ctx.imageSmoothingEnabled=false;
 let index=0,clipped=[];
 for(let i=0;i<ASSET_DATA.animations.length;i++)for(const f of ASSET_DATA.animations[i].frames){
  const doc=new DOMParser().parseFromString(f.svg,'image/svg+xml'),svg=doc.documentElement;
  svg.setAttribute('width',layout.cell);svg.setAttribute('height',layout.cell);svg.setAttribute('viewBox',`-${layout.origin[0]} -${layout.origin[1]} ${layout.cell} ${layout.cell}`);
  const g=Array.from(svg.children).find(e=>e.tagName==='g');g.setAttribute('transform',`matrix(${layout.animations[i].matrix.join(',')})`);
  for(const el of g.children)if(/^(attackBox|hitBox|grabBox|itemBox|hand|range|touchBox|shieldBox|ledgeBox)\d*$/.test(el.id))el.setAttribute('visibility','hidden');
  svg.querySelectorAll('image').forEach(e=>e.setAttribute('style','image-rendering:pixelated'));
  const url=URL.createObjectURL(new Blob([new XMLSerializer().serializeToString(svg)],{type:'image/svg+xml'}));
  const img=new Image();img.src=url;await img.decode();
  ctx.drawImage(img,(index%layout.columns)*layout.cell,Math.floor(index/layout.columns)*layout.cell);URL.revokeObjectURL(url);index++;
 }
 // Any nontransparent edge pixel signals that the selected atlas cell might crop artwork.
 const pixels=ctx.getImageData(0,0,canvas.width,canvas.height).data;
 for(let n=0;n<index;n++){let edge=false;const ox=(n%layout.columns)*layout.cell,oy=Math.floor(n/layout.columns)*layout.cell;
  for(let k=0;k<layout.cell;k++)for(const [x,y] of [[ox+k,oy],[ox+k,oy+layout.cell-1],[ox,oy+k],[ox+layout.cell-1,oy+k]])if(pixels[(y*canvas.width+x)*4+3])edge=true;
  if(edge)clipped.push(n);
 }
 return {png:canvas.toDataURL('image/png').split(',')[1],frames:index,clipped};
},layout);
fs.writeFileSync(path.join(__dirname,'native-prototype/assets/mario-atlas.png'),Buffer.from(result.png,'base64'));
delete result.png;fs.writeFileSync(path.join(__dirname,'native-prototype/assets/raster-check.json'),JSON.stringify(result,null,2));
console.log(result);await browser.close();
})().catch(e=>{console.error(e);process.exit(1)});
