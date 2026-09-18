-- Radio preferences in the shared three-colour HUD.

scenes.settings={}

function scenes.settings.update()
 if btnp(2) or btnp(3) then
  game.setting_selection=3-game.setting_selection
  audio.play(2)
 end

 if btnp(0) or btnp(1) or btnp(4) then
  scenes.settings.toggle_selected()
 elseif input.back_pressed() then
  audio.play(1)
  game.change_scene("menu")
 end
end

function scenes.settings.toggle_selected()
 local item=content.setting_items[game.setting_selection]
 game.settings[item.key]=not game.settings[item.key]
 audio.play(2)
end

function scenes.settings.draw()
 cls(color.black)

 if game.settings.grid then
  ui.draw_grid(10,122)
 end

 ui.header("settings","radio","mq-01")

 for index=1,#content.setting_items do
  local item=content.setting_items[index]
  scenes.settings.draw_row(index,item,23+(index-1)*14)
 end

 line(0,52,127,52,color.green)
 print("region",4,58,color.green)
 print("eu_868",92,58,color.lime)

 print("channel",4,70,color.green)
 print("longfast",88,70,color.lime)

 line(0,84,127,84,color.green)
 print("arrows",4,91,color.green)
 print("select",92,91,color.lime)
 print("z",4,103,color.green)
 print("change",92,103,color.lime)
 print("x",4,115,color.green)
 print("back",108,115,color.lime)
end

function scenes.settings.draw_row(index,item,y)
 local active=index==game.setting_selection
 local value=game.settings[item.key]
 local text_color=color.green

 if active then
  rectfill(0,y-2,127,y+6,color.lime)
  text_color=color.black
  print(">",3,y,text_color)
 end

 print(item.label,11,y,text_color)
 print(value and "on" or "off",112,y,text_color)
end
