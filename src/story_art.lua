-- Procedural illustrations for the story slides.

story_art={}

function story_art.draw(art_id,time)
 story_art[art_id](time or 0)
end

-- Static primitives are cached from compact strings on their first frame.
function story_art.pic(name)
 local data=story_art[name]
 if type(data)=="string" then
  local parsed={}
  for command in all(split(data,";")) do
   add(parsed,split(command,","))
  end
  story_art[name]=parsed
  data=parsed
 end
 for p in all(data) do
  local op=p[1]
  local fn=op=="f" and rectfill or op=="r" and rect or
   op=="l" and line or op=="p" and pset or
   op=="c" and circ or circfill
  fn(unpack(p,2))
 end
end

function story_art.window(x,y,width,height,window_color)
 rectfill(x,y,x+width,y+height,window_color)
 rect(x-1,y-1,x+width+1,y+height+1,color.green)
 line(x+flr(width/2),y,x+flr(width/2),y+height,color.black)
 line(x,y+flr(height/2),x+width,y+flr(height/2),color.black)
end

function story_art.window_evening(time)
 sspr(0,16,60,72,34,2,60,72)

 -- Only a few pixels move; the imported reference itself stays intact.
 local sway=flr(sin(time/240)*2)
 pset(42+sway,17,color.brown)
 pset(43+sway,20,color.brown)
 pset(49+sway,11,color.orange)
 pset(50+sway,14,color.brown)

 local glint=sin(time/180)>0 and color.peach or color.yellow
 pset(45,15,glint)
 pset(53,27,glint)
end

function story_art.old_computer(time)
 if time%120<6 then
  pal(color.green,color.lime)
 end
 sspr(60,16,68,72,30,2,68,72)
 pal()
end

function story_art.decode64(byte)
 return byte>=48 and byte<=57 and byte-48 or
  byte>=65 and byte<=90 and byte-55 or
  byte>=97 and byte<=122 and byte-61 or
  byte==45 and 62 or 63
end

function story_art.placeholder(name)
 if story_art.cached~=name then
  story_art.cached=name
  memset(0,0,4608)
  local data=story_placeholder_data[name]
  local pixel=0
  for index=1,#data,2 do
   local value=story_art.decode64(ord(data,index))*64+
    story_art.decode64(ord(data,index+1))
   local length=value\16+1
   local draw_color=value%16
   if draw_color>0 then
    for offset=0,length-1 do
     local position=pixel+offset
     sset(position%128,position\128,draw_color)
    end
   end
   pixel+=length
  end
 end
 sspr(0,0,128,72,0,2)
end

function story_art.gamepad() story_art.placeholder("gamepad") end
function story_art.video() story_art.placeholder("video") end
function story_art.mesh() story_art.placeholder("mesh") end
function story_art.thinking() story_art.placeholder("thinking") end

function story_art.departure()
 -- slide_3 is packed into map memory; this is the final intro frame, so it
 -- can safely replace the upper half of the sprite sheet before drawing.
 memcpy(0,0x2000,4096)
 sspr(0,0,128,64,0,6)
end

function story_art.fade_mask(level)
 local covered=4-mid(0,level,4)
 if covered<=0 then
  return
 end

 for y=0,75 do
  if y%4<covered then
   line(0,y,127,y,color.black)
  end
 end
end
