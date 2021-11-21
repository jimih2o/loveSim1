sprites = {}
sprites.all = {}

sprites.Add = function (name, ent)
    -- validate ent
    if not ent.Load then
        print("Error, entity " + name + " does not have Load method.")
        return nil
    elseif not ent.X then
        print("Error, entity " + name + " missing X property")
        return nil
    elseif not ent.Y then
        print("Error, entity " + name + " missing Y property")
        return nil
    else 
        sprites.all[name] = ent
    end

    -- return entity as success indicator
    return ent
end

sprites.Load = function()
    for key, value in pairs(sprites.all) do
        value:Load()
    end
end

-- simply just draw the sprite collection
sprites.Draw = function ()
    for key, value in pairs(sprites.all) do 
        love.graphics.draw(value.image, value.X, value.Y)
    end
end

return sprites
