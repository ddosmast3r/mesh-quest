-- Animated title reveal, kept separate from the BIOS-style boot scene.

scenes.logo={
 time=0,
 reveal_start=12,
 reveal_end=96,
 finish_time=210
}

function scenes.logo.enter()
 scenes.logo.time=0
end

function scenes.logo.update()
 local logo=scenes.logo
 logo.time+=1

 if logo.time==logo.reveal_start then
  audio.play(5)
 end

 if logo.time==logo.reveal_end then
  audio.play(0)
 end

 local can_skip=logo.time>logo.reveal_end+18
 if logo.time>logo.finish_time or
    (can_skip and input.confirm_pressed()) then
  game.change_scene("menu")
 end
end

function scenes.logo.draw()
 local logo=scenes.logo
 local progress=mid(
  0,
  (logo.time-logo.reveal_start)/
   (logo.reveal_end-logo.reveal_start),
  1
 )
 local reveal_width=flr(progress*120)
 local x=4
 local y=55

 cls(color.black)
 scenes.logo.draw_carrier(y,progress)
 ui.draw_logo(x,y,reveal_width)
 scenes.logo.draw_reveal_edge(x,y,reveal_width)
 scenes.logo.draw_glitch(x,y,reveal_width,progress)
end

function scenes.logo.draw_carrier(y,progress)
 if progress<=0 or progress>=1 then
  return
 end

 local carrier_y=y+20
 local carrier_width=flr(progress*124)
 for x=2,carrier_width,4 do
  pset(x,carrier_y,color.green)
 end
end

function scenes.logo.draw_reveal_edge(x,y,reveal_width)
 if reveal_width<=0 or reveal_width>=120 then
  return
 end

 local edge=x+reveal_width
 line(edge,y-2,edge,y+17,color.green)

 if scenes.logo.time%6<3 then
  pset(edge+2,y+2,color.lime)
  pset(edge+3,y+9,color.green)
  pset(edge+1,y+14,color.lime)
 end
end

function scenes.logo.draw_glitch(x,y,reveal_width,progress)
 local time=scenes.logo.time
 if progress<=0 or progress>=1 or time%15>2 then
  return
 end

 local strip_y=y+3+flr(time/15)%4*3
 local offset=time%2==0 and 2 or -1
 clip(x,strip_y,reveal_width,2)
 sspr(0,0,120,16,x+offset,y,120,16)
 clip()
end
