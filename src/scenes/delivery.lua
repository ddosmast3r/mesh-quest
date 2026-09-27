scenes.delivery={
 lines={
  "yfrfi nfsGx",
  "tal, sfdpeoG epmhoC qrjcfitj...",
  "ytp qrjcfitj? G ytp-tp ialaiCcam?",
  "eiCoD!",
  "u ecfrj mfhama lprpbla.",
  "bfi lurDfra. qrpstp lprpbla.",
  "maeop. qpsnptrjn, ytp coutrj.",
  "nfztastjl. tpyop."
 }
}

function scenes.delivery.enter()
 local s=scenes.delivery
 s.phase=1
 s.day=1
 s.time=0
 s.ready=false
end

function scenes.delivery.update()
 local s=scenes.delivery
 s.time+=1
 if s.phase==1 and not s.ready then
  if s.time%4==0 then s.day+=1 end
  if s.day>=28 then
   s.day=28
   s.ready=true
  end
 elseif input.confirm_pressed() then
  if s.phase<#s.lines then
   s.phase+=1
   s.time=0
   if s.phase==4 then audio.play(2) end
  else
   game.open_setup()
  end
 end
 if btnp(5) and s.phase>1 then
  s.phase-=1
  s.time=0
 end
end

local function delivery_caption(text)
 local lines=ui.cyr_wrap(text,108)
 local y=123-#lines*7
 rectfill(5,y-4,122,127,0)
 rect(5,y-4,122,127,11)
 for i=1,#lines do
  ui.cyr_text(lines[i],10,y+(i-1)*7,10)
 end
end

function scenes.delivery.draw()
 local s=scenes.delivery
 if s.phase==1 then
  delivery_art.calendar(s.day)
 elseif s.phase<=3 then
  delivery_art.sofa()
 elseif s.phase<=6 then
  delivery_art.door(s.phase>=5)
 else
  delivery_art.box(s.phase==8)
 end
 delivery_caption(s.lines[s.phase])
 if s.phase==1 and not s.ready then
  ui.cyr_centered("qpephejtf...",116,6)
 else
  print("z",116,116,11)
 end
end
