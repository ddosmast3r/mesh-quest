-- Drawing primitives shared by every screen.

ui={}

function ui.centered(text,y,text_color)
 print(text,64-#text*2,y,text_color)
end

-- Compact 5x7 Cyrillic used for the three Russian menu labels.
-- ASCII keys keep the cartridge source compatible with PICO-8.
ui.cyr_glyphs={
 a={"01110","10001","10001","11111","10001","10001","10001"}, -- а
 c={"01111","10000","10000","10000","10000","10000","01111"}, -- с
 d={"01110","01010","01010","01010","01010","11111","10001"}, -- д
 e={"11111","10000","10000","11110","10000","10000","11111"}, -- е
 g={"11111","10000","10000","10000","10000","10000","10000"}, -- г
 i={"10001","10011","10101","10101","11001","10001","10001"}, -- и
 j={"10101","10101","01110","00100","01110","10101","10101"}, -- ж
 k={"10001","10010","10100","11000","10100","10010","10001"}, -- к
 l={"00111","01001","01001","01001","01001","10001","10001"}, -- л
 n={"10001","10001","10001","11111","10001","10001","10001"}, -- н
 o={"01110","10001","10001","10001","10001","10001","01110"}, -- о
 p={"11111","10001","10001","10001","10001","10001","10001"}, -- п
 q={"01111","10001","10001","01111","00101","01001","10001"}, -- я
 r={"11110","10001","10001","11110","10000","10000","10000"}, -- р
 s={"10000","10000","10000","11110","10001","10001","11110"}, -- ь
 t={"11111","00100","00100","00100","00100","00100","00100"}, -- т
 u={"10111","10101","10101","11101","10101","10101","10111"}, -- ю
 v={"11110","10001","10001","11110","10001","10001","11110"}, -- в
 y={"01010","00000","10001","10011","10101","11001","10001"}  -- й
}

function ui.cyr_width(text)
 return #text*6-1
end

function ui.cyr_centered(text,y,text_color)
 ui.cyr_text(text,64-flr(ui.cyr_width(text)/2),y,text_color)
end

function ui.cyr_text(text,x,y,text_color)
 for index=1,#text do
  local character=sub(text,index,index)
  local glyph=ui.cyr_glyphs[character]

  if glyph then
   for row=1,7 do
    for column=1,5 do
     if sub(glyph[row],column,column)=="1" then
      pset(x+column-1,y+row-1,text_color)
     end
    end
   end
  end

  x+=6
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
