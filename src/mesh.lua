-- Mesh topology and packet animation.

mesh={}

function mesh.init()
 mesh.packets={}
 mesh.menu_route_links={}

 for index=1,#content.menu_links do
  if content.menu_links[index][3] then
   add(mesh.menu_route_links,index)
  end
 end
end

function mesh.update_menu()
 local frame_in_second=flr(t()%1*60)

 if frame_in_second%35==0 and #mesh.packets<2 then
  local route_index=mesh.menu_route_links[flr(rnd(#mesh.menu_route_links))+1]
  local link=content.menu_links[route_index]
  add(mesh.packets,{
   from=link[1],
   to=link[2],
   progress=0,
   reversed=rnd(1)<.5
  })
 end

 for packet in all(mesh.packets) do
  packet.progress+=.018
  if packet.progress>1 then
   del(mesh.packets,packet)
  end
 end
end

function mesh.draw_menu(time,y_offset)
 y_offset=y_offset or 0

 for link in all(content.menu_links) do
  local from=content.menu_nodes[link[1]]
  local to=content.menu_nodes[link[2]]
  local link_color=link[3] and color.lime or color.green

  if link[4] then
   ui.dashed_line(
    from[1],from[2]+y_offset,
    to[1],to[2]+y_offset,
    link_color
   )
  else
   line(from[1],from[2]+y_offset,to[1],to[2]+y_offset,link_color)
  end
 end

 for packet in all(mesh.packets) do
  local from=content.menu_nodes[packet.from]
  local to=content.menu_nodes[packet.to]

  if packet.reversed then
   from,to=to,from
  end

  local x=from[1]+(to[1]-from[1])*packet.progress
  local y=from[2]+(to[2]-from[2])*packet.progress+y_offset
  pset(x,y,color.lime)
  pset(x-1,y,color.green)
 end

 mesh.draw_mashuk(y_offset)

 for node in all(content.menu_nodes) do
  mesh.draw_menu_node(node,node[2]+y_offset)
 end

 mesh.draw_player_position(y_offset)
end

function mesh.draw_mashuk(y_offset)
 -- Leave a clean gap around the goal node: it doubles as the summit.
 line(94,36+y_offset,99,31+y_offset,color.green)
 line(111,31+y_offset,118,36+y_offset,color.green)
 line(97,33+y_offset,100,29+y_offset,color.lime)
 line(110,29+y_offset,114,33+y_offset,color.lime)
 ui.cyr_text("lcartam",3,12+y_offset,color.green)
 ui.cyr_text("nazvl",95,12+y_offset,color.lime)
end

function mesh.draw_player_position(y_offset)
 -- The source node is the player's home position in the Kvartal district.
 ui.cyr_text("cy",3,35+y_offset,color.lime)
 line(12,34+y_offset,13,32+y_offset,color.lime)
end

function mesh.draw_menu_node(node,y)
 local fill_color=color.black
 local border_color=color.green
 local text_color=color.green

 if node[4]=="online" then
  fill_color=color.lime
  border_color=color.lime
  text_color=color.black
 elseif node[4]=="weak" then
  fill_color=color.green
  text_color=color.lime
 end

 if node[5] then
  ui.draw_octagon_outline(node[1],y,5,color.lime)
 elseif node[6] then
  ui.draw_octagon_outline(node[1],y,5,color.green)
 end

 ui.draw_octagon(node[1],y,fill_color,border_color)
 print(node[3],node[1]-2,y-2,text_color)
end
