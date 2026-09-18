-- Interactive 1:1 browser page drawn from the tiled Aseprite reference.

scenes.shop={}

local close_thoughts={
 "offft, G epmhfo Etp luqjtD.",
 "ialrCtD? j sopca bCtD bfi scGij?",
 "oft. soayama luqjtD."
}

local description_thoughts={
 "bma-bma-bma qrp pbAfojf... G iawptfm sqatD.",
 "raejp, yastptC, aotfooa... bfru.",
 "ojyfdp of qpoGm. cCdmGejt ouhoCn."
}

local function inside(x,y,area)
 return x>=area[1] and x<=area[3] and
  y>=area[2] and y<=area[4]
end

local function dismiss(scene)
 scene.message=nil
 scene.message_time=0
end

local function say_once(scene,key,text)
 dismiss(scene)
 if not scene[key] then
  scene[key]=true
  scene.message=text
  scene.message_time=240
 end
end

local function say_next(scene,key,thoughts)
 dismiss(scene)
 local index=(scene[key] or 0)+1
 if index<=#thoughts then
  scene[key]=index
  scene.message=thoughts[index]
  scene.message_time=240
 end
end

function scenes.shop.enter()
 local scene=scenes.shop
 poke(0x5f2d,1)
 scene.cursor_x=64
 scene.cursor_y=64
 scene.scroll_x=0
 scene.scroll_y=0
 scene.raw_x=stat(32)
 scene.raw_y=stat(33)
 scene.buttons=stat(34)
 scene.purchased=false
 scene.close_line=0
 scene.description_line=0
 scene.saw_address=false
 scene.message="cpt po, npk nfztastjl, oaep tpmDlp oahatD luqjtD."
 scene.message_time=300
end

function scenes.shop.update()
 local scene=scenes.shop
 local raw_x,raw_y=stat(32),stat(33)
 if raw_x!=scene.raw_x or raw_y!=scene.raw_y then
  scene.cursor_x=mid(0,raw_x,127)
  scene.cursor_y=mid(0,raw_y,127)
 end
 scene.raw_x,scene.raw_y=raw_x,raw_y

 if btn(0) then scene.cursor_x-=1 end
 if btn(1) then scene.cursor_x+=1 end
 if btn(2) then scene.cursor_y-=1 end
 if btn(3) then scene.cursor_y+=1 end
 scene.cursor_x=mid(0,scene.cursor_x,127)
 scene.cursor_y=mid(0,scene.cursor_y,127)

 -- Move the full-size page when the pointer reaches a screen edge.
 if scene.cursor_x<12 then scene.scroll_x-=1 end
 if scene.cursor_x>115 then scene.scroll_x+=1 end
 if scene.cursor_y<12 then scene.scroll_y-=1 end
 if scene.cursor_y>115 then scene.scroll_y+=1 end
 scene.scroll_x=mid(0,scene.scroll_x,shop_art.width-128)
 scene.scroll_y=mid(0,scene.scroll_y,shop_art.height-128)

 local buttons=stat(34)
 local clicked=(band(buttons,1)>0 and band(scene.buttons,1)==0) or btnp(4)
 scene.buttons=buttons
 if clicked then
  local page_x=scene.cursor_x+scene.scroll_x
  local page_y=scene.cursor_y+scene.scroll_y
  if inside(page_x,page_y,shop_art.buy) then
   if not scene.purchased then
    say_once(scene,"purchased","ialai pvprnmfo")
    audio.play(0)
   else
    dismiss(scene)
   end
  elseif inside(page_x,page_y,shop_art.close) then
   say_next(scene,"close_line",close_thoughts)
  elseif inside(page_x,page_y,shop_art.browser_address) then
   say_once(scene,"saw_address","dmacopf of ccpejtD aodmjksluF {... j }.")
  elseif inside(page_x,page_y,shop_art.description) then
   say_next(scene,"description_line",description_thoughts)
  else
   dismiss(scene)
  end
 end

 if scene.message_time>0 then scene.message_time-=1 end

 if btnp(5) then game.back_to_menu() end
end

function scenes.shop.draw()
 local scene=scenes.shop
 cls(color.black)
 camera(scene.scroll_x,scene.scroll_y)
 shop_art.draw()
 camera()

 if scene.message and scene.message_time>0 then
  local lines=ui.cyr_wrap(scene.message,104)
  local box_height=#lines*7+7
  local box_y=127-box_height
  rectfill(7,box_y,120,127,color.black)
  rect(7,box_y,120,127,color.lime)
  for index=1,#lines do
   ui.cyr_text(lines[index],12,box_y+4+(index-1)*7,color.yellow)
  end
 end

 spr(255,scene.cursor_x,scene.cursor_y)
end
