entities = {}
entities.ents = {}

entities.Add = function(name, ent)
    if not ent.Update then
        print("Error, entity " + name + " has no Update property.")
        return nil
    end

    entities.ents[name] = ent 
    return ent
end

entities.Get = function(name)
    return entities.ents[name]
end

entities.Update = function(dt)
    for key, value in pairs(entities.ents) do 
        value:Update(dt)
    end
end

return entities
