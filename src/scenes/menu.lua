-- Main menu over the reference mesh-map interface.

scenes.menu={time=0}

function scenes.menu.enter()
 scenes.menu.time=0
 game.notice_frames=0
 scenes.menu.items={}
 add(
  scenes.menu.items,
  game.has_save and content.continue_item or content.new_game_item
 )
 add(scenes.menu.items,content.settings_item)
 game.menu_selection=mid(1,game.menu_selection,#scenes.menu.items)
end

function scenes.menu.update()
 scenes.menu.time+=1
 mesh.update_menu()

 if btnp(2) then
  game.menu_selection=(game.menu_selection-2)%#scenes.menu.items+1
  audio.play(2)
 elseif btnp(3) then
  game.menu_selection=game.menu_selection%#scenes.menu.items+1
  audio.play(2)
 end

 if input.confirm_pressed() then
  scenes.menu.activate(scenes.menu.items[game.menu_selection])
 end
end

function scenes.menu.activate(item)
 audio.play(item.sfx)

 if item.notice then
  game.notice_text=item.notice
  game.notice_frames=90
 elseif item.target then
  game.change_scene(item.target)
 end
end

function scenes.menu.draw()
 cls(color.black)
 ui.header("mesh quest","main","868mhz")
 clip(0,10,128,84)
 if game.settings.grid then
  ui.draw_grid(10,94)
 end
 mesh.draw_menu(scenes.menu.time,-8)
 clip()
 scenes.menu.draw_items()
 scenes.menu.draw_notice()
end

function scenes.menu.draw_items()
 rectfill(0,94,127,127,color.black)
 line(0,94,127,94,color.green)

 for index=1,#scenes.menu.items do
  local item=scenes.menu.items[index]
  local y=101+(index-1)*14
  local active=index==game.menu_selection
  local text_color=color.green

  if active then
   rectfill(0,y-1,127,y+7,color.lime)
   text_color=color.black
   print(">",3,y+1,text_color)
  end

  ui.cyr_text(item.label,11,y,text_color)

  if item.enabled==false then
   print("--",116,y+1,text_color)
  end
 end
end

function scenes.menu.draw_notice()
 if game.notice_frames<=0 then
  return
 end

 rectfill(8,78,119,91,color.black)
 rect(8,78,119,91,color.green)
 ui.cyr_centered(game.notice_text,82,color.lime)
end
