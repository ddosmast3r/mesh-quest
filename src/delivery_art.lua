-- Procedural placeholders. Their composition matches the future Aseprite shots.

delivery_art={}

function delivery_art.room()
 cls(1)
 rectfill(0,83,127,127,5)
 line(0,83,127,83,13)
 rectfill(83,12,119,66,0)
 rect(83,12,119,66,6)
 line(101,12,101,66,6)
 line(83,39,119,39,6)
 for i=0,9 do
  pset(88+rnd(27),18+rnd(41),i%3==0 and 6 or 1)
 end
end

function delivery_art.calendar(day)
 cls(0)
 rectfill(30,17,98,108,7)
 rectfill(30,17,98,33,8)
 rect(30,17,98,108,6)
 for x=39,89,10 do circfill(x,17,2,5) end
 print("SEP",57,23,7)
 local n=1
 for y=43,91,10 do
  for x=38,88,9 do
   if n<=30 then
    if n==day then rectfill(x-2,y-2,x+7,y+6,8) end
    print(n,x,y,n==day and 7 or 5)
    n+=1
   end
  end
 end
end

function delivery_art.sofa()
 delivery_art.room()
 rectfill(12,66,77,101,2)
 rect(12,66,77,101,13)
 rectfill(17,75,72,94,1)
 -- Cropped, faceless figure with a very small breathing motion.
 local breath=flr(game.clock/30)%2
 circfill(48,63+breath,9,5)
 rectfill(38,70+breath,59,94,1)
 line(38,78,27,91,5)
 line(59,78,70,94,5)
end

function delivery_art.door(has_box)
 cls(1)
 rectfill(0,92,127,127,5)
 rectfill(29,8,98,104,4)
 rect(29,8,98,104,15)
 rectfill(34,14,93,99,2)
 circfill(86,58,2,10)
 if has_box then
  rectfill(49,83,88,108,4)
  rect(49,83,88,108,10)
  line(49,83,68,95,10)
  line(88,83,68,95,10)
 end
end

function delivery_art.box(opened)
 cls(5)
 rectfill(0,76,127,127,4)
 if opened then
  -- Open lid and recognisable radio parts.
  rectfill(23,16,104,45,4)
  rect(23,16,104,45,10)
  line(23,45,12,64,10)
  line(104,45,115,64,10)
  rectfill(19,61,108,112,4)
  rect(19,61,108,112,10)
  rectfill(36,70,69,99,1)
  rect(36,70,69,99,6)
  rectfill(42,75,63,91,0)
  line(69,73,88,60,6)
  rectfill(78,82,96,88,5)
  line(78,85,62,85,6)
 else
  rectfill(22,39,106,105,4)
  rect(22,39,106,105,10)
  line(64,39,64,105,10)
  rectfill(59,39,68,105,15)
  line(22,59,106,59,10)
 end
end
