-- Reusable Undertale-style story player. Slide data is generated separately.

story={}
scenes.story={}

function story.start(story_id,slide_index)
 scenes.story.pending_id=story_id
 scenes.story.pending_slide=slide_index or 1
 game.change_scene("story")
end

function scenes.story.enter()
 local scene=scenes.story
 scene.story_id=scene.pending_id or game.story_id or "intro"
 scene.data=story_content[scene.story_id]
 scene.slide_index=scene.pending_slide or game.story_slide or 1
 scene.time=0
 scene.skip_hold=0

 if not scene.data then
  game.change_scene("menu")
  return
 end

 scene.load_slide()
 game.continue_scene="story"
end

function scenes.story.load_slide()
 local scene=scenes.story
 scene.slide=scene.data.slides[scene.slide_index]
 scene.lines=ui.cyr_wrap(scene.slide.text,112)
 scene.phase="fade_in"
 scene.phase_time=0
 scene.ready_time=0
 scene.prepare_page()

 game.story_id=scene.story_id
 game.story_slide=scene.slide_index
end

function scenes.story.prepare_page()
 local scene=scenes.story
 scene.visible=0
 scene.total=0

 for index=1,#scene.lines do
  scene.total+=#scene.lines[index]
  if index<#scene.lines then
   scene.total+=1
  end
 end
end

function scenes.story.update()
 local scene=scenes.story
 scene.time+=1

 if btn(5) then
  scene.skip_hold+=1
  if scene.skip_hold>=45 then
   scene.finish()
   return
  end
 else
  scene.skip_hold=0
 end

 local pressed=btnp(4) or btnp(5)

 if scene.phase=="fade_in" then
  scene.phase_time+=1
  if pressed then scene.phase_time=12 end
  if scene.phase_time>=12 then
   scene.phase=scene.slide.instant and "ready" or "typing"
   scene.visible=scene.slide.instant and scene.total or 0
   scene.ready_time=0
  end
 elseif scene.phase=="typing" then
  if pressed then
   scene.visible=scene.total
   scene.phase="ready"
   scene.ready_time=0
  elseif scene.time%(scene.slide.speed or 2)==0 then
   scene.visible=min(scene.visible+1,scene.total)
   if scene.visible%6==0 then audio.play(2) end
   if scene.visible>=scene.total then
    scene.phase="ready"
    scene.ready_time=0
   end
  end
 elseif scene.phase=="ready" then
  scene.ready_time+=1
  if pressed or
     (scene.slide.auto_after and scene.ready_time>=scene.slide.auto_after) then
   scene.advance()
  end
 elseif scene.phase=="fade_out" then
  scene.phase_time+=1
  if scene.phase_time>=12 then
   scene.slide_index+=1
   if scene.slide_index>#scene.data.slides then
    scene.finish()
   else
    scene.load_slide()
   end
  end
 end
end

function scenes.story.advance()
 local scene=scenes.story
 scene.phase="fade_out"
 scene.phase_time=0
 scene.visible=0
end

function scenes.story.finish()
 local scene=scenes.story
 game.story_slide=#scene.data.slides+1
 game.continue_scene=scene.data.next_scene
 game.change_scene(scene.data.next_scene)
end

function scenes.story.fade_level()
 local scene=scenes.story
 if scene.phase=="fade_in" then
  return min(4,flr(scene.phase_time/3))
 elseif scene.phase=="fade_out" then
  return max(0,4-flr(scene.phase_time/3))
 end
 return 4
end

function scenes.story.draw()
 local scene=scenes.story
 cls(color.black)

 clip(0,0,128,76)
 story_art.draw(scene.slide.art,scene.time)
 story_art.fade_mask(scene.fade_level())
 clip()

 line(6,78,121,78,color.green)
 scenes.story.draw_text()
 print(scene.slide_index.."/"..#scene.data.slides,6,122,color.green)

 if scene.phase=="ready" and scene.time%30<20 then
  line(116,120,122,120,color.yellow)
  line(118,122,120,124,color.yellow)
 end

 if scene.skip_hold>0 then
  line(0,127,flr(127*scene.skip_hold/45),127,color.lime)
 end
end

function scenes.story.draw_text()
 local scene=scenes.story
 if scene.phase=="fade_in" or scene.phase=="fade_out" then
  return
 end

 local remaining=scene.visible
 for index=1,#scene.lines do
  if remaining>0 then
   local text_line=scene.lines[index]
   local visible_in_line=min(#text_line,remaining)
   ui.cyr_text(sub(text_line,1,visible_in_line),8,84+(index-1)*7,color.yellow)
   remaining-=#text_line+1
  end
 end
end
