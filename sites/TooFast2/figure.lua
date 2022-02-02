function Figure:new (x, y, color, size)
    local figure = {}
    setmetatable(figure, self)
    self.__index = self
    figure.x = x
    figure.y = y
    figure.color = color

    figure.transit = false
    figure.blocks = { Block:new(0, 0, color) }

    local keys = {}
    for k in pairs(directions) do
        table.insert(keys, k)
    end

    -- for i=1,size do
    --    placed = false

    --    repeat
    --       anchor = figure.blocks[love.math.random(#figure.blocks)]
    --       i = 0

    --       local dir = keys[love.math.random(#keys)]
    --       newX = anchor.x + directionTypes[dir][1]
    --       newY = anchor.y + directionTypes[dir][2]

    --       for i,v in pairs(figure.blocks) do
    --          if v.x == newX and v.y == newY then

    --       end

    --       repeat


    --          for k,v in pairs(figure.blocks) do

    --             if grid:getTile(newX, newY) == nil then
    --                grid:addTile(newX, newY)
    --                placed = true
    --                break
    --             else i = i + 1 end

    --          until i > 4


    --       until placed

    --       return grid
    --    end
    return figure
end