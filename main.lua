-- Enable Lua/LOVE debugging with this hook.
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

-- load submodules
require "globals"
gGame.Sprites     = require("sprite")
gGame.Entities    = require("entity")
gGame.Factory     = require("factory")
gGame.Collision   = require("collision")
gGame.Node        = require("node")
gGame.Brain       = require("brain")
gGame.Tile        = require("tile")
gGame.Map         = require("map")
gGame.Camera      = require("camera")
gGame.Genes       = require("genes")
gGame.LifeForm    = require("lifeform")
gGame.World       = love.physics.newWorld(0, 0, true)

Cell = require("cell")

-- build factory
gGame.Factory.Register("Cell", Cell)
gGame.Factory.Register("Tile", Tile)

-- registered physics hooks
function beginContact(a, b, contact)
end

function endContact(a, b, contact)
end

function preSolve(a, b, contact)
end

function postSolve(a, b, contact)
    aData = a:getUserData()
    bData = b:getUserData()

    if aData and aData.NotifyCollision then
        aData:NotifyCollision(bData, contact)
    end
    
    if bData and bData.NotifyCollision then
        bData:NotifyCollision(aData, contact)
    end
end

-- startup load function
function love.load()
    Camera.Compute()

    gGame.World:setCallbacks(beginContact, endContact, preSolve, postSolve)

    -- test Init sequence: Spawn some random cells
    map = gGame.Map.new("maps/demo")
    map:Load()

    cells = {}
    for i = 1,200,1 do 
        cells[i] = Cell.new("cell" .. tostring(i),
                            math.random(map.X + 32, map.width * 31), 
                            math.random(map.Y + 32, map.height * 31),
                            math.random(-16, 16),
                            math.random(-16, 16))
    end


    gGame.Sprites.Load()
end


-- runtime loops
function love.update(dt)
    --gGame.Collision.HandleCollisions(dt)
    gGame.World:update(dt)
    gGame.Entities.Update(dt)

    if mousePressed == true then
        motX = love.mouse.getX() - mouseAnchor.X 
        motY = love.mouse.getY() - mouseAnchor.Y

        Camera.LookAt(camAnchor.X + motX, camAnchor.Y + motY)
    end
end

function love.draw()
    love.graphics.setBackgroundColor(255,255,255)

    love.graphics.push()
        love.graphics.translate(gGame.Camera.GetX(), gGame.Camera.GetY())
        gGame.Sprites.Draw()
    love.graphics.pop()
end


-- input hooks
function love.mousepressed(x, y, button, istouch)
    mousePressed = true
    mouseAnchor = {X = x, Y = y}
    camAnchor = gGame.Camera.GetPos()
end

function love.mousereleased(x, y, button, istouch)
    mousePressed = false
end

