Cell = {}
local cellMetaTable = {}

function Cell.new(name, X, Y, Vx, Vy)
    local obj = {
        name     = name,
        X        = X or 0,
        Y        = Y or 0,
        radius   = 16,
        isCircle = true,
        isCell   = true,
        brain    = nil,
        timeCol  = 0,
        timeAlive = 0,
    }
    setmetatable(obj, cellMetaTable)

    local brainBlueprint = {
        NumInnerLayers   = 1,
        NumNodesPerLayer = 4,
        NumInputs        = 2,
        NumOutputs       = 2,
        EdgeMap = {
            { -- inner layer 1
                { -- node 1 edges
                --   bias,                  input1                 input 2
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                --   self,                  node2,                 node3,                 node4
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 2 edges
                --   bias,                  input1                 input 2
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 3 edges
                --   bias,                  input1                 input 2
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 4 edges
                --   bias,                  input1                 input 2
                    {math.random() * 2 - 1, math.random() * 2 - 1,  math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
            },
            { -- output layer
                { -- output 1 edges
                -- bias,                  node1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                },
                { -- output 2 edges
                -- bias,                  node1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                },
            }
        }
    }

    obj.brain = gGame.Brain.new(brainBlueprint)

    -- attach physics instance to cell
    obj.body    = love.physics.newBody(gGame.World, obj.X, obj.Y, "dynamic")
    obj.shape   = love.physics.newCircleShape(obj.radius)
    obj.fixture = love.physics.newFixture(obj.body, obj.shape)
    obj.fixture:setUserData(obj) -- allow context to be passed through
    obj.body:setLinearVelocity(Vx or 0, Vy or 0)

    gGame.Entities.Add(name, obj)
    gGame.Sprites.Add(obj)

    return obj
end

Cell.image = nil

function Cell.Load(self)
    if not Cell.image then
        print("Loading image imgs/SingleCell.png")
        Cell.image = love.graphics.newImage("imgs/SingleCell.png")
    end

    self.image = Cell.image
end

function Cell.Update(self, dt)
    self.timeCol = self.timeCol + dt
    self.timeAlive = self.timeAlive + dt

    outputs = self.brain:Think({self:TimeFactor(), self.timeAlive})

    Vx, Vy = self.body:getLinearVelocity()
    if outputs[1] >= 0.8 then
        Vx = 200.0
    elseif outputs[1] <= 0.2 then
        Vx = -200.0
    end

    if outputs[2] >= 0.8 then
        Vy = 200.0
    elseif outputs[2] <= 0.2 then
        Vy = -200.0
    end
    
    self.body:setLinearVelocity(Vx, Vy)

    -- draw off from center
    x, y = self.body:getPosition()

    self.X = x
    self.Y = y
end

function Cell.TimeFactor(self)
    return 1.0 / (1.0 + self.timeCol)
end

function Cell.NotifyCollision(self, other, contact)
    self.timeCol = 0
end

-- connect class to metatable
cellMetaTable.__index         = cellMetaTable
cellMetaTable.Load            = Cell.Load
cellMetaTable.Update          = Cell.Update
cellMetaTable.NotifyCollision = Cell.NotifyCollision
cellMetaTable.TimeFactor      = Cell.TimeFactor

return Cell
