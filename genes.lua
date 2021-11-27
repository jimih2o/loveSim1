Genes = {
    DefaultLength = 5,
}
local genesMeta = {}

Genes.new = function (sequenceLength)
    local genes = {
        len = sequenceLength or Genes.DefaultLength
    }
    setmetatable(genes, genesMeta)

    genes.code = Genes.GenerateRandomSequence(genes.len)

    return genes
end

Genes.FromString = function(sequence)
    local gene = Genes.new(sequence:len())

    for i = 1,gene.len do
        gene.code[i] = sequence:sub(i,i)
    end

    return gene
end

Genes.GenerateRandomSequence = function(count)
    local code = {}
    for i = 1,count do
        code[i] = string.char(math.random(65, 90))
    end
    return code
end

Genes.Mutate = function(self)
    local num = math.random(1, self.len)

    local c = string.byte(self.code[num]) + math.random(-1, 1)
    if c > 90 then
        c = 65
    elseif c < 65 then
        c = 90
    end

    self.code[num] = string.char(c)
end

Genes.Clone = function(self)
    local clone = Genes.new(self.len)
    
    for i, c in ipairs(self.code) do
        clone.code[i] = c
    end

    return clone
end

Genes.Mate = function(self, other)
    local newLen = math.ceil(0.5 * (self.len + other.len))
    local child = Genes.new(newLen)

    for i,_ in ipairs(child.code) do
        if i > self.len then
            child.code[i] = other.code[i]
        elseif i > other.len then
            child.code[i] = self.code[i]
        else
            local choice = math.random(1, 2)
            if choice == 1 then
                child.code[i] = self.code[i]
            else
                child.code[i] = other.code[i]
            end
        end
    end

    return child
end

Genes.tostring = function(self) 
    local str = ""
    
    for _,c in ipairs(self.code) do
        str = str .. c
    end

    return str
end

Genes.Code = function(self)
    return self.code
end

Genes.Length = function(self)
    return self.len
end

Genes.len = function(self)
    return self.len
end

genesMeta.__index    = genesMeta
genesMeta.Mutate     = Genes.Mutate
genesMeta.Clone      = Genes.Clone
genesMeta.Mate       = Genes.Mate
genesMeta.Code       = Genes.Code
genesMeta.Length     = Genes.Length
genesMeta.len        = Genes.len
genesMeta.__tostring = Genes.tostring

return Genes
