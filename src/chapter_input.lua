-- Pointer helpers for close-up interactions. Keyboard arrows still work.

function input.pointer_enter(scene,x,y)
 poke(0x5f2d,1)
 scene.cursor_x=x or 64
 scene.cursor_y=y or 64
 scene.raw_x=stat(32)
 scene.raw_y=stat(33)
 scene.mouse_buttons=stat(34)
end

function input.pointer_update(scene)
 local raw_x,raw_y=stat(32),stat(33)
 if raw_x!=scene.raw_x or raw_y!=scene.raw_y then
  scene.cursor_x=mid(0,raw_x,127)
  scene.cursor_y=mid(0,raw_y,127)
 end
 scene.raw_x,scene.raw_y=raw_x,raw_y
 if btn(0) then scene.cursor_x-=1 end
 if btn(1) then scene.cursor_x+=1 end
 if btn(2) then scene.cursor_y-=1 end
 if btn(3) then scene.cursor_y+=1 end
 scene.cursor_x=mid(0,scene.cursor_x,127)
 scene.cursor_y=mid(0,scene.cursor_y,127)
 local buttons=stat(34)
 local clicked=band(buttons,1)>0 and band(scene.mouse_buttons,1)==0
 scene.mouse_buttons=buttons
 scene.keyboard_click=btnp(4)
 return clicked or scene.keyboard_click
end

function input.inside(scene,area)
 return scene.cursor_x>=area[1] and scene.cursor_x<=area[3] and
  scene.cursor_y>=area[2] and scene.cursor_y<=area[4]
end

function input.draw_cursor(scene)
 local x,y=scene.cursor_x,scene.cursor_y
 line(x,y,x,y+7,color.black)
 line(x,y,x+5,y+5,color.black)
 line(x,y,x+2,y+5,color.black)
 pset(x,y,color.yellow)
 line(x+1,y+1,x+1,y+5,color.peach)
 line(x+2,y+2,x+4,y+4,color.peach)
end
