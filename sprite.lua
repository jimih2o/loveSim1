sprites = {}
sprites.all = {}

sprites.Add = function (ent)
    -- validate ent
    if not ent.Load then
        print("Error, sprite does not have Load method.")
        return nil
    elseif not ent.X then
        print("Error, sprite missing X property")
        return nil
    elseif not ent.Y then
        print("Error, sprite  missing Y property")
        return nil
    else 
        sprites.all[#sprites.all + 1] = ent
    end

    -- return entity as success indicator
    return ent
end

sprites.Load = function()
    for _,sprite in ipairs(sprites.all) do
        sprite:Load()
    end
end

-- simply just draw the sprite collection
sprites.Draw = function ()
    local draw = love.graphics.draw
    local sees = gGame.Camera.Sees
    for _,sprite in ipairs(sprites.all) do 
        if sees(sprite.X, sprite.Y) then
            draw(sprite.image, sprite.X, sprite.Y)
        end
    end
end

return sprites
