-- A quiet bridge between the decision and the interactive browser.

scenes.pre_shop={
 phrases={
  "tal, sfkyas...",
  "iakeu c brauifr...",
  "aipo, nfztastjl..."
 }
}

function scenes.pre_shop.enter()
 local scene=scenes.pre_shop
 scene.phrase=1
 scene.visible=0
 scene.time=0
end

function scenes.pre_shop.update()
 local scene=scenes.pre_shop
 scene.time+=1
 local text=scene.phrases[scene.phrase]

 if input.confirm_pressed() then
  if scene.visible<#text then
   scene.visible=#text
  elseif scene.phrase<#scene.phrases then
   scene.phrase+=1
   scene.visible=0
  else
   game.change_scene("game")
  end
 elseif scene.time%2==0 and scene.visible<#text then
  scene.visible+=1
  if scene.visible%6==0 then audio.play(2) end
 end
end

function scenes.pre_shop.draw()
 local scene=scenes.pre_shop
 local text=scene.phrases[scene.phrase]
 cls(color.black)
 ui.cyr_text(
  sub(text,1,scene.visible),
  64-flr(ui.cyr_width(text)/2),
  59,
  color.yellow
 )
 if scene.visible>=#text and scene.time%30<20 then
  line(60,73,66,73,color.yellow)
  line(62,75,64,77,color.yellow)
 end
end
