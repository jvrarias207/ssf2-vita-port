const {chromium} = require('C:/Users/javon/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const {pathToFileURL} = require('url');
const path = require('path');
const fs = require('fs');
(async()=>{
 const browser=await chromium.launch({headless:true,executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'});
 const page=await browser.newPage({viewport:{width:1360,height:1000}});
 const errors=[];page.on('pageerror',e=>errors.push(e.message));
 await page.goto(pathToFileURL(path.join(__dirname,'prototype-assets/viewer/index.html')).href);
 const geometry=await page.evaluate(()=>{
   const result={coordinateSpace:'Animation symbol local coordinates; authored SVG bounds, before runtime changes',animations:[]};
   for(let i=0;i<data.animations.length;i++){
     ai=i;const animation={name:data.animations[i].name,frames:[]};
     for(let j=0;j<data.animations[i].frames.length;j++){
       fi=j;render();
       const boxes=Array.from(document.querySelectorAll('[data-overlay]')).map(r=>{
         const m=r.transform.baseVal.consolidate().matrix;
         const x=+r.getAttribute('x'),y=+r.getAttribute('y'),w=+r.getAttribute('width'),h=+r.getAttribute('height');
         const corners=[[x,y],[x+w,y],[x+w,y+h],[x,y+h]].map(([px,py])=>({x:m.a*px+m.c*py+m.e,y:m.b*px+m.d*py+m.f}));
         const xs=corners.map(p=>p.x),ys=corners.map(p=>p.y);
         return {name:r.dataset.overlay,corners,aabb:{x:Math.min(...xs),y:Math.min(...ys),width:Math.max(...xs)-Math.min(...xs),height:Math.max(...ys)-Math.min(...ys)}};
       });
       if(boxes.some(b=>b.corners.some(p=>!Number.isFinite(p.x)||!Number.isFinite(p.y))))throw Error('Invalid bounds');
       animation.frames.push({frame:j+1,boxes});
     }
     result.animations.push(animation);
   }
   return result;
 });
 fs.writeFileSync(path.join(__dirname,'prototype-assets/viewer/authored-hitboxes.json'),JSON.stringify(geometry,null,2));
 await page.selectOption('#animation','5');
 await page.locator('#next').click();
 const check=await page.evaluate(()=>{
   const r=document.querySelector('[data-overlay="attackBox"]');
   return {frame:document.querySelector('#position').textContent,attack:!!r,
     width:r?+r.getAttribute('width'):0,event:document.querySelector('#event').textContent};
 });
 if(check.frame!=='2 / 30'||!check.attack||check.width<=0||!check.event.includes('attachEffect'))throw Error(JSON.stringify(check));
 await page.screenshot({path:path.join(__dirname,'prototype-assets/viewer/mario-preview.png'),fullPage:true});
 await page.locator('#scrub').fill('9');await page.locator('#scrub').dispatchEvent('input');
 if(!(await page.locator('#event').textContent()).includes('damage'))throw Error('Frame 9 event missing');
 await page.locator('#play').click();await page.waitForTimeout(180);await page.locator('#play').click();
 if((await page.locator('#position').textContent())==='9 / 30')throw Error('Playback did not advance');
 await page.locator('#stageTab').click();
 const count=await page.locator('[data-overlay]').count();
 if(count<10)throw Error('Missing stage markers');
 await page.screenshot({path:path.join(__dirname,'prototype-assets/viewer/stage-preview.png'),fullPage:true});
 await page.setViewportSize({width:600,height:900});
 if(await page.evaluate(()=>document.documentElement.scrollWidth>innerWidth))throw Error('Mobile overflow');
 if(errors.length)throw Error(errors.join('\n'));
 console.log(JSON.stringify({checkedFrames:geometry.animations.reduce((n,a)=>n+a.frames.length,0),jabFrame2:check,stageMarkers:count,browserErrors:errors,passed:true}));
 await browser.close();
})().catch(e=>{console.error(e);process.exit(1)});
