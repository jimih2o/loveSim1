Factory = {}

Factory.Register = function (objName, newFn)
    Factory[objName] = newFn
end

Factory.Spawn = function(objName, ...)
    return Factory[objName].new(...)
end

return Factory
