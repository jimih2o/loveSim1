Cell = {}
local cellMetaTable = {}

function Cell.new(name, X, Y)
    local obj = {
        name = name or "default",
        X = X or 0,
        Y = Y or 0
    }
    setmetatable(obj, cellMetaTable)

    gGame.Entities.Add(obj.name, obj)
    gGame.Sprites.Add(obj.name, obj)
    
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
    -- right now do nothing.
end

-- connect class to metatable
cellMetaTable.__index = cellMetaTable
cellMetaTable.Load    = Cell.Load
cellMetaTable.Update  = Cell.Update

return Cell
