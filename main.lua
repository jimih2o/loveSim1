-- Enable Lua/LOVE debugging with this hook.
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

-- load submodules
require "globals"
gGame.Sprites = require("sprite")
gGame.Entities = require("entity")
gGame.Collision = require("collision")

Cell = require("cell")

-- startup load function
function love.load()
    -- test Init sequence: Spawn some random cells
    cells = {}
    for i = 1,100,1 do 
        cells[i] = Cell.new("cell" .. tostring(i),
                            math.random(0, 600), 
                            math.random(0, 600),
                            math.random(-16, 16),
                            math.random(-16, 16))
    end


    gGame.Sprites.Load()
end

-- runtime loops
function love.update(dt)
    gGame.Collision.HandleCollisions(dt)
    gGame.Entities.Update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(255,255,255)
    gGame.Sprites.Draw()
end


-- input hooks
function love.mousereleased(x, y, button, istouch)
end

