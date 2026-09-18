-- Final prologue slide: accept the impulse or abandon the story.

scenes.choice={}

function scenes.choice.enter()
 scenes.choice.selection=1
end

function scenes.choice.update()
 local scene=scenes.choice
 if btnp(2) or btnp(3) then
  scene.selection=3-scene.selection
  audio.play(2)
 end

 if input.confirm_pressed() then
  audio.play(0)
  if scene.selection==1 then
   game.change_scene("pre_shop")
  else
   game.change_scene("ending")
  end
 end
end

function scenes.choice.draw()
 local scene=scenes.choice
 cls(color.black)
 clip(0,0,128,76)
 story_art.video()
 clip()
 line(6,78,121,78,color.green)

 local items={
  "qpepktj l lpnqDFtfru",
  "qfrfstatD spqrptjcmGtDsG"
 }
 for index=1,2 do
  local y=87+(index-1)*17
  local selected=index==scene.selection
  if selected then rectfill(5,y-2,122,y+8,color.lime) end
  ui.cyr_text(items[index],10,y,selected and color.black or color.green)
 end
 print("8/8",6,122,color.green)
end
