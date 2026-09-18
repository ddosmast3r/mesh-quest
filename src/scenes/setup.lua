-- First interactive beat: prepare the new radio in the correct order.

scenes.setup={time=0,selected=1,notice_time=0}

function scenes.setup.enter()
 local scene=scenes.setup
 scene.time=0
 scene.notice_time=0
 scene.selected=mid(1,game.setup_progress,#content.setup_steps)
 game.continue_scene="setup"
end

function scenes.setup.update()
 local scene=scenes.setup
 scene.time+=1
 if scene.notice_time>0 then scene.notice_time-=1 end

 if btnp(2) then
  scene.selected=(scene.selected-2)%#content.setup_steps+1
  audio.play(2)
 elseif btnp(3) then
  scene.selected=scene.selected%#content.setup_steps+1
  audio.play(2)
 elseif btnp(4) then
  scene.activate()
 elseif btnp(5) then
  audio.play(1)
  game.back_to_menu()
 end
end

function scenes.setup.activate()
 local scene=scenes.setup

 if game.setup_progress>#content.setup_steps then
  audio.play(1)
 elseif scene.selected==game.setup_progress then
  game.setup_progress+=1
  scene.selected=min(game.setup_progress,#content.setup_steps)
  audio.play(game.setup_progress>#content.setup_steps and 0 or 2)
 else
  scene.notice_time=60
  audio.play(3)
 end
end

function scenes.setup.draw()
 cls(color.black)
 ui.cyr_text("oastrpkla",4,3,color.lime)
 print(min(game.setup_progress,3).."/3",112,3,color.green)
 line(0,10,127,10,color.green)

 scenes.setup.draw_hardware()
 line(0,53,127,53,color.green)

 for index=1,#content.setup_steps do
  scenes.setup.draw_step(index,58+(index-1)*15)
 end

 scenes.setup.draw_footer()
end

function scenes.setup.draw_hardware()
 local progress=game.setup_progress

 rect(7,17,58,43,color.green)
 rectfill(11,21,54,39,color.black)
 line(3,47,63,47,color.green)
 line(7,43,3,47,color.green)
 line(58,43,63,47,color.green)

 if progress>1 then
  print("usb driver",14,25,color.lime)
  print("installed",18,32,color.green)
 else
  print("no driver",19,28,color.green)
 end

 line(97,14,97,21,color.green)
 rect(88,21,106,46,color.green)
 rectfill(92,25,102,35,color.black)
 pset(97,40,progress>2 and color.lime or color.green)

 if progress>2 then
  line(63,44,76,49,color.yellow)
  line(76,49,88,42,color.yellow)
 end

 if progress>#content.setup_steps and scenes.setup.time%32<22 then
  circ(97,29,14,color.green)
  circ(97,29,18,color.green)
 end
end

function scenes.setup.draw_step(index,y)
 local scene=scenes.setup
 local active=index==scene.selected
 local complete=index<game.setup_progress
 local text_color=complete and color.lime or color.green

 if active then
  rectfill(0,y-2,127,y+7,color.lime)
  text_color=color.black
  print(">",3,y,text_color)
 end

 ui.cyr_text(content.setup_steps[index].label,11,y,text_color)
 if complete then
  print("+",119,y,text_color)
 end
end

function scenes.setup.draw_footer()
 if game.setup_progress>#content.setup_steps then
  ui.cyr_centered("vstrpkstcp oa scGij",111,color.lime)
 elseif scenes.setup.notice_time>0 then
  ui.cyr_centered("soayama qrfeyevAjk zad",111,color.yellow)
 else
  print("z",4,118,color.green)
  ui.cyr_text("cybratD",12,118,color.green)
  print("x",82,118,color.green)
  ui.cyr_text("nfoF",90,118,color.green)
 end
end
