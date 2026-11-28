function love.conf(t)
    t.window.title = 'Hit The Jam'
    t.window.width = 360
    t.window.height = 640
    t.window.fullscreen = false
    t.window.resizable = true
    t.window.vsync = 1
    t.graphics = t.graphics or {}
    t.graphics.renderers = { "opengl" }
end
