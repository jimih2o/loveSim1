Tile = {
    count = 0,
    images = {},
}
local tileMeta = {}

Tile.new = function (imgPath, isWall, x, y)
    local obj = {
        X       = x or 0,
        Y       = y or 0,
        imgPath = imgPath,
        isTile  = true,
        isBox   = true,
        width   = 32,
        height  = 32,
        isWall  = isWall or false,
    }
    setmetatable(obj, tileMeta)

    Tile.count = Tile.count + 1

    gGame.Sprites.Add(obj)

    if isWall then
        --gGame.Collision.Add(obj)
        obj.body    = love.physics.newBody(gGame.World, obj.X, obj.Y, "static")
        obj.shape   = love.physics.newRectangleShape(obj.width, obj.height)
        obj.fixture = love.physics.newFixture(obj.body, obj.shape)
    end

    return obj
end

Tile.Load = function (self)
    Tile.images[self.imgPath] = Tile.images[self.imgPath] or love.graphics.newImage(self.imgPath)
    self.image = Tile.images[self.imgPath]
end

Tile.SetPos = function (self, x, y)
    self.X = x
    self.Y = y
end

Tile.SetCoord = function (self, row, col)
    self.X = math.floor(row * 32 + 0.5)
    self.Y = math.floor(col * 32 + 0.5)
end

Tile.GetCoord = function (self)
    return {
        row = math.floor( self.X / 32 ),
        col = math.floor( self.Y / 32 )
    }
end

Tile.GetRow = function (self)
    return math.floor(self.X / 32)
end

Tile.GetCol = function (self)
    return math.floor(self.Y / 32)
end

Tile.CollidesWith = function (self, other, dt)
    if other.isTile then
        return self:GetRow() == other:GetRow() and self:GetCol() == other:GetCol()
    end

    return gGame.Collision.TryResolveCollides(self, other, dt)
end

Tile.HandleCollision = function (self, other, dt)
    if not other.isTile then
        other:HandleCollision(self, dt)
    end
end

tileMeta.__index         = tileMeta
tileMeta.Load            = Tile.Load
tileMeta.SetPos          = Tile.SetPos
tileMeta.SetCoord        = Tile.SetCoord
tileMeta.GetCoord        = Tile.GetCoord
tileMeta.GetRow          = Tile.GetRow
tileMeta.GetCol          = Tile.GetCol
tileMeta.CollidesWidth   = Tile.CollidesWith
tileMeta.HandleCollision = Tile.HandleCollision

return Tile
