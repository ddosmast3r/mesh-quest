-- State and routing for the checkout cutscene cartridge.

game={}
input={}
audio={}

function game.init()
 save.init()
 save.progress(2)
 game.scene_name="payment"
 game.clock=0
 game.settings={sound=stat(6)~="mute",grid=true}
 local scene=scenes.payment
 if scene and scene.enter then scene.enter() end
end

function game.open_delivery()
 music(-1,300)
 load("mesh_delivery.p8",nil,game.settings.sound and "sound" or "mute")
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

function game.back_to_menu()
 music(-1,600)
 load("mesh_quest.p8",nil,game.settings.sound and "menu" or "menu_mute")
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
