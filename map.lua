Map = {}
local mapMeta = {}

Map.new = function (map)
    local obj = {
        map     = require(map)
    }
    setmetatable(obj, mapMeta)

    return obj
end

Map.Load = function(self)
    local tileSetPath = "maps/tilesets/" .. self.map.tilesets[1].name
    local tileSet = require(tileSetPath)

    self.tiles = {}
    for _,layer in pairs(self.map.layers) do
        self.X      = math.min(layer.x, self.X or 0)
        self.Y      = math.min(layer.y, self.Y or 0)
        self.width  = math.max(layer.width, self.width or 0)
        self.height = math.max(layer.height, self.height or 0)

        for x = layer.x,(layer.width - 1) do
            for y = layer.y,(layer.height - 1) do
                tileIndex = layer.data[x + layer.width*y + 1] - 1 -- arbitrary translation from Tiled here
                for _,tileData in ipairs(tileSet.tiles) do
                    if tileData.id == tileIndex then
                        imgPath = tileData.image
                        -- chop to imgs folder
                        imgPath = imgPath:sub(imgPath:find("imgs"), imgPath:len())

                        isWall = not (imgPath:find("walls") == nil)
                        break
                    end
                end

                self.tiles[#self.tiles + 1] = gGame.Factory.Spawn("Tile", imgPath, isWall, x*32, y*32)
            end
        end
    end
end

mapMeta.__index = mapMeta
mapMeta.Load    = Map.Load

return Map
