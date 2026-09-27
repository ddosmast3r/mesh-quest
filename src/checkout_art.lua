-- Generated from slide_6.png. Edit the PNG, not this file.

checkout_art={width=192,height=128,map_width=24,map_height=16}
checkout_art.overflows={}

for record in all(split("14,13,0,0,1,2;15,13,0,0,3,4;16,13,0,0,5,6;17,13,0,0,7,7;18,13,8,7,7,7;20,13,9,10,11,12;21,13,13,10,14,15;22,13,15,7,7,7;0,14,16,7,17,18;8,14,7,19,18,20;11,14,21,22,18,18;12,14,23,24,18,18;13,14,25,23,18,18;14,14,26,27,18,18;15,14,28,23,18,18;16,14,23,29,18,18;19,14,7,30,18,31;23,14,7,32,18,33;0,15,34,35,36,37;1,15,38,39,40,41;2,15,42,43,44,45;3,15,46,47,48,49;4,15,38,50,51,52;20,15,53,54,55,51;21,15,56,57,58,57;22,15,59,60,61,62;23,15,63,57,64,65",";")) do
 add(checkout_art.overflows,split(record,","))
end

function checkout_art.draw()
 map(0,0,0,0,checkout_art.map_width,checkout_art.map_height)
 for record in all(checkout_art.overflows) do
  for part=0,3 do
   local small_id=record[part+3]
   local sprite_id=221+small_id\4
   sspr(
    sprite_id%16*8+small_id%2*4,
    sprite_id\16*8+(small_id\2)%2*4,
    4,4,
    record[1]*8+part%2*4,
    record[2]*8+part\2*4
   )
  end
 end
end
