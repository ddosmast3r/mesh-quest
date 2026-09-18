-- Optional screenshot harness for visual regression checks.
-- Example: pico8 -x mesh_quest.p8 -p capture_menu

dev={}

function dev.after_init()
 local parameter=stat(6) or ""
 dev.capture_issued=false

 if sub(parameter,1,13)=="capture_story" then
  local slide_index=tonum(sub(parameter,15)) or 1
 scenes.story.pending_id="intro"
 scenes.story.pending_slide=slide_index
 game.change_scene("story")
  scenes.story.phase="ready"
  scenes.story.phase_time=12
  scenes.story.visible=scenes.story.total
  scenes.story.time=120
 elseif sub(parameter,1,8)=="capture_" then
  game.change_scene(sub(parameter,9))
 end
end

function dev.after_draw()
 local parameter=stat(6) or ""
 if sub(parameter,1,8)~="capture_" then
  return
 end

 local delay=1
 if game.scene_name=="boot" then delay=180 end
 if game.scene_name=="logo" then delay=118 end
 if game.scene_name=="menu" then delay=2 end
 if game.scene_name=="story" then delay=2 end
 if game.clock==delay then
  extcmd("screen",4,1)
  dev.capture_issued=true
 elseif dev.capture_issued and game.clock>delay+20 then
  stop()
 end
end
