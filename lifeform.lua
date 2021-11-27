LifeForm = {}
local lifeFormMeta = {}

LifeForm.SnipType = function(snip)
    local snipLut = {
        ['A'] = "brain",
        ['B'] = "sensor",
        ['C'] = "mouth",
        ['D'] = "mouth",
        ['E'] = "mouth",
        ['F'] = "mouth",
        ['G'] = "stomach",
        ['H'] = "stomach",
        ['I'] = "stomach",
        ['J'] = "brain",
        ['K'] = "block",
        ['L'] = "emitter",
        ['M'] = "emitter",
        ['N'] = "block",
        ['O'] = "emitter",
        ['P'] = "sex",
        ['Q'] = "sex",
        ['R'] = "sex",
        ['S'] = "emitter",
        ['T'] = "sex",
        ['U'] = "sex",
        ['V'] = "block",
        ['W'] = "mover",
        ['X'] = "mover",
        ['Y'] = "sensor",
        ['Z'] = "sensor"
    }

    return snipLut[snip]
end

LifeForm.NewBodyPartByName = function(bodyName, snip)
    if bodyName == "brain" then
        if gGame.Controller.ValidateSnip(snip) then
            return gGame.Controller.new(snip)
        else
            return nil
        end
    elseif bodyName == "sensor" then

    elseif bodyName == "mouth" then

    elseif bodyName == "stomach" then

    elseif bodyName == "block" then

    elseif bodyName == "emitter" then 

    elseif bodyName == "sex" then

    elseif bodyName == "mover" then

    else
        -- invalid body part name
        return nil
    end

    return nil
end

LifeForm.new = function (template)
    local lf = {
        isDead = false
    }
    setmetatable(lf, lifeFormMeta)

    -- configure based on template if provided
    if template then
        if template.useCode then
            lf.genes = gGame.Genes.FromString(template.geneticCode)
        else
            lf.genes = gGame.Genes.new(template.randomCodeLength)
        end 
    else
        lf.genes = gGame.Genes.new()
    end

    -- generate lifeform from genetic sequencing
    -- block 0 is always a controller
    if gGame.Controller.ValidateSnip(tostring(lf.genes)) == false then
        print("Error: Bad beginning snip to life form detected.")
        print("Error: birth terminated.")
        isDead  = true
    else
        lf.head = gGame.Controller.new(tostring(lf.genes))
        lf.body = {}

        remGenome = lf.head:GetSnipLengthUsed() + 1

        while remGenome <= lf.genes:Length() do
            trySnip = tostring(lf.genes):sub(remGenome, lf.genes:Length())

            snipType = LifeForm.SnipType(trySnip:sub(1,1))

            if snipType then
                numBodyParts = #lf.body
                lf.body[numBodyParts + 1] = LifeForm.NewBodyPartByName(snipType, trySnip:sub(2, trySnip:len()))
                if #lf.body > numBodyParts then
                    remGenome = remGenome + lf.body[#lf.body]:GetSnipLengthUsed() + 1
                else
                    -- couldn't construct, increment as garbage data
                    remGenome = remGenome + 1
                end
            else
                -- garbage DNA, skip
                remGenome = remGenome + 1
            end
        end
    end

    if template.position then
        lf.head:SetPosition(template.position.X, template.position.Y)

        -- for each body part: set position
    end

    return lf
end

lifeFormMeta.__index = lifeFormMeta

return LifeForm 
