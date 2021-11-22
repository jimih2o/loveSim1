Cell = {}
local cellMetaTable = {}

function Cell.new(name, X, Y, Vx, Vy)
    local obj = {
        name     = name,
        X        = X or 0,
        Y        = Y or 0,
        Vx       = Vx or 0,
        Vy       = Vy or 0,
        radius   = 16,
        isCircle = true,
        brain    = nil,
        timeCol  = 0
    }
    setmetatable(obj, cellMetaTable)

    local brainBlueprint = {
        NumInnerLayers   = 4,
        NumNodesPerLayer = 4,
        NumInputs        = 1,
        NumOutputs       = 1,
        EdgeMap = {
            { -- inner layer 1
                { -- node 1 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1},
                --   self,                  node2,                 node3,                 node4
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 2 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 3 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 4 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
            },
            -- inner layer 2
            {
                { -- node 1 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                --   self,                  node2,                 node3,                 node4
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 2 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 3 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 4 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
            },
            -- inner layer 3
            { 
                { -- node 1 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                --   self,                  node2,                 node3,                 node4
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 2 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 3 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 4 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
            },
            -- inner layer 4
            {
                { -- node 1 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                --   self,                  node2,                 node3,                 node4
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 2 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 3 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
                { -- node 4 edges
                --   bias,                  input1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1}
                },
            },
            { -- output layer
                { -- output 1 edges
                -- bias,                  node1
                    {math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1},
                },
            }
        }
    }

    obj.brain = gGame.Brain.new(brainBlueprint)

    gGame.Entities.Add(name, obj)
    gGame.Sprites.Add(name, obj)
    gGame.Collision.Add(obj)
    
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

    outputs = self.brain:Think({self:TimeFactor()})

    if outputs[1] >= 0.8 then
        self.Vx = 200.0
    elseif outputs[1] <= 0.2 then
        self.Vx = -200.0
    end

    self.X = self.X + self.Vx * dt
    self.Y = self.Y + self.Vy * dt
end

function Cell.TimeFactor(self)
    return 1.0 / (1.0 + self.timeCol)
end

function Cell.CollidesWidth(self, other, dt)
    if other.isCircle then
        -- basic circular collision detection
        if (self.X - other.X) * (self.X - other.X) + 
           (self.Y - other.Y) * (self.Y - other.Y) <= 
           (self.radius + other.radius) * (self.radius + other.radius) then
                return true
           end
    end

    return false
end

function Cell.HandleCollision(self, other, dt)
    -- weird massless collision algorithm
    if other.isCircle then
        vSelfToOther = {
            X = other.X - self.X,
            Y = other.Y - self.Y
        }

        vOtherToSelf = {
            X = self.X - other.X,
            Y = self.Y - other.Y
        }
        findMag = function (x, y) 
            return math.sqrt(x*x + y*y)
        end

        -- maintain vector speed, change direction
        magSelf = findMag(self.Vx, self.Vy)
        magOther = findMag(other.Vx, other.Vy)

        normFactor = 1.0 / findMag(vSelfToOther.X, vSelfToOther.Y)
        
        self.Vx = magSelf * normFactor * vOtherToSelf.X
        self.Vy = magSelf * normFactor * vOtherToSelf.Y 

        other.Vx = magOther * normFactor * vSelfToOther.X 
        other.Vy = magOther * normFactor * vSelfToOther.Y

        self.timeCol = 0
        if other.timeCol then other.timeCol = 0 end
    end
end

-- connect class to metatable
cellMetaTable.__index         = cellMetaTable
cellMetaTable.Load            = Cell.Load
cellMetaTable.Update          = Cell.Update
cellMetaTable.CollidesWidth   = Cell.CollidesWidth
cellMetaTable.HandleCollision = Cell.HandleCollision
cellMetaTable.TimeFactor      = Cell.TimeFactor

return Cell
