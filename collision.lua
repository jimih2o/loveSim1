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

return Collision
