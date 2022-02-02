Grid = {}
function Grid:new (x, y)
    local grid = {}
    setmetatable(grid, self)
    self.__index = self
    grid.x = x
    grid.y = y
    grid.tiles = {}
    grid.taps = {}
    grid.sinks = {}
    grid.alpha = 1

    return grid
end

Tile = {}
function Tile:new (x, y)
    local tile = {}
    setmetatable(tile, self)
    self.__index = self
    tile.x = x
    tile.y = y
    tile.type = 'base'
    tile.adjacent = {up = nil, down = nil, left = nil, right = nil}
    tile.history = nil

    for i, v in pairs(directions) do
        for j, w in ipairs(grid.tiles) do
            if w.x == x + v[1] and w.y == y + v[2] then
                tile.adjacent[i] = w
                if i == 'up' then
                    op = 'down'
                elseif i =='down' then
                    op = 'up'
                elseif i =='left' then
                    op = 'right'
                elseif i =='right' then
                    op = 'left'
                end
                w.adjacent[op] = tile
            end
        end
    end

    return tile
end

Sink = {}
function Sink:new (x, y)
    local sink = {}
    setmetatable(sink, self)
    self.__index = self
    sink.x = x
    sink.y = y
    sink.type = 'sink'
    sink.adjacent = {up = nil, down = nil, left = nil, right = nil}

    found = false
    for i, v in pairs(directions) do
        for j, w in ipairs(grid.tiles) do
            if found == false and w.x == x + v[1] and w.y == y + v[2] then
                sink.adjacent[i] = w
                if i == 'up' then
                    op = 'down'
                elseif i =='down' then
                    op = 'up'
                elseif i =='left' then
                    op = 'right'
                elseif i =='right' then
                    op = 'left'
                end
                w.adjacent[op] = sink
                found = true
            end
        end
    end

    return sink
end

function Grid:add (type)
    repeat
        anchor = grid.tiles[love.math.random(#grid.tiles)]

        dirs = {'up', 'down', 'left', 'right'}
        dir = dirs[love.math.random(#dirs)]

        i = 0
        while anchor.adjacent[dir] ~= nil do
            anchor = anchor.adjacent[dir]
            i = i+1
        end
    until i < #grid.tiles/2

    if type == 'sink' then
        sink = Sink:new(anchor.x + directions[dir][1], anchor.y + directions[dir][2], dir)
        table.insert(self.sinks, sink)
    elseif type == 'base' then
        tile = Tile:new(anchor.x + directions[dir][1], anchor.y + directions[dir][2])
        table.insert(self.tiles, tile)
    end
end

function Grid:getBounds()
    bounds = { { 0, 0 }, { 0, 0 } }
    for i, v in ipairs(self.tiles) do
        bounds[1][1] = math.min(bounds[1][1], v.x)
        bounds[1][2] = math.max(bounds[1][2], v.x)
        bounds[2][1] = math.min(bounds[2][1], v.y)
        bounds[2][2] = math.max(bounds[2][2], v.y)
    end
    return bounds
end

function Grid:at(x,y)
    for i, v in ipairs(self.tiles) do
        if v.x == x and v.y == y then return v end
    end

    for i, v in ipairs(self.sinks) do
        if v.x == x and v.y == y then return v end
    end

    return nil
end

function Grid:getTileType(x, y)
    for i, v in pairs(self.tiles) do
        if v.x == x and v.y == y then
            return 'base'
        end
    end

    for i, v in pairs(self.taps) do
        if v.x == x and v.y == y then
            return 'tap'
        end
    end

    for i, v in pairs(self.sinks) do
        if v.x == x and v.y == y then
            return 'sink'
        end
    end

    return nil
end

function Grid:drawInterior()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setLineWidth(0.025)
    if debug then
        love.graphics.setColor(0, 0, 0)
        for i, v in ipairs(grid.tiles) do
            love.graphics.print(v.x .. ',' .. v.y, v.x * 100 - 20, v.y * 100, 0, 1.5)
            for j, w in pairs(v.adjacent) do
                love.graphics.line(v.x * 100 - 20, v.y * 100, w.x * 100 - 20, w.y * 100)
            end
        end
    end
end

function Grid:drawBoundary()
    love.graphics.setColor(0.25, 0.25, 0.25, self.alpha)
    love.graphics.setLineWidth(10)
    love.graphics.setLineJoin('bevel')

    for i, v in ipairs(grid.tiles) do
        points = {}
        if self:getTileType(v.x + directions['up'][1], v.y + directions['up'][2]) ~= 'base' then
            if self:getTileType(v.x + directions['right'][1], v.y + directions['right'][2]) ~= 'base' then
                love.graphics.line(
                        v.x * 100 - 50, v.y * 100 - 50,
                        v.x * 100 + 50, v.y * 100 - 50,
                        v.x * 100 + 50, v.y * 100 + 50)
            else
                love.graphics.line(
                        v.x * 100 - 50, v.y * 100 - 50,
                        v.x * 100 + 50, v.y * 100 - 50)
            end
        end

        if self:getTileType(v.x + directions['right'][1], v.y + directions['right'][2]) ~= 'base' then
            if self:getTileType(v.x + directions['down'][1], v.y + directions['down'][2]) ~= 'base' then
                love.graphics.line(
                        v.x * 100 + 50, v.y * 100 - 50,
                        v.x * 100 + 50, v.y * 100 + 50,
                        v.x * 100 - 50, v.y * 100 + 50)
            else
                love.graphics.line(
                        v.x * 100 + 50, v.y * 100 - 50,
                        v.x * 100 + 50, v.y * 100 + 50)
            end
        end

        if self:getTileType(v.x + directions['down'][1], v.y + directions['down'][2]) ~= 'base' then
            if self:getTileType(v.x + directions['left'][1], v.y + directions['left'][2]) ~= 'base' then
                love.graphics.line(
                        v.x * 100 + 50, v.y * 100 + 50,
                        v.x * 100 - 50, v.y * 100 + 50,
                        v.x * 100 - 50, v.y * 100 - 50)
            else
                love.graphics.line(
                        v.x * 100 + 50, v.y * 100 + 50,
                        v.x * 100 - 50, v.y * 100 + 50)
            end
        end

        if self:getTileType(v.x + directions['left'][1], v.y + directions['left'][2]) ~= 'base' then
            if self:getTileType(v.x + directions['up'][1], v.y + directions['up'][2]) ~= 'base' then
                love.graphics.line(
                        v.x * 100 - 50, v.y * 100 + 50,
                        v.x * 100 - 50, v.y * 100 - 50,
                        v.x * 100 + 50, v.y * 100 - 50)
            else
                love.graphics.line(
                        v.x * 100 - 50, v.y * 100 + 50,
                        v.x * 100 - 50, v.y * 100 - 50)
            end
        end
    end

    for i, v in ipairs(grid.tiles) do
        if grid:getTileType(v.x,v.y-1) ~= 'base' then --up
            if grid:getTileType(v.x+1,v.y) ~= 'base' or grid:getTileType(v.x+1,v.y-1) == 'base' then --right
                love.graphics.circle('fill', v.x*100 + 50, v.y*100 - 50, 5, 250)
            end

            if grid:getTileType(v.x-1,v.y) ~= 'base' or grid:getTileType(v.x-1,v.y-1) == 'base' then --left
                love.graphics.circle('fill', v.x*100 - 50, v.y*100 - 50, 5, 250)
            end
        end

        if grid:getTileType(v.x,v.y+1) ~= 'base' then --down
            if grid:getTileType(v.x+1,v.y) ~= 'base' or grid:getTileType(v.x+1,v.y+1) == 'base' then --right
                love.graphics.circle('fill', v.x*100 + 50, v.y*100 + 50, 5, 250)
            end

            if grid:getTileType(v.x-1,v.y) ~= 'base' or grid:getTileType(v.x-1,v.y+1) == 'base' then --left
                love.graphics.circle('fill', v.x*100 - 50, v.y*100 + 50, 5, 250)
            end
        end
    end

    for i, v in ipairs(grid.sinks) do
        for j, w in pairs(v.adjacent) do
            if (j == 'up') then
                rot = math.rad(90)
            elseif (j == 'down') then
                rot = math.rad(270)
            elseif (j == 'left') then
                rot = math.rad(0)
            elseif (j == 'right') then
                rot = math.rad(180)
            end
        end

        love.graphics.push()
        love.graphics.translate(v.x * 100, v.y * 100)
        love.graphics.rotate(rot)
        love.graphics.line(-50, 0, 0, 0)
        love.graphics.line(0, 0, -15, -15)
        love.graphics.line(0, 0, -15, 15)
        love.graphics.circle('fill', 0, 0, 5, 250)
        love.graphics.pop()
    end
end