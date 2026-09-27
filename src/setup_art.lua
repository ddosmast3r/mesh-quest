-- Close-up setup drawings. They are placeholders for the nine Aseprite shots.

setup_art={}

function setup_art.desk()
 cls(1)
 rectfill(0,91,127,127,4)
 line(0,91,127,91,15)
end

function setup_art.device(x,y,antenna,cable,lit)
 rectfill(x,y,x+28,y+39,0)
 rect(x,y,x+28,y+39,6)
 rectfill(x+5,y+6,x+23,y+25,1)
 rect(x+5,y+6,x+23,y+25,13)
 if antenna then
  line(x+23,y,x+31,y-25,6)
  line(x+31,y-25,x+34,y-27,13)
 else
  circ(x+23,y,2,8)
 end
 if cable then
  line(x,y+30,x-24,y+30,6)
  rectfill(x-29,y+27,x-24,y+33,5)
 end
 if lit and game.clock%30<22 then circfill(x+24,y+34,2,11) end
end

function setup_art.contents()
 setup_art.desk()
 rectfill(9,26,118,109,4)
 rect(9,26,118,109,10)
 setup_art.device(47,52,false,false,false)
 rectfill(17,48,30,54,5)
 line(30,51,48,74,6)
 line(86,48,108,75,6)
 line(87,52,112,80,6)
end

function setup_art.drawer(gamepad)
 cls(5)
 rectfill(8,18,120,112,4)
 rect(8,18,120,112,10)
 for i=0,4 do
  circ(25+i*18,45+(i%2)*20,9,13)
  line(18+i*18,48,33+i*18,70,6)
 end
 if gamepad then
  rectfill(39,52,89,83,1)
  circfill(42,68,15,1)
  circfill(86,68,15,1)
  rect(39,52,89,83,13)
  line(49,67,59,67,6)
  line(54,62,54,72,6)
  circfill(78,64,2,8)
  circfill(84,70,2,11)
  line(64,52,64,31,6)
  line(64,31,102,24,6)
 end
end

function setup_art.pc(step)
 setup_art.desk()
 rectfill(10,10,117,78,0)
 rect(10,10,117,78,6)
 rectfill(16,17,111,69,1)
 print(step<8 and "WINDOWS" or "WEB FLASHER",23,22,6)
 rectfill(23,35,103,58,0)
 rect(23,35,103,58,13)
 if step==7 then
  print("USB: UNKNOWN",29,42,8)
  print("INSTALL DRIVER",29,50,11)
 else
  print("LORA BOARD",29,40,11)
  rect(29,50,94,55,6)
  rectfill(30,51,30+mid(0,(game.clock%90),63),54,11)
 end
 setup_art.device(82,83,true,true,step>=8)
end

function setup_art.phone(found)
 cls(1)
 rectfill(38,7,90,120,0)
 rect(38,7,90,120,6)
 rectfill(43,15,85,109,1)
 print("MESHTASTIC",45,20,11)
 if found then
  rectfill(47,45,81,72,0)
  rect(47,45,81,72,11)
  print("NODE",56,51,7)
  print("-43 DBM",51,61,6)
 else
  for i=0,3 do circ(64,59,8+i*7,(game.clock/8+i)%4<1 and 11 or 3) end
 end
end
