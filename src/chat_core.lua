-- First public Meshtastic channel cartridge.

game={}
input={}
audio={}

function game.init()
 save.init()
 save.progress(5)
 game.settings={sound=stat(6)~="mute"}
 game.clock=0
 game.scene_name="public_chat"
 scenes.public_chat.enter()
end

function game.update()
 game.clock+=1
 scenes[game.scene_name].update()
end

function game.draw()
 scenes[game.scene_name].draw()
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
