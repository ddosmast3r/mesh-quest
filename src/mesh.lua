-- Mesh topology and packet animation.

mesh={}

function mesh.init()
 mesh.packets={}
 mesh.route_links={}
 mesh.menu_route_links={}

 for index=1,#content.links do
  if content.links[index].route then
   add(mesh.route_links,index)
  end
 end

 for index=1,#content.menu_links do
  if content.menu_links[index].route then
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
   from=link.from,
   to=link.to,
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
  local from=content.menu_nodes[link.from]
  local to=content.menu_nodes[link.to]
  local link_color=link.route and color.lime or color.green

  if link.weak then
   ui.dashed_line(
    from.x,from.y+y_offset,
    to.x,to.y+y_offset,
    link_color
   )
  else
   line(from.x,from.y+y_offset,to.x,to.y+y_offset,link_color)
  end
 end

 for packet in all(mesh.packets) do
  local from=content.menu_nodes[packet.from]
  local to=content.menu_nodes[packet.to]

  if packet.reversed then
   from,to=to,from
  end

  local x=from.x+(to.x-from.x)*packet.progress
  local y=from.y+(to.y-from.y)*packet.progress+y_offset
  pset(x,y,color.lime)
  pset(x-1,y,color.green)
 end

 mesh.draw_mashuk(y_offset)

 for node in all(content.menu_nodes) do
  mesh.draw_menu_node(node,node.y+y_offset)
 end

 mesh.draw_player_position(y_offset)
end

function mesh.draw_mashuk(y_offset)
 -- Leave a clean gap around the goal node: it doubles as the summit.
 line(94,36+y_offset,99,31+y_offset,color.green)
 line(111,31+y_offset,118,36+y_offset,color.green)
 line(97,33+y_offset,100,29+y_offset,color.lime)
 line(110,29+y_offset,114,33+y_offset,color.lime)
 ui.cyr_text("kvartal",3,12+y_offset,color.green)
 ui.cyr_text("mawfk",95,12+y_offset,color.lime)
end

function mesh.draw_player_position(y_offset)
 -- The source node is the player's home position in the Kvartal district.
 ui.cyr_text("vx",3,35+y_offset,color.lime)
 line(12,34+y_offset,13,32+y_offset,color.lime)
end

function mesh.draw_menu_node(node,y)
 local fill_color=color.black
 local border_color=color.green
 local text_color=color.green

 if node.status=="online" then
  fill_color=color.lime
  border_color=color.lime
  text_color=color.black
 elseif node.status=="weak" then
  fill_color=color.green
  text_color=color.lime
 end

 if node.source then
  ui.draw_octagon_outline(node.x,y,5,color.lime)
 elseif node.goal then
  ui.draw_octagon_outline(node.x,y,5,color.green)
 end

 ui.draw_octagon(node.x,y,fill_color,border_color)
 print(node.label,node.x-2,y-2,text_color)
end

function mesh.update()
 local frame_in_second=flr(t()%1*60)

 if frame_in_second%35==0 and #mesh.packets<3 then
  local route_index=mesh.route_links[flr(rnd(#mesh.route_links))+1]
  local link=content.links[route_index]

  add(mesh.packets,{
   from=link.from,
   to=link.to,
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

function mesh.draw()
 if game.settings.grid then
  ui.draw_grid(10,90)
 end

 for link in all(content.links) do
  mesh.draw_link(link)
 end

 for packet in all(mesh.packets) do
  mesh.draw_packet(packet)
 end

 for cost in all(content.cost_labels) do
  local cost_color=cost[4] and color.lime or color.green
  local label_x=cost[1]-#cost[3]*2
  rectfill(label_x-1,cost[2]-1,label_x+#cost[3]*4,cost[2]+5,color.black)
  print(cost[3],label_x,cost[2],cost_color)
 end

 for node in all(content.nodes) do
  mesh.draw_node(node)
 end

 print("you",6,61,color.green)
 print("goal",106,71,color.lime)

 rectfill(73,77,123,92,color.black)
 print("km per link",75,79,color.green)
 print("bright=best",75,86,color.green)
end

function mesh.draw_link(link)
 local from=content.nodes[link.from]
 local to=content.nodes[link.to]
 local link_color=link.route and color.lime or color.green

 if link.weak then
  ui.dashed_line(from.x,from.y,to.x,to.y,link_color)
 else
  line(from.x,from.y,to.x,to.y,link_color)
 end
end

function mesh.draw_packet(packet)
 local from=content.nodes[packet.from]
 local to=content.nodes[packet.to]

 if packet.reversed then
  from,to=to,from
 end

 local x=from.x+(to.x-from.x)*packet.progress
 local y=from.y+(to.y-from.y)*packet.progress
 pset(x,y,color.lime)
end

function mesh.draw_node(node)
 local fill_color=color.black
 local border_color=color.green
 local text_color=color.green

 if node.status=="online" then
  fill_color=color.lime
  border_color=color.lime
  text_color=color.black
 elseif node.status=="weak" then
  fill_color=color.green
  text_color=color.lime
 end

 if node.id=="a" then
  ui.draw_octagon_outline(node.x,node.y,5,color.lime)
 elseif node.goal then
  ui.draw_octagon_outline(node.x,node.y,5,color.green)
 end

 ui.draw_octagon(node.x,node.y,fill_color,border_color)
 print(node.label,node.x-2,node.y-2,text_color)

 local distance="d"..node.dist
 local distance_color=node.route and color.lime or color.green
 rectfill(node.dx-1,node.dy-1,node.dx+#distance*4,node.dy+5,color.black)
 print(distance,node.dx,node.dy,distance_color)
end
