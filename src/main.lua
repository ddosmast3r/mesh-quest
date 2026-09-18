-- PICO-8 entry points stay deliberately tiny.

function _init()
 game.init()
 dev.after_init()
end

function _update60()
 game.update()
end

function _draw()
 game.draw()
 dev.after_draw()
end
