entities = {}
entities.ents = {}

entities.Add = function(ent)
    if not ent.Update then
        print("Error, entity " + name + " has no Update property.")
        return nil
    end

    entities.ents[#entities.ents + 1] = ent 
    return ent
end

entities.Update = function(dt)
    for _, ent in ipairs(entities.ents) do 
        ent:Update(dt)
    end
end

return entities
