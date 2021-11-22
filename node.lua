Node = {}
local nodeMeta = {}

Node.new = function ()
    local obj = {
        prior   = 0.5,
        current = 0.5,
        isNode  = true
    }
    setmetatable(obj, nodeMeta)

    return obj
end

Node.ActivationFunction = function(x)
    return 1.0 / (1.0 + math.exp(-x))
end

Node.GetPriorOutput = function(self)
    return self.prior
end

Node.Compute = function(self, inputs, weights)
    local x = 0

    for i = 1,#(inputs) do
        x = x + inputs[i] * weights[i]
    end

    self.prior = self.current
    self.current = Node.ActivationFunction(x)

    return self.current
end

Node.GetOutput = function(self)
    return self.current
end

nodeMeta.__index = nodeMeta
nodeMeta.GetPriorOutput = Node.GetPriorOutput
nodeMeta.Compute        = Node.Compute
nodeMeta.GetOutput      = Node.GetOutput

return Node
