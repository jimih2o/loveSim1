Camera = {
    X = 0,
    Y = 0,
    maxObjectSize = 32*10, -- 10 tiles across max 
}

function Camera.Compute()
    Camera.minX = Camera.X - Camera.maxObjectSize
    Camera.minY = Camera.Y - Camera.maxObjectSize
    Camera.maxX = Camera.X + Camera.maxObjectSize + love.graphics.getWidth()
    Camera.maxY = Camera.Y + Camera.maxObjectSize + love.graphics.getHeight()
end

function Camera.GetX()
    return Camera.X
end

function Camera.GetY()
    return Camera.Y 
end

function Camera.GetPos()
    return {X = Camera.X, Y = Camera.Y}
end

function Camera.LookAt(X, Y)
    Camera.X = X
    Camera.Y = Y

    -- recompute bounding box boundaries
    Camera.Compute()
end

function Camera.Sees(X, Y)
    return (X > Camera.minX or X < Camera.maxX) and
           (Y > Camera.minY or Y < Camera.maxY)
end

return Camera
