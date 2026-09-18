-- Application state, input helpers, and scene routing.

game={}
input={}
audio={}

function game.init()
 srand(1337)

 game.scene_name=nil
 game.clock=0
 game.has_save=false
 game.menu_selection=1
 game.setting_selection=1
 game.notice_text=""
 game.notice_frames=0
 game.settings={
  sound=true,
  grid=true
 }

 mesh.init()
 game.change_scene("boot")
end

function game.change_scene(name)
 game.scene_name=name
 local scene=scenes[name]
 if scene and scene.enter then
  scene.enter()
 end
end

function game.show_notice(message,duration)
 game.notice_text=message
 game.notice_frames=duration or 150
end

function game.update()
 game.clock+=1

 local scene=scenes[game.scene_name]
 if scene and scene.update then
  scene.update()
 end

 if game.notice_frames>0 then
  game.notice_frames-=1
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
