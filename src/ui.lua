-- Drawing primitives shared by every screen.

ui={}

function ui.centered(text,y,text_color)
 print(text,64-#text*2,y,text_color)
end

-- Five packed row masks per glyph. Keeping the font in strings makes the
-- complete Russian alphabet cost a handful of code tokens instead of ~700.
ui.cyr_widths="333343343443443333333534335443343"
ui.cyr_rows="257557465665656744446::?9746477464796?696121699;=999;=956465755999??99557552555275555656443444372222552244>E>455255:::?15571155557EEEO1<465699=;=4465661316:===:35355"

function ui.cyr_character_width(character)
 if character==" " then
  return 3
 end
 local code=ord(character)
 local index=code>=97 and code<=122 and code-96 or
  code>=65 and code<=71 and code-38
 return index and tonum(sub(ui.cyr_widths,index,index)) or 3
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

function ui.cyr_glyph(character,x,y,text_color)
 -- Braces are compact escape codes for the two Latin letters used in dialogue.
 if character=="{" then
  print("p",x,y,text_color)
  return
 elseif character=="}" then
  print("t",x,y,text_color)
  return
 end
 local code=ord(character)
 local index=code>=97 and code<=122 and code-96 or
  code>=65 and code<=71 and code-38
 local width=index and tonum(sub(ui.cyr_widths,index,index))
 if width then
  for row=1,5 do
   local bits=ord(ui.cyr_rows,(index-1)*5+row)-48
   for column=1,width do
    if band(bits,2^(width-column))>0 then
     pset(x+column-1,y+row-1,text_color)
    end
   end
  end
  if character=="k" then
   pset(x+1,y-1,text_color)
   pset(x+2,y-1,text_color)
  elseif character=="g" then
   pset(x,y-1,text_color)
   pset(x+2,y-1,text_color)
  end
 elseif character~=" " and character~="|" then
  print(character,x,y,text_color)
 end
end

function ui.cyr_text(text,x,y,text_color)
 for index=1,#text do
  local character=sub(text,index,index)
  ui.cyr_glyph(character,x,y,text_color)
  x+=ui.cyr_character_width(character)+1
 end
end

function ui.cyr_fx(text,x,y,text_color,fx,time)
 for index=1,#text do
  local character=sub(text,index,index)
  local dx,dy,draw_color=0,0,text_color
  if fx=="glitch" and time%38<5 and (index+flr(time/5))%3==0 then
   ui.cyr_glyph(character,x-1,y,color.green)
   dx=index%2==0 and 2 or -2
   draw_color=color.lime
  end
  ui.cyr_glyph(character,x+dx,y+dy,draw_color)
  x+=ui.cyr_character_width(character)+1
 end
end

function ui.cyr_wrap(text,max_width)
 local lines={}
 local text_line=""
 local word=""

 for index=1,#text+1 do
  local character=index<=#text and sub(text,index,index) or " "

  if character==" " or character=="|" then
   if word~="" then
    local candidate=text_line=="" and word or text_line.." "..word
    if text_line~="" and ui.cyr_width(candidate)>max_width then
     add(lines,text_line)
     text_line=word
    else
     text_line=candidate
    end
    word=""
   end

   if character=="|" then
    add(lines,text_line)
    text_line=""
   end
  else
   word=word..character
  end
 end

 if text_line~="" then
  add(lines,text_line)
 end

 return lines
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
