-- Short terminal ending for refusing the call to action.

scenes.ending={}

function scenes.ending.enter()
 scenes.ending.time=0
 music(-1,600)
end

function scenes.ending.update()
 local scene=scenes.ending
 scene.time+=1
 if scene.time>30 and input.confirm_pressed() then
  game.has_save=false
  game.continue_scene=nil
  game.change_scene("menu")
 end
end

function scenes.ending.draw()
 local scene=scenes.ending
 cls(color.black)
 ui.cyr_centered("lpofx jdrC",57,color.yellow)
 if scene.time>30 and scene.time%60<45 then
  ui.cyr_centered("c nfoF",73,color.green)
 end
end
