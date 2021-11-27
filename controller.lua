Controller = {}
local controllerMeta = {}

Controller.CharToCount = function(char)
    -- between 1 and 27
    return string.byte(char) - 64 
end

Controller.CharToEdge = function(char)
    local x = string.byte(char) - 65

    -- have a number between 0...25
    -- need to convert it to -100, ..., 100
    -- 0  : -100
    -- 12 :    0
    -- 25 :  100
    x = -100 + (25 - x) / 25.0 * 100 + 0.5

    return math.floor(x)
end

Controller.ValidateSnip = function(snip)
    -- must be at least this long to have a brain
    if snip:len() < 4 then return false end

    NumInnerLayers   = Controller.CharToCount(snip:sub(1,1))
    NumNodesPerLayer = Controller.CharToCount(snip:sub(2,2))
    NumInputs        = Controller.CharToCount(snip:sub(3,3))
    NumOutputs       = Controller.CharToCount(snip:sub(4,4))

    brainSnipsRequired =  NumNodesPerLayer * (1 + NumInnerLayers + NumNodesPerLayer) -- first inner layer
                        + NumInnerLayers * (1 + 2 * NumNodesPerLayer)                -- inner layers
                        + NumOutputs * (1 + NumNodesPerLayer)                        -- output layer
    
    totalSequenceMinimumLength = brainSnipsRequired + 4

    return snip:len() >= totalSequenceMinimumLength
end

Controller.GetSnipLengthNeeded = function(snip)
    NumInnerLayers   = Controller.CharToCount(snip:sub(1,1))
    NumNodesPerLayer = Controller.CharToCount(snip:sub(2,2))
    NumInputs        = Controller.CharToCount(snip:sub(3,3))
    NumOutputs       = Controller.CharToCount(snip:sub(4,4))

    brainSnipsRequired =  NumNodesPerLayer * (1 + NumInputs + NumNodesPerLayer) -- first inner layer
                        + NumInnerLayers * (1 + 2 * NumNodesPerLayer)           -- inner layers
                        + NumOutputs * (1 + NumNodesPerLayer)                   -- output layer
    
    totalSequenceMinimumLength = brainSnipsRequired + 4

    return totalSequenceMinimumLength
end

Controller.new = function(snip)
    local cnt = {
        health = 100,
        isDead = false
    }
    setmetatable(cnt, controllerMeta)

    -- controller snip is primarily a compute node
    -- it is a direct encoding for the brain blueprint
    cnt.blueprint = {
        NumInnerLayers   = Controller.CharToCount(snip:sub(1,1)),
        NumNodesPerLayer = Controller.CharToCount(snip:sub(2,2)),
        NumInputs        = Controller.CharToCount(snip:sub(3,3)),
        NumOutputs       = Controller.CharToCount(snip:sub(4,4)),
        EdgeMap = {}
    }
    
    -- first count the number of edges in the first inner layer
    --                input edges                                             bias   inter-connection edges
    local snipIndex = 5

    cnt.blueprint.EdgeMap[1] = {}

    for i = 1,cnt.blueprint.NumNodesPerLayer do
        cnt.blueprint.EdgeMap[1][i] = {}
        -- bias term
        cnt.blueprint.EdgeMap[1][i][1] = {Controller.CharToEdge(snip:sub(snipIndex,snipIndex))}
        snipIndex = snipIndex + 1

        -- input edges
        for y = 1,cnt.blueprint.NumInputs do
            cnt.blueprint.EdgeMap[1][i][1][y + 1] = Controller.CharToEdge(snip:sub(snipIndex,snipIndex))
            snipIndex = snipIndex + 1
        end

        -- inter edges
        cnt.blueprint.EdgeMap[1][i][2] = {}
        for y = 1,cnt.blueprint.NumNodesPerLayer do
            cnt.blueprint.EdgeMap[1][i][2][y] = Controller.CharToEdge(snip:sub(snipIndex,snipIndex))
            snipIndex = snipIndex + 1
        end
    end

    -- count the number of inner layer connections
    for i = 2,cnt.blueprint.NumInnerLayers do
        cnt.blueprint.EdgeMap[i] = {}

        for j = 1,cnt.blueprint.NumNodesPerLayer do
            --                                bias
            cnt.blueprint.EdgeMap[i][j][1] = {Controller.CharToEdge(snip:sub(snipIndex,snipIndex))}
            snipIndex = snipIndex + 1
            
            -- "upper" pass down edges (feed forward)
            for k = 1,cnt.blueprint.NumNodesPerLayer do
                cnt.blueprint.EdgeMap[i][j][1][k + 1] = Controller.CharToEdge(snip:sub(snipIndex,snipIndex))
                snipIndex = snipIndex + 1
            end

            -- "across" edges
            cnt.blueprint.EdgeMap[i][j][2] = {}
            for k = 1,cnt.blueprint.NumNodesPerLayer do
                cnt.blueprint.EdgeMap[i][j][2][k] = Controller.CharToEdge(snip:sub(snipIndex,snipIndex))
                snipIndex = snipIndex + 1
            end
        end
    end

    -- finally count the number of output connections
    --                                                 bias    nodes in a layer
    cnt.blueprint.EdgeMap[cnt.blueprint.NumInnerLayers + 1] = {}
    
    for i = 1,cnt.blueprint.NumOutputs do
        cnt.blueprint.EdgeMap[cnt.blueprint.NumInnerLayers+1][i] = {}
        -- bias term
        cnt.blueprint.EdgeMap[cnt.blueprint.NumInnerLayers+1][i][1] = {Controller.CharToEdge(snip:sub(snipIndex,snipIndex))}
        snipIndex = snipIndex + 1

        for j = 1,cnt.blueprint.NumNodesPerLayer do
            cnt.blueprint.EdgeMap[cnt.blueprint.NumInnerLayers+1][i][1][j] = Controller.CharToEdge(snip:sub(snipIndex,snipIndex))
            snipIndex = snipIndex + 1
        end
    end

    -- construct actual brain
    cnt.brain = gGame.Brain.new(cnt.blueprint)
    cnt.X = 0
    cnt.Y = 0
    gGame.Sprites.Add(cnt)

    cnt.body    = love.physics.newBody(gGame.World, cnt.X, cnt.Y, "dynamic")
    cnt.shape   = love.physics.newCircleShape(16)
    cnt.fixture = love.physics.newFixture(cnt.body, cnt.shape)
    cnt.fixture:setUserData(cnt) -- allow context to be passed through
    
    gGame.Entities.Add(cnt)

    return cnt
end

Controller.GetSnipLengthUsed = function(self)
    brainSnipsRequired =  self.blueprint.NumNodesPerLayer * (1 + self.blueprint.NumInputs + self.blueprint.NumNodesPerLayer) -- first inner layer
                        + self.blueprint.NumInnerLayers * (1 + 2 * self.blueprint.NumNodesPerLayer)                -- inner layers
                        + self.blueprint.NumOutputs * (1 + self.blueprint.NumNodesPerLayer)                        -- output layer
    
    return brainSnipsRequired + 4
end

Controller.TakeDamage = function (self, dmg)
    self.health = self.health - dmg

    if self.health <= 0 then
        self.isDead = true
    end
end

Controller.IsDead = function(self)
    return self.isDead
end

Controller.Heal = function(self, hp)
    self.health = self.health + hp
end

Controller.SetPosition = function (self, x, y)
    self.X = x
    self.Y = y

    self.body:setPosition(x, y)
end

Controller.Load = function (self)
    brainImage = brainImage or love.graphics.newImage("imgs/brain.png")
    self.image = brainImage
end

Controller.Update = function(self, dt)
    x, y = self.body:getPosition()
    self.X = x
    self.Y = y
end

controllerMeta.__index             = controllerMeta
controllerMeta.TakeDamage          = Controller.TakeDamage
controllerMeta.IsDead              = Controller.IsDead
controllerMeta.Heal                = Controller.Heal
controllerMeta.GetSnipLengthNeeded = Controller.GetSnipLengthNeeded
controllerMeta.GetSnipLengthUsed   = Controller.GetSnipLengthUsed
controllerMeta.SetPosition         = Controller.SetPosition
controllerMeta.Load                = Controller.Load
controllerMeta.Update              = Controller.Update

return Controller
