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

Controller.new = function(snip)
    local cnt = {
        inputs = {},
        outputs = {}
    }
    setmetatable(cnt, controllerMeta)

    -- controller snip is primarily a compute node
    -- it is a direct encoding for the brain blueprint
    cnt.blueprint = {
        NumInnerLayers   = Controller.CharToCount(snip[1]),
        NumNodesPerLayer = Controller.CharToCount(snip[2]),
        NumInputs        = Controller.CharToCount(snip[3]),
        NumOutputs       = Controller.CharToCount(snip[4]),
        EdgeMap = {}
    }
    
    -- first count the number of edges in the first inner layer
    --                input edges                                             bias   inter-connection edges
    local snipIndex = 5

    cnt.blueprint.EdgeMap[1] = {}

    for i = 1,cnt.blueprint.NumNodesPerLayer do
        cnt.blueprint.EdgeMap[1][i] = {}
        -- bias term
        cnt.blueprint.EdgeMap[1][i][1] = {Controller.CharToEdge(snip[snipIndex])}
        snipIndex = snipIndex + 1

        -- input edges
        for y = 1,cnt.blueprint.NumInputs do
            cnt.blueprint.EdgeMap[1][i][1][y + 1] = Controller.CharToEdge(snip[snipIndex])
            snipIndex = snipIndex + 1
        end

        -- inter edges
        cnt.blueprint.EdgeMap[1][i][2] = {}
        for y = 1,cnt.blueprint.NumNodesPerLayer do
            cnt.blueprint.EdgeMap[1][i][2][y] = Controller.CharToEdge(snip[snipIndex])
            snipIndex = snipIndex + 1
        end
    end

    -- count the number of inner layer connections

    -- finally count the number of output connections
    --                                                 bias    nodes in a layer
    edgeTotal = edgeTotal + cnt.blueprint.NumOutputs * (1 + cnt.NumNodesPerLayer)

    return cnt
end


controllerMeta.__index = controllerMeta


return Controller
