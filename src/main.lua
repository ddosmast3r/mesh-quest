-- PICO-8 entry points stay deliberately tiny.

dev=dev or {}

function _init()
 game.init()
 if dev.after_init then dev.after_init() end
end

function _update60()
 game.update()
end

function _draw()
 game.draw()
 if dev.after_draw then dev.after_draw() end
end
