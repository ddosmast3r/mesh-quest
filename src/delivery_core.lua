-- Calendar and parcel cartridge.

game={}
input={}
audio={}

function game.init()
 save.init()
 save.progress(3)
 game.settings={sound=stat(6)~="mute"}
 game.clock=0
 game.scene_name="delivery"
 scenes.delivery.enter()
end

function game.update()
 game.clock+=1
 scenes[game.scene_name].update()
end

function game.draw()
 scenes[game.scene_name].draw()
end

function game.open_setup()
 load("mesh_setup.p8",nil,game.settings.sound and "sound" or "mute")
end

function game.back_to_menu()
 music(-1,300)
 load("mesh_quest.p8",nil,game.settings.sound and "menu" or "menu_mute")
end

function input.confirm_pressed()
 return btnp(4) or btnp(5)
end

function audio.play(id)
 if game.settings.sound then sfx(id) end
end
