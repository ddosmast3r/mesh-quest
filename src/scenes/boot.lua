-- Hardware-style startup sequence.

scenes.boot={
 time=0
}

function scenes.boot.enter()
 scenes.boot.time=0
end

function scenes.boot.update()
 local boot=scenes.boot
 boot.time+=1

 if boot.time==142 then
  audio.play(0)
 end

 local skipped=boot.time>25 and input.confirm_pressed()
 if boot.time>190 or skipped then
  audio.play(1)
  game.change_scene("logo")
 end
end

function scenes.boot.draw()
 local time=scenes.boot.time
 local stage=max(0,flr((time-12)/32)+1)

 cls(color.black)
 ui.header("mesh os","boot","868")

 for i=1,min(stage,#content.boot_checks) do
  local item=content.boot_checks[i]
  local y=25+(i-1)*12
  print(item.label,8,y,color.green)
  print(item.value,120-#item.value*4,y,color.lime)
 end

 scenes.boot.draw_progress(time)

 if time>142 then
  ui.centered("incoming packet",88,color.lime)
  if time%24<12 then
   rectfill(61,99,66,104,color.lime)
  else
   rect(61,99,66,104,color.green)
  end
 end

 if time>25 and time<180 and time%50<34 then
  ui.centered("press x to skip",116,color.green)
 end
end

function scenes.boot.draw_progress(time)
 local progress=mid(0,(time-8)/126,1)
 rect(8,68,119,73,color.green)
 rectfill(10,70,10+flr(progress*107),71,color.lime)
end
