BASE_WIDTH = 432
BASE_HEIGHT = 243
require "dependencies"

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- set the application title bar
    love.window.setTitle('Breakout')

    -- initialize our nice-looking retro text fonts
    Gfonts = {
        ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
    }
    love.graphics.setFont(Gfonts['small'])

    -- load up the graphics we'll be using throughout our states
    GTextures = {
        ['background'] = love.graphics.newImage('assets/images/background.png'),
        ['block'] = love.graphics.newImage('assets/images/blocks.png'),
        ['main'] = love.graphics.newImage('assets/images/breakout.png'),
        ['arrows'] = love.graphics.newImage('assets/images/arrows.png'),
        ['hearts'] = love.graphics.newImage('assets/images/hearts.png'),
        ['particle'] = love.graphics.newImage('assets/images/particle.png')
    }

    -- Quads we will generate for all of our textures; Quads allow us
    -- to show only part of a texture and not the entire thing

    --[[   gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main'])
    } ]]

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    Push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, { upscale = 'normal' })

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    GSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    -- the state machine we'll be using to transition between various states
    -- in our game instead of clumping them together in our update and draw
    -- methods
    --
    -- our current game state can be any of the following:
    -- 1. 'start' (the beginning of the game, where we're told to press Enter)
    -- 2. 'paddle-select' (where we get to choose the color of our paddle)
    -- 3. 'serve' (waiting on a key press to serve the ball)
    -- 4. 'play' (the ball is in play, bouncing between paddles)
    -- 5. 'victory' (the current level is over, with a victory jingle)
    -- 6. 'game-over' (the player has lost; display score and allow restart)
    GStateMachine = StateMachine {
        ['startState'] = function() return StartState() end,
        ['selectPedalState'] = function() return SelectPedalState() end,
        ['runningState'] = function() return RunningState() end,
        ['gameOverState'] = function() return GameOverState() end,
        ['highScoreState'] = function() return HighScoreState() end
    }
    GStateMachine:change('startState')

    -- a table we'll use to keep track of which keys have been pressed this
    -- frame, to get around the fact that LÖVE's default callback won't let us
    -- test for input from within other functions
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.resize(w, h)
    WINDOW_WIDTH = w
    WINDOW_HEIGHT = h
    Push.resize(w, h)
end

function love.update(dt)
    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end

    GStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    -- begin drawing with push, in our virtual resolution
    Push.start()

    -- background should be drawn regardless of state, scaled to fit our
    -- virtual resolution
    local backgroundWidth = GTextures['background']:getWidth()
    local backgroundHeight = GTextures['background']:getHeight()

    love.graphics.draw(GTextures['background'],
        -- draw at coordinates 0, 0
        0, 0,
        -- no rotation
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    -- use the state machine to defer rendering to the current state we're in
    GStateMachine:render()

    -- display FPS for debugging; simply comment out to remove
    displayFPS()

    Push.finish()
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(Gfonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
end
