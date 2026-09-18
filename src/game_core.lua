-- State and routing for the gameplay cartridge.

game={}
input={}
audio={}

function game.init()
 srand(1337)
 game.scene_name=nil
 game.clock=0
 game.setup_progress=1
 game.settings={sound=stat(6)~="mute",grid=true}
 game.change_scene("shop")
end

function game.change_scene(name)
 game.scene_name=name
 local scene=scenes[name]
 if scene and scene.enter then scene.enter() end
end

function game.back_to_menu()
 music(-1,600)
 load("mesh_quest.p8",nil,game.settings.sound and "menu" or "menu_mute")
end

function game.update()
 game.clock+=1
 local scene=scenes[game.scene_name]
 if scene and scene.update then scene.update() end
end

function game.draw()
 local scene=scenes[game.scene_name]
 if scene and scene.draw then scene.draw() end
end

function input.confirm_pressed()
 return btnp(4) or btnp(5)
end

function input.back_pressed()
 return btnp(5)
end

function audio.play(id)
 if game.settings.sound then sfx(id) end
end
