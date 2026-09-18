-- Drawing primitives shared by every screen.

ui={}

function ui.centered(text,y,text_color)
 print(text,64-#text*2,y,text_color)
end

-- Variable-width 3-5 px Cyrillic, matched to PICO-8's compact font.
-- ASCII aliases keep the cartridge source compatible with PICO-8.
ui.cyr_glyphs={
 a={"010","101","111","101","101"}, -- а
 c={"011","100","100","100","011"}, -- с
 d={"0110","1010","1010","1111","1001"}, -- д
 e={"111","100","110","100","111"}, -- е
 g={"111","100","100","100","100"}, -- г
 i={"1001","1001","1011","1101","1001"}, -- и
 j={"1001","0110","1111","0110","1001"}, -- ж
 k={"101","110","100","110","101"}, -- к
 l={"0111","0101","0101","1001","1001"}, -- л
 m={"1001","1111","1111","1001","1001"}, -- м
 n={"101","101","111","101","101"}, -- н
 o={"010","101","101","101","010"}, -- о
 p={"111","101","101","101","101"}, -- п
 q={"011","101","011","101","101"}, -- я
 r={"110","101","110","100","100"}, -- р
 s={"100","100","110","101","110"}, -- ь
 t={"111","010","010","010","010"}, -- т
 u={"1010","1101","1101","1101","1010"}, -- ю
 v={"110","101","110","101","110"}, -- в
 w={"101","101","101","101","111"}, -- ш
 x={"1001","1001","1101","1011","1101"}, -- ы
 f={"101","101","010","010","100"}, -- у
 y={"1001","1001","1011","1101","1001"}  -- й
}

function ui.cyr_character_width(character)
 if character==" " then
  return 3
 end

 local glyph=ui.cyr_glyphs[character]
 return glyph and #glyph[1] or 3
end

function ui.cyr_width(text)
 local width=0

 for index=1,#text do
  width+=ui.cyr_character_width(sub(text,index,index))+1
 end

 return max(0,width-1)
end

function ui.cyr_centered(text,y,text_color)
 ui.cyr_text(text,64-flr(ui.cyr_width(text)/2),y,text_color)
end

function ui.cyr_text(text,x,y,text_color)
 for index=1,#text do
  local character=sub(text,index,index)
  local glyph=ui.cyr_glyphs[character]

  if glyph then
   for row=1,#glyph do
    for column=1,#glyph[row] do
     if sub(glyph[row],column,column)=="1" then
      pset(x+column-1,y+row-1,text_color)
     end
    end
   end

   -- A two-pixel breve distinguishes й from и without making it taller.
   if character=="y" then
    pset(x+1,y-1,text_color)
    pset(x+2,y-1,text_color)
   end
  end

  x+=ui.cyr_character_width(character)+1
 end
end

function ui.header(title,section,right_text)
 print(title,3,2,color.lime)

 if section then
  print("// "..section,7+#title*4,2,color.green)
 end

 if right_text then
  print(right_text,125-#right_text*4,2,color.green)
 end

 line(0,9,127,9,color.green)
end

function ui.panel(x1,y1,x2,y2)
 rectfill(x1,y1,x2,y2,color.black)
 rect(x1,y1,x2,y2,color.green)
end

function ui.draw_grid(y1,y2)
 for y=y1,y2,16 do
  for x=0,127,16 do
   pset(x,y,color.green)
  end
 end
end

function ui.draw_logo(x,y,reveal_width)
 -- The 120x16 title mark occupies the first two sprite rows.
 x=x or 4
 y=y or 56
 reveal_width=mid(0,reveal_width or 120,120)

 if reveal_width<=0 then
  return
 end

 clip(x,y,reveal_width,18)
 sspr(0,0,120,16,x,y,120,16)

 -- The reference uses one continuous underline with a broken tail.
 local line_width=min(reveal_width,101)
 if line_width>1 then
  line(x+1,y+15,x+line_width-1,y+15,color.lime)
 end
 if reveal_width>104 then pset(x+103,y+15,color.lime) end
 if reveal_width>107 then pset(x+106,y+15,color.lime) end
 clip()
end

function ui.draw_octagon(x,y,fill_color,border_color)
 for dy=-3,3 do
  local half_width=3
  if abs(dy)==3 then half_width=1 end
  line(x-half_width,y+dy,x+half_width,y+dy,fill_color)
 end
 ui.draw_octagon_outline(x,y,3,border_color)
end

function ui.draw_octagon_outline(x,y,radius,line_color)
 local cut=2
 line(x-radius+cut,y-radius,x+radius-cut,y-radius,line_color)
 line(x+radius-cut,y-radius,x+radius,y-radius+cut,line_color)
 line(x+radius,y-radius+cut,x+radius,y+radius-cut,line_color)
 line(x+radius,y+radius-cut,x+radius-cut,y+radius,line_color)
 line(x+radius-cut,y+radius,x-radius+cut,y+radius,line_color)
 line(x-radius+cut,y+radius,x-radius,y+radius-cut,line_color)
 line(x-radius,y+radius-cut,x-radius,y-radius+cut,line_color)
 line(x-radius,y-radius+cut,x-radius+cut,y-radius,line_color)
end

function ui.dashed_line(x1,y1,x2,y2,line_color)
 local steps=max(abs(x2-x1),abs(y2-y1))

 for step=0,steps do
  if flr(step/2)%2==0 then
   local amount=step/steps
   pset(
    x1+(x2-x1)*amount,
    y1+(y2-y1)*amount,
    line_color
   )
  end
 end
end

function ui.draw_packet_icon(x,y,time)
 local bob=flr(sin(time/24)*2)
 rect(x,y+bob,x+11,y+7+bob,color.green)
 line(x,y+bob,x+5,y+4+bob,color.lime)
 line(x+11,y+bob,x+6,y+4+bob,color.lime)
end

function ui.draw_radio_wave(x,y,radius)
 if (game.clock+radius)%32<20 then
  for angle=.57,.93,.04 do
   pset(
    x+cos(angle)*radius,
    y+sin(angle)*radius,
    color.green
   )
  end
 end
end
