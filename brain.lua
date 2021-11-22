Brain = {}
brainMeta = {}

--- construct a new brain
---@param blueprint table table of configuration settings:
--                        options are as follows...
--        blueprint.NumInnerLayers   == the total number of inner layers
--        blueprint.NumNodesPerLayer == the number of nodes per inner layer
--        blueprint.NumInputs        == the number of inputs to the brain
--        blueprint.NumOutputs       == the number of outputs to the brain
--        blueprint.EdgeMap          == a collection of lists describing the edge weights between nodes
--                        Example: 1 hidden layer, 2 nodes per layer, 3 inputs, 4 outputs
--                                 EdgeMap[1][1][1] => "upper" weights {bias, input1, input2, input3}
--                                 EdgeMap[1][1][2] => "inter" weights {self, node 2}
--                                 EdgeMap[1][2][1] => "upper" weights {bias, input1, input2, input3}
--                                 EdgeMap[1][2][2] => "inter" weights {node 1, self}
--                                 EdgeMap[2][1][1] => "upper" weights {bias, node 1, node 2}
--                                 EdgeMap[2][2][1] => "upper" weights {bias, node 1, node 2}
--                                 EdgeMap[2][3][1] => "upper" weights {bias, node 1, node 2}
--                                 EdgeMap[2][4][1] => "upper" weights {bias, node 1, node 2}
--                       Generally,
--                                 EdgeMap[layer][node index][upper/inter]
--                                 
---@return table
Brain.new = function(blueprint)
    local obj = {
        nodes = {},
        nodesPerLayer = blueprint.NumNodesPerLayer,
        innerLayers   = blueprint.NumInnerLayers,
        numInputs     = blueprint.NumInputs or 1,
        numOutputs    = blueprint.NumOutputs or 1,
        edges         = blueprint.EdgeMap
    }
    setmetatable(obj, brainMeta)

    -- construct the inner layers
    for i = 1,(blueprint.NumInnerLayers or 1) do
        obj.nodes[i] = {}
        for j = 1,(blueprint.NumNodesPerLayer or 1) do
            obj.nodes[i][j] = gGame.Node.new()
        end
    end

    -- construct the output layer
    obj.nodes[obj.innerLayers + 1] = {}
    for i = 1,obj.numOutputs do
        obj.nodes[obj.innerLayers + 1][i] = gGame.Node.new()
    end

    return obj
end

---
-- Given a set of inputs, compute a set of output action potentials.
--- 
Brain.Think = function(self, inputs)
    outputs = inputs -- initialize to inputs for base case

    -- for each layer
    --     create combined input list
    --     bias, upper inputs, transverse inputs 
    for i = 1,self.innerLayers do
        -- construct inputs
        feedForward = {1}

        for _, v in pairs(outputs) do
            table.insert(feedForward, v)
        end

        totalSize = #(feedForward) + self.nodesPerLayer
        -- get transverse inputs
        for j = (#(feedForward) + 1),totalSize do
            feedForward[j] = self.nodes[i][j - #(feedForward)]:GetPriorOutput()
        end

        -- construct weights and find output
        current = {}
        for j = 1,self.nodesPerLayer do
            weights = self.edges[i][j][1]

            for _, v in pairs(self.edges[i][j][2]) do
                table.insert(weights, v)
            end
            
            current[j] = self.nodes[i][j]:Compute(feedForward, weights)
        end

        outputs = current
    end

    -- apply final set of nodes for outputs
    current = {}
    for j = 1,self.numOutputs do
        table.insert(outputs, 1, 1.0)
        current[j] = self.nodes[self.innerLayers + 1][j]:Compute(outputs, self.edges[self.innerLayers + 1][j][1])
    end
    outputs = current

    return outputs
end

brainMeta.__index = brainMeta
brainMeta.Think = Brain.Think

return Brain
