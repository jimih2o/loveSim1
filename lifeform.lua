LifeForm = {}
local lifeFormMeta = {}

LifeForm.new = function (template)
    local lf = {
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

    return lf
end

lifeFormMeta.__index = lifeFormMeta

return LifeForm 
