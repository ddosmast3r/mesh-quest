-- Node brief placeholder, following the reference card layout.

scenes.prologue={}

function scenes.prologue.update()
 if input.confirm_pressed() then
  game.show_notice("story module not installed")
  audio.play(3)
  game.change_scene("menu")
 end
end

function scenes.prologue.draw()
 cls(color.black)
 ui.header("node 04 / 06",nil,"d=22 from home")

 scenes.prologue.draw_device()
 scenes.prologue.draw_metrics()
 scenes.prologue.draw_objective()
 scenes.prologue.draw_links()
 scenes.prologue.draw_actions()
end

function scenes.prologue.draw_device()
 rect(4,14,35,45,color.green)

 for x=8,32,4 do
  line(x,15,x,44,color.green)
 end
 for y=18,42,4 do
  line(5,y,34,y,color.green)
 end

 rectfill(14,20,25,39,color.black)
 line(20,23,20,37,color.lime)
 line(16,37,20,23,color.green)
 line(24,37,20,23,color.green)
 line(16,31,24,31,color.lime)

 print("tower",41,15,color.lime)

 rectfill(41,25,64,33,color.lime)
 print("router",42,27,color.black)

 rect(68,25,91,33,color.green)
 print("solar",69,27,color.green)
end

function scenes.prologue.draw_metrics()
 print("bat",41,37,color.green)
 rect(56,37,91,43,color.green)
 rectfill(57,38,86,42,color.lime)
 print("88%",96,38,color.lime)

 print("snr",41,46,color.green)
 rect(56,46,91,52,color.green)
 rectfill(57,47,87,51,color.lime)
 print("-5db",96,47,color.lime)
end

function scenes.prologue.draw_objective()
 rect(4,57,123,82,color.green)
 print("objective",8,61,color.green)
 print("keep tower online.",8,70,color.lime)
 print("shortest path depends on it.",8,76,color.lime)
end

function scenes.prologue.draw_links()
 print("links",4,87,color.green)
 print("ridge",4,95,color.lime)
 print("1 km",108,95,color.lime)
 print("city",4,103,color.lime)
 print("2 km",108,103,color.lime)
end

function scenes.prologue.draw_actions()
 rectfill(0,114,67,127,color.lime)
 print("z  start run",10,118,color.black)

 rect(70,114,127,127,color.green)
 print("x  back",84,118,color.green)
end
