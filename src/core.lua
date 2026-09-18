-- Application state, input helpers, and scene routing.

game={}
input={}
audio={}

function game.init()
 srand(1337)
 local parameter=stat(6) or ""
 local returning=sub(parameter,1,4)=="menu"

 game.scene_name=nil
 game.clock=0
 game.has_save=returning
 game.continue_scene=returning and "game" or nil
 game.story_id="intro"
 game.story_slide=1
 game.setup_progress=1
 game.menu_selection=1
 game.setting_selection=1
 game.settings={
  sound=parameter~="menu_mute",
  grid=true
 }

 mesh.init()
 game.change_scene(returning and "menu" or "boot")
end

function game.start_new_game()
 game.has_save=true
 game.story_id="intro"
 game.story_slide=1
 game.setup_progress=1
 story.start("intro",1)
end

function game.continue_game()
 if game.continue_scene=="game" then
  game.change_scene("game")
 else
  story.start(game.story_id or "intro",game.story_slide or 1)
 end
end

function game.change_scene(name)
 if name=="game" then
  music(-1,600)
  load("mesh_game.p8",nil,game.settings.sound and "sound" or "mute")
  return
 end
 local previous=game.scene_name
 game.scene_name=name
 if previous=="story" or name=="story" then
  audio.refresh()
 end
 local scene=scenes[name]
 if scene and scene.enter then
  scene.enter()
 end
end

function game.update()
 game.clock+=1

 local scene=scenes[game.scene_name]
 if scene and scene.update then
  scene.update()
 end

end

function game.draw()
 local scene=scenes[game.scene_name]
 if scene and scene.draw then
  scene.draw()
 end

end

function input.confirm_pressed()
 return btnp(4) or btnp(5)
end

function input.back_pressed()
 return btnp(5)
end

function audio.play(id)
 if game.settings.sound then
  sfx(id)
 end
end

function audio.refresh()
 if game.settings.sound and game.scene_name=="story" then
  music(0,1200,7)
 else
  music(-1,600)
 end
end
