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

story_art.friends_pic="f,0,0,127,75,0;l,63,7,63,70,3;f,8,10,55,66,10;f,11,13,52,63,0;f,12,48,51,52,10;o,20,34,3,10;f,17,38,23,48,10;o,32,34,3,10;f,29,38,35,48,10;o,44,34,3,10;f,41,38,47,48,10;r,75,22,115,50,3;f,79,26,111,46,0;f,83,30,107,42,11;l,95,50,95,57,3;l,84,58,106,58,3;o,77,48,4,3;f,72,52,82,68,3;c,105,12,7,3;l,105,12,105,8,10;l,105,12,109,14,10"

function story_art.friends()
 story_art.pic("friends_pic")
end

story_art.lonely_pic="f,0,0,127,75,0;l,0,57,127,57,3;l,0,73,127,73,3;p,7,33,3;p,26,26,3;p,45,19,3;p,64,12,3;p,83,33,3;p,102,26,3;p,121,19,3;o,25,29,5,3;f,20,34,31,61,3;l,21,58,15,72,3;l,30,58,38,72,3;r,59,12,116,58,3;f,63,16,112,54,0;r,69,22,105,31,3;l,73,27,91,27,3;r,77,38,108,47,3;l,81,43,96,43,3;l,86,58,86,65,3;l,72,66,101,66,3"

function story_art.lonely_room(time)
 story_art.pic("lonely_pic")
 if time%36<18 then
  rectfill(99,42,100,44,color.lime)
 end
end

story_art.monitor_pic="f,0,0,127,75,0;r,9,5,118,62,3;f,13,9,114,58,0;l,13,16,114,16,3;p,17,12,10;p,21,12,10;p,25,12,10;r,20,20,107,27,3;l,28,42,47,34,3;l,47,34,65,45,11;l,65,45,83,33,11;l,83,33,101,42,3;o,28,42,2,11;o,47,34,2,11;o,65,45,2,11;o,83,33,2,11;o,101,42,2,11;l,64,62,64,69,3;l,49,70,79,70,3"

function story_art.monitor(time)
 story_art.pic("monitor_pic")
 print("meshtastic",23,22,color.lime)
 pset(103,51+flr(time/20)%2,color.yellow)
end

story_art.order_pic="f,0,0,127,75,0;r,9,5,118,62,3;f,13,9,114,58,0;l,13,16,114,16,3;l,84,18,84,29,11;r,76,29,92,53,11;f,79,33,89,45,3;p,84,49,10;l,22,25,63,25,3;l,22,31,55,31,3;l,22,37,60,37,3;f,22,45,61,55,11;l,67,56,61,51,10;l,67,56,65,48,10;l,64,62,64,69,3;l,49,70,79,70,3"

function story_art.order(time)
 story_art.pic("order_pic")
 print("order",32,48,color.black)
 if time%30<6 then
  pset(62,49,color.yellow)
  pset(60,47,color.yellow)
  pset(64,47,color.yellow)
 end
end

story_art.waiting_pic="f,0,0,127,75,0;f,75,13,113,62,3;f,78,19,110,59,0;l,75,24,113,24,3;l,82,10,82,18,10;l,94,10,94,18,10;l,106,10,106,18,10"

function story_art.waiting(time)
 story_art.pic("waiting_pic")
 local daylight=flr(time/45)%2==0
 story_art.window(9,9,42,53,daylight and color.yellow or color.green)
 print("+"..(1+flr(time/45)%7),90,37,color.yellow)

 local page_y=65+flr((time%45)/15)
 line(83,page_y,106,page_y,color.green)
 line(86,page_y+2,103,page_y+2,color.green)
end

story_art.parcel_pic="f,0,0,127,75,0;l,0,70,127,70,3;r,7,39,48,69,10;l,7,39,20,28,10;l,20,28,48,39,10;l,48,39,37,28,10;l,37,28,7,39,10;l,27,39,27,69,10;l,62,13,62,29,3;r,54,29,70,65,3;f,57,33,67,50,0;r,78,19,121,58,3;f,82,23,117,54,0;r,91,31,108,47,11;l,77,62,122,62,3;l,70,58,75,67,10;l,75,67,93,62,10"

function story_art.parcel(time)
 story_art.pic("parcel_pic")
 pset(62,55,time%28<14 and color.lime or color.green)
 print("?",98,36,color.lime)
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
