Collision = {}
Collision.all = {}
Collision.num = 1

Collision.Add = function (obj)
    if not obj.CollidesWidth or not obj.HandleCollision then
        print("Could not create a valid collidable object!")
        return nil
    end

    Collision.all[Collision.num] = obj
    Collision.num = Collision.num + 1

    return Collision.num - 1
end

Collision.HandleCollisions = function(dt)
    for i = 1,Collision.num do
        for j = (i + 1),(Collision.num - 1) do
            if Collision.all[i]:CollidesWidth(Collision.all[j], dt) then
                Collision.all[i]:HandleCollision(Collision.all[j], dt)
            end
        end
    end
end

Collision.PointInCircle = function(pX, pY, cX, cY, r)
    dX = (cX - pX)
    dY = (cY - pY)

    return dX*dX + dY*dY <= r*r
end

Collision.PointInBox = function(pX, pY, bX, bY, w, h)
    -- is x of point within box boundaries?
    if pX < bX or pX > bX + w then
        return false
    end

    -- is y of point within box boundaries?
    if pY < bY or pY > bY + h then
        return false
    end

    -- within x and y boundaries
    return true
end

Collision.ResolveCircles = function (a, b, dt)
    return (a.X - b.X) * (a.X - b.X) + 
           (a.Y - b.Y) * (a.Y - b.Y) <= 
           (a.radius + b.radius) * (a.radius + b.radius)
end

Collision.ResolveCircleBox = function(circle, box, dt)
    nX = math.max( box.X, math.min(circle.X, box.X + box.width) )
    nY = math.max( box.Y, math.min(circle.Y, box.Y + box.height))

    return Collision.PointInCircle(nX, nY, circle.X, circle.Y, circle.radius)
end

Collision.ResolveBoxes = function(a, b, dt)
    return false
end

-- try to resolve through built in resolution algorithms
Collision.TryResolveCollides = function(a, b, dt)
    if a.isCirle then
        if b.isCircle then
            return Collision.ResolveCircles(a, b, dt)
        elseif b.isBox then
            return Collision.ResolveCircleBox(a, b, dt)
        end
    elseif a.isBox then
        if b.isCircle then
            -- swap inputs for circle<->box here
            return Collision.ResolveCircleBox(b, a, dt)
        elseif b.isBox then
            return Collision.ResolveBoxes(a, b, dt)
        end
    end
    
    return false
end

return Collision
