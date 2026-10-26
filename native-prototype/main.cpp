#define NOMINMAX
#include <windows.h>
#include <gdiplus.h>
#include <string>
#include <memory>
#include <fstream>
#include <cstdio>
#include "simulation.h"
using namespace Gdiplus;
ssf::Game game;
std::unique_ptr<Bitmap> atlas;
bool debugBoxes=false,paused=false,keys[256]={},jumpPressed=false,attackPressed=false;
int clientW=960,clientH=544;
float zoom=1.5f;
PointF screen(float x,float y){return PointF(480+x*zoom,140+y*zoom);}
void text(Graphics&g,const std::wstring&s,float x,float y,float size,Color color){
 FontFamily family(L"Segoe UI");Font font(&family,size,FontStyleRegular,UnitPixel);SolidBrush b(color);g.DrawString(s.c_str(),-1,&font,PointF(x,y),&b);
}
void drawFighter(Graphics&g,const ssf::Fighter&f,Color marker,const wchar_t*label){
 int index=f.sprite();PointF p=screen(f.x,f.y);
 PointF dest[3]={PointF(p.X-f.facing*96*zoom,p.Y-128*zoom),PointF(p.X+f.facing*96*zoom,p.Y-128*zoom),PointF(p.X-f.facing*96*zoom,p.Y+64*zoom)};
 ImageAttributes attr;attr.SetWrapMode(WrapModeTileFlipXY);
 g.DrawImage(atlas.get(),dest,3,(index%16)*192,(index/16)*192,192,192,UnitPixel,&attr);
 SolidBrush m(marker);g.FillEllipse(&m,p.X-3,p.Y+4,6.f,6.f);text(g,label,p.X-20,p.Y-90,12,marker);
 if(debugBoxes){auto frame=FRAMES[index];for(int i=0;i<frame.count;i++){
  Box b=ssf::worldBox(BOXES[frame.offset+i],f);auto q=screen(b.x,b.y);Pen pen(b.attack?Color(255,255,100,120):Color(255,110,180,255),1);
  g.DrawRectangle(&pen,q.X,q.Y,b.w*zoom,b.h*zoom);
 }}
}
void render(Graphics&g){
 g.Clear(Color(255,13,19,30));g.SetSmoothingMode(SmoothingModeNone);g.SetInterpolationMode(InterpolationModeNearestNeighbor);g.SetPixelOffsetMode(PixelOffsetModeHalf);
 Pen grid(Color(255,22,34,49),1);for(int x=0;x<960;x+=32)g.DrawLine(&grid,x,80,x,470);for(int y=80;y<470;y+=32)g.DrawLine(&grid,0,y,960,y);
 constexpr int count=sizeof(TERRAIN)/sizeof(TERRAIN[0]);PointF points[count];for(int i=0;i<count;i++)points[i]=screen(TERRAIN[i].x,TERRAIN[i].y);
 SolidBrush platform(Color(255,44,62,83));Pen edge(Color(255,105,204,185),2);g.FillPolygon(&platform,points,count);g.DrawPolygon(&edge,points,count);
 drawFighter(g,game.dummy,Color(255,255,190,120),L"TARGET");drawFighter(g,game.player,Color(255,125,224,199),L"P1");
 SolidBrush top(Color(255,18,27,41));g.FillRectangle(&top,0,0,960,76);g.FillRectangle(&top,0,472,960,72);
 text(g,L"SSF2 / Jab combo test",22,12,23,Color(255,231,240,250));
 text(g,L"Mario + Final Destination   |   30 Hz simulation   |   Windows prototype",23,44,13,Color(255,154,176,199));
 wchar_t stats[220];swprintf(stats,220,L"Target %.0f%%    Hits %d    KOs %d / %d    %ls",game.dummy.damage,game.hits,game.player.kos,game.dummy.kos,paused?L"PAUSED":L"");
 text(g,stats,23,480,18,Color(255,225,237,245));
 text(g,L"A/D: move   Space: jump   Tap J again: combo   R: reset   B: boxes   P: pause   N: step",23,513,13,Color(255,157,180,202));
 if(debugBoxes){wchar_t detail[160];swprintf(detail,160,L"x %.1f  y %.1f  vy %.2f   anim %d:%d   tick %d",game.player.x,game.player.y,game.player.vy,game.player.anim,game.player.frame+1,game.ticks);text(g,detail,23,80,12,Color(255,180,205,225));}
}
ssf::Input input(){ssf::Input in;in.axis=(keys['D']||keys[VK_RIGHT])-(keys['A']||keys[VK_LEFT]);in.jump=jumpPressed;in.jumpHeld=keys[VK_SPACE];in.attack=attackPressed;in.fastFall=keys['S']||keys[VK_DOWN];jumpPressed=attackPressed=false;return in;}
LRESULT CALLBACK windowProc(HWND hwnd,UINT msg,WPARAM w,LPARAM l){
 switch(msg){
 case WM_KEYDOWN:
  if(w<256&&!keys[w]){if(w==VK_SPACE)jumpPressed=true;if(w=='J')attackPressed=true;if(w=='R')game.reset();if(w=='B')debugBoxes=!debugBoxes;if(w=='P')paused=!paused;if(w=='N'&&paused)game.tick(input());if(w==VK_ESCAPE)DestroyWindow(hwnd);}if(w<256)keys[w]=true;return 0;
 case WM_KEYUP:if(w<256)keys[w]=false;return 0;
 case WM_KILLFOCUS:for(bool&k:keys)k=false;jumpPressed=attackPressed=false;paused=true;return 0;
 case WM_SIZE:clientW=LOWORD(l);clientH=HIWORD(l);return 0;
 case WM_ERASEBKGND:return 1;
 case WM_PAINT:{PAINTSTRUCT ps;HDC dc=BeginPaint(hwnd,&ps);Bitmap back(960,544,PixelFormat32bppARGB);Graphics bg(&back);render(bg);Graphics g(dc);g.Clear(Color(255,9,12,18));float scale=std::min(clientW/960.f,clientH/544.f);g.DrawImage(&back,RectF((clientW-960*scale)/2,(clientH-544*scale)/2,960*scale,544*scale));EndPaint(hwnd,&ps);return 0;}
 case WM_DESTROY:PostQuitMessage(0);return 0;
 }return DefWindowProcW(hwnd,msg,w,l);
}
int selfTest(){
 std::ofstream report("test-results.txt");int failures=0;
 auto check=[&](bool good,const char*name){report<<(good?"PASS ":"FAIL ")<<name<<'\n';if(!good)failures++;};
 ssf::Game g;
 for(int i=0;i<300;i++)g.tick();check(std::abs(g.player.y-GROUND)<.1f,"Idle stays grounded for 300 ticks");
 g.reset();for(int i=0;i<20;i++)g.tick({1});check(g.player.x>20&&g.player.x<50,"Walk accelerates toward source speed 4");
 g.reset();g.tick({0,true,true});float minY=g.player.y;for(int i=0;i<70;i++){g.tick({0,false,true});minY=std::min(minY,g.player.y);}check(minY<GROUND-85&&g.player.grounded,"Full jump rises and lands");
 g.reset();g.tick({0,true,true});for(int i=0;i<6;i++)g.tick({0,false,true});g.tick({0,true,true});check(g.player.airJumps==0&&g.player.vy<-15,"One midair jump");
 g.reset();g.player.x=RIGHT-3;for(int i=0;i<160;i++)g.tick({1});check(g.player.kos>0,"Walk off stage crosses KO bounds and respawns");
 g.reset();g.player.x=-10;g.dummy.x=20;g.tick({0,false,false,true});for(int i=0;i<30;i++)g.tick();check(g.hits==1&&g.dummy.damage==3,"One jab hits once across active frames");check(std::abs(g.lastKnockback-33.4f)<.01f,"Source weight-based jab knockback formula");
 g.reset();g.tick({0,false,false,true});for(int i=0;i<25;i++)g.tick();check(g.hits==0,"Out-of-range jab misses");
 g.reset();g.player.x=10;g.player.facing=-1;g.dummy.x=-20;g.dummy.facing=1;g.tick({0,false,false,true});for(int i=0;i<25;i++)g.tick();check(g.hits==1,"Mirrored attack hits on left side");
 g.reset();g.player.x=LEFT-80;g.player.y=GROUND-10;g.player.vx=0;g.player.vy=13;g.player.grounded=false;for(int i=0;i<10;i++)g.tick();check(g.player.y>GROUND+50,"No invisible floor beyond platform");
 ssf::Game a,b;for(int i=0;i<100;i++){ssf::Input in;in.axis=i<15?1:0;in.jump=i==20;in.jumpHeld=i<30;a.tick(in);b.tick(in);}check(a.player.x==b.player.x&&a.player.y==b.player.y,"Deterministic fixed-step replay");
 g.reset();g.tick({0,true,true});float shortY=GROUND;for(int i=0;i<60;i++){g.tick();shortY=std::min(shortY,g.player.y);}check(shortY>minY+40,"Releasing during startup gives a shorter hop");
 g.reset();g.player.x=0;g.player.y=GROUND-150;g.player.vy=100;g.player.grounded=false;for(int i=0;i<20;i++)g.tick();check(g.player.grounded&&std::abs(g.player.y-GROUND)<.1f,"Falling motion does not tunnel through stage");
 // End-to-end combo: natural target movement, no repositioning between hits.
 for(int facing:{1,-1}){
  g.reset();g.player.x=-10.f*facing;g.player.facing=facing;g.dummy.x=20.f*facing;g.dummy.facing=-facing;
  g.tick({0,false,false,true});bool second=false,third=false;
  for(int i=0;i<150;i++){
   ssf::Input in;
   if(g.player.anim==ssf::Jab&&g.player.jabPhase==1&&g.player.frame>=4&&!second){in.attack=true;second=true;}
   if(g.player.anim==ssf::Jab&&g.player.jabPhase==2&&g.player.frame>=13&&!third){in.attack=true;third=true;}
   g.tick(in);
  }
  check(second&&third&&g.hits==3&&g.dummy.damage==10,"Full 3+2+5 jab combo connects once per phase, both facings");
  check(std::abs(g.lastKnockback-62.9f)<.01f,"Finisher uses accumulated damage in knockback formula");
  check(g.dummy.grounded&&!g.dummy.injured&&g.dummy.anim==ssf::Idle,"Target finishes hurt reaction and recovers to idle");
 }
 g.reset();g.player.x=-10;g.dummy.x=20;g.tick({0,false,false,true});
 for(int i=0;i<50;i++)g.tick();check(g.player.attackSerial==1&&g.hits==1,"No automatic combo without a new press");
 g.reset();g.startJab(g.player,2);check(g.player.frame==8,"Jab 2 enters source frame 9");
 for(int i=0;i<3;i++)g.tick();check(g.player.frame==11,"Jab 2 reaches active source frame 12 after three ticks");
 g.reset();g.startJab(g.player,3);float before=g.player.x;g.tick();g.tick();check(g.player.frame==20&&g.player.x>before+6,"Jab 3 moves forward on source frame 21");
 g.reset();g.startJab(g.player,1);for(int i=0;i<7;i++)g.tick();g.tick({0,false,false,true});check(g.player.jabPhase==2,"Fresh press during continuation window starts jab 2");
 g.reset();g.startJab(g.player,1);for(int i=0;i<25;i++)g.tick();g.tick({0,false,false,true});check(g.player.jabPhase==1,"Expired continuation window restarts jab 1");
 g.reset();g.player.x=-10;g.dummy.x=20;g.tick({0,false,false,true});g.tick();
 int frozenFrame=g.dummy.frame;float frozenX=g.dummy.x;g.tick();check(g.dummy.frame==frozenFrame&&g.dummy.x==frozenX,"Hitlag freezes target position and reaction frame");
 for(int i=0;i<7;i++)g.tick();check(g.dummy.anim==ssf::Hurt&&g.dummy.injured,"Launched target keeps hurt animation rather than jump pose");
 for(int i=0;i<80;i++)g.tick();check(g.dummy.anim==ssf::Idle&&!g.dummy.injured,"Hurt recovery releases the target");
 g.reset();g.startJab(g.player,3);g.player.x=RIGHT-13;for(int i=0;i<15;i++)g.tick();check(g.player.x<=RIGHT-12&&g.player.grounded,"Finisher forward step respects platform edge");
 report<<"Full-jump rise (prototype pixels): "<<GROUND-minY<<'\n'<<"Short-hop rise (prototype pixels): "<<GROUND-shortY<<'\n';
 report<<"Failures: "<<failures<<'\n';return failures?1:0;
}
int main(int argc,char**argv){
 wchar_t exe[MAX_PATH];GetModuleFileNameW(nullptr,exe,MAX_PATH);std::wstring folder=exe;folder=folder.substr(0,folder.find_last_of(L"\\/"));SetCurrentDirectoryW(folder.c_str());
 if(argc>1&&std::string(argv[1])=="--test")return selfTest();
 GdiplusStartupInput startup;ULONG_PTR token;GdiplusStartup(&token,&startup,nullptr);
 atlas=std::make_unique<Bitmap>(L"assets\\mario-atlas.png");
 if(atlas->GetLastStatus()!=Ok){MessageBoxW(nullptr,L"Missing assets\\mario-atlas.png. Keep the assets folder beside the executable.",L"SSF2 prototype",MB_ICONERROR);return 2;}
 if(argc>1&&std::string(argv[1])=="--capture"){
  game.player.x=-10;game.dummy.x=20;game.tick({0,false,false,true});game.tick();debugBoxes=true;
  {Bitmap img(960,544,PixelFormat32bppARGB);{Graphics g(&img);render(g);}CLSID encoder;CLSIDFromString(L"{557cf406-1a04-11d3-9a73-0000f81ef32e}",&encoder);if(img.Save(L"native-preview.png",&encoder,nullptr)!=Ok)return 3;}atlas.reset();GdiplusShutdown(token);return 0;
 }
 HINSTANCE instance=GetModuleHandleW(nullptr);WNDCLASSW wc{};wc.lpfnWndProc=windowProc;wc.hInstance=instance;wc.lpszClassName=L"SSF2Prototype";wc.hCursor=LoadCursor(nullptr,IDC_ARROW);RegisterClassW(&wc);
 RECT rect{0,0,960,544};AdjustWindowRect(&rect,WS_OVERLAPPEDWINDOW,FALSE);
 bool smoke=argc>1&&std::string(argv[1])=="--smoke";
 HWND hwnd=CreateWindowW(wc.lpszClassName,L"SSF2 - Native Prototype",WS_OVERLAPPEDWINDOW|(smoke?0:WS_VISIBLE),CW_USEDEFAULT,CW_USEDEFAULT,rect.right-rect.left,rect.bottom-rect.top,nullptr,nullptr,instance,nullptr);
 if(!hwnd){atlas.reset();GdiplusShutdown(token);return 4;}
 LARGE_INTEGER frequency,last,now;QueryPerformanceFrequency(&frequency);QueryPerformanceCounter(&last);double accumulator=0;MSG msg{};
 bool running=true;while(running){while(PeekMessageW(&msg,nullptr,0,0,PM_REMOVE)){if(msg.message==WM_QUIT){running=false;break;}TranslateMessage(&msg);DispatchMessageW(&msg);}if(!running)break;
  QueryPerformanceCounter(&now);accumulator+=std::min(.15,double(now.QuadPart-last.QuadPart)/frequency.QuadPart);last=now;
  if(paused)accumulator=0;
  while(accumulator>=1.0/30){game.tick(input());accumulator-=1.0/30;}
  InvalidateRect(hwnd,nullptr,FALSE);UpdateWindow(hwnd);if(smoke&&game.ticks>=30)DestroyWindow(hwnd);Sleep(8);
 }
 atlas.reset();GdiplusShutdown(token);return 0;
}
