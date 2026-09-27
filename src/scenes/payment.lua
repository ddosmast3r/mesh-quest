-- Failed payment, then an explicit switch to the credit card.

scenes.payment={
 phrases={
  "cpt hf... efofd oa lartf of wcataft.",
  "maeop, oaep tpdea pqmatjtD s lrfejtlj."
 },
 methods={"qpctprjtD","erudpk sqpspb"},
 cards={".... 4451  0 r.",".... 2048  credit"}
}

function scenes.payment.enter()
 local scene=scenes.payment
 scene.phrase=1
 scene.visible=0
 scene.time=0
 scene.mode="text"
 scene.choice=1
end

function scenes.payment.update()
 local scene=scenes.payment
 scene.time+=1
 local text=scene.phrases[scene.phrase]

 if scene.mode=="method" then
  if btnp(2) or btnp(3) then scene.choice=3-scene.choice end
  if btnp(4) then
   if scene.choice==1 then
    scene.mode="failed"
    scene.time=0
   else
    scene.mode="card"
    scene.choice=1
   end
  end
 elseif scene.mode=="card" then
  if btnp(2) or btnp(3) then scene.choice=3-scene.choice end
  if btnp(4) and scene.choice==2 then
   scene.mode="success"
   scene.time=0
   audio.play(2)
  end
 elseif scene.mode=="failed" then
  if scene.time>45 or btnp(4) then scene.mode="method" end
 elseif scene.mode=="success" then
  if scene.time>75 or btnp(4) then game.open_delivery() end
 elseif input.confirm_pressed() then
  if scene.visible<#text then
   scene.visible=#text
  elseif scene.phrase<#scene.phrases then
   scene.phrase+=1
   scene.visible=0
  else
   scene.mode="method"
   scene.choice=1
  end
 elseif scene.time>30 and scene.time%2==0 and scene.visible<#text then
  scene.visible+=1
 end
end

function scenes.payment.draw()
 local scene=scenes.payment
 cls(color.black)
 camera(32,0)
 checkout_art.draw()
 camera()

 if scene.mode!="text" then
  rectfill(8,72,120,123,color.black)
  rect(8,72,120,123,color.lime)
  if scene.mode=="method" then
   ui.cyr_text("ofepstatpyop srfestc",13,77,color.orange)
   for i=1,2 do
    local c=i==scene.choice and color.yellow or color.green
    ui.cyr_text((i==scene.choice and "> " or "  ")..scene.methods[i],13,91+(i-1)*12,c)
   end
  elseif scene.mode=="card" then
   ui.cyr_text("cCbfrjtf sqpspb",13,77,color.green)
   for i=1,2 do
    local c=i==scene.choice and color.yellow or color.green
    print((i==scene.choice and "> " or "  ")..scene.cards[i],13,91+(i-1)*12,c)
   end
  elseif scene.mode=="failed" then
   ui.cyr_centered("ofepstatpyop srfestc",88,color.orange)
   ui.cyr_centered("qpqrpbuktf erudpk sqpspb",101,color.green)
  else
   ui.cyr_centered("pqmata qrpzma",87,color.lime)
   ui.cyr_centered("ialai pvprnmfo",100,color.yellow)
  end
  return
 end

 local text=sub(scene.phrases[scene.phrase],1,scene.visible)
 local lines=ui.cyr_wrap(text,108)
 local box_height=max(21,#lines*7+7)
 local box_y=128-box_height
 rectfill(5,box_y,122,127,color.black)
 rect(5,box_y,122,127,color.lime)
 for index=1,#lines do
  ui.cyr_text(lines[index],10,box_y+4+(index-1)*7,color.yellow)
 end
end
