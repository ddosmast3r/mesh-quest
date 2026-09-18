-- Development gallery for animated Cyrillic text treatments.

scenes.text_fx={time=0}

function scenes.text_fx.enter()
 scenes.text_fx.time=0
 music(-1,300)
end

function scenes.text_fx.update()
 scenes.text_fx.time+=1
 if btnp(5) then game.change_scene("menu") end
end

function scenes.text_fx.draw()
 local time=scenes.text_fx.time
 cls(color.black)
 ui.header("text fx","glitch","dev")
 ui.cyr_fx("qpnfwa",43,60,color.yellow,"glitch",time)
 print("x",4,121,color.green)
 print("menu",12,121,color.green)
end
