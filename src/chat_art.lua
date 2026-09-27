chat_art={}

function chat_art.frame()
 cls(0)
 rectfill(0,0,127,10,1)
 print("MESHTASTIC / ALL",3,2,11)
 print("868.0",103,2,3)
 line(0,10,127,10,3)
 rectfill(91,11,127,127,1)
 line(90,11,90,127,3)
 print("NODES",97,16,11)
 local nodes={"R0UTER","LIS","MOTH","D3D","WX-3"}
 for i=1,#nodes do
  local active=not(nodes[i]=="WX-3") or scenes.public_chat.wx_online
  circfill(97,27+i*11,2,active and 11 or 8)
  print(nodes[i],102,24+i*11,active and 6 or 5)
 end
end

function chat_art.network(active)
 rectfill(4,16,86,78,1)
 rect(4,16,86,78,3)
 local nodes={{16,61,"HOME"},{44,50,"MOTH"},{72,25,"WX-3"},{68,66,"R0UTER"}}
 for i=1,#nodes do
  local n=nodes[i]
  if i>1 then
   local linked=i<3 or active
   line(nodes[i-1][1],nodes[i-1][2],n[1],n[2],linked and 11 or 5)
  end
  circfill(n[1],n[2],3,i==3 and (active and 11 or 8) or 3)
  print(n[3],n[1]-6,n[2]+5,6)
 end
 if active then
  for i=0,4 do
   local x=18+i*11
   pset(x,58-i*7,10)
  end
 end
end
