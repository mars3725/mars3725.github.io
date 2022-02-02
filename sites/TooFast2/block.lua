Block = {}
function Block:new (x, y, color)
    local block = {}
    setmetatable(block, self)
    self.__index = self
    block.x = x
    block.y = y
    block.color = color
    block.alpha = 1

    block.transit = nil
    rand = love.math.random(5)
    if rand == 1 then
        block.shape = nil
        block.collected = true
    else
        block.shape = shapeTypes[love.math.random(#shapeTypes)]
        block.collected = false
    end
    return block
end

function Block:move (direction, animate)
    if self:canMove(direction) == false then
        return false
    else
        for i, v in ipairs(blocks) do
            if v.x == self.x + directions[direction][1] and v.y == self.y + directions[direction][2] then
                didClearOccupying = blocks[i]:move(direction, animate)
                if didClearOccupying then
                    break
                else
                    return false
                end
            end
        end
    end
    movement = { x = self.x + directions[direction][1], y = self.y + directions[direction][2] }

    if animate then
        if self.transit == nil then
            self.transit = direction
            flux.to(self, 0.1, movement)
                :oncomplete(function()
                self.transit = nil
                self:didMove()
            end)
        end
    else
        self.transit = direction
        self.x = movement.x
        self.y = movement.y
        self.transit = nil
        self:didMove()
    end

    return true
end

function Block:canMove(dir)
    canHold = false
    target = grid:at(self.x + directions[dir][1], self.y + directions[dir][2])

    if target then
        if target.type == 'base' then
            canHold = true
        end

        if target.type == 'sink' and self.collected then
            canHold = true
        end
    end
    return canHold
end

function Block:didMove()
    for i, v in ipairs(shapes) do
        for j, w in ipairs(blocks) do
            if v.x == w.x and v.y == w.y then
                if w.shape == v.type and w.color == v.color then
                    self.collected = true
                end
                table.remove(shapes, i)
            end
        end
    end

    if grid:at(self.x, self.y) and grid:at(self.x, self.y).type == 'sink' then
        for i, v in ipairs(blocks) do
            if v == self then
                table.remove(blocks, i)
                if #blocks == 0 then
                    state = 'finished'
                end
                break
            end
        end
    end

    for i, v in ipairs(grid.tiles) do
        for j, w in ipairs(blocks) do
            if v.x == w.x and v.y == w.y then
                v.history = w
                break
            end
        end
    end
end

function Block:draw(selected)
    love.graphics.stencil(function()
        for k, v in pairs(grid.taps) do
            love.graphics.rectangle("fill", v.x * 100 - 50, v.y * 100 - 50, 100, 100)
        end

        for k, v in pairs(grid.sinks) do
            love.graphics.rectangle("fill", v.x * 100 - 50, v.y * 100 - 50, 100, 100)
        end

        if not self.collected then
            if self.shape == 'triangle' then
                love.graphics.polygon("fill",
                        self.x * 100 - 20, self.y * 100 + 20,
                        self.x * 100, self.y * 100 - 20,
                        self.x * 100 + 20, self.y * 100 + 20)
            elseif self.shape == 'circle' then
                love.graphics.circle("fill", self.x * 100, self.y * 100, 20)
            elseif self.shape == 'square' then
                love.graphics.rectangle("fill", self.x * 100 - 20, self.y * 100 - 20, 40, 40)
            end
        end
    end)

    love.graphics.setLineWidth(5)
    lineWidth = love.graphics.getLineWidth()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], alpha)

    love.graphics.setStencilTest("less", 1)
    love.graphics.rectangle("fill", self.x * 100 - 50 + lineWidth / 2, self.y * 100 - 50 + lineWidth / 2, 100 - lineWidth, 100 - lineWidth)

    love.graphics.setLineWidth(2)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", self.x * 100 - 50 + lineWidth / 2, self.y * 100 - 50 + lineWidth / 2, 100 - lineWidth, 100 - lineWidth)

    love.graphics.stencil(function()
        for k, v in pairs(grid.taps) do
            love.graphics.rectangle("fill", v.x * 100 - 50, v.y * 100 - 50, 100, 100)
        end

        for k, v in pairs(grid.sinks) do
            love.graphics.rectangle("fill", v.x * 100 - 50, v.y * 100 - 50, 100, 100)
        end
    end)
    love.graphics.setStencilTest("less", 1)
    if self.shape == 'triangle' then
        love.graphics.polygon("line",
                self.x * 100 - 20, self.y * 100 + 20,
                self.x * 100, self.y * 100 - 20,
                self.x * 100 + 20, self.y * 100 + 20)
    elseif self.shape == 'circle' then
        love.graphics.circle("line", self.x * 100, self.y * 100, 20, 250)
    elseif self.shape == 'square' then
        love.graphics.rectangle("line", self.x * 100 - 20, self.y * 100 - 20, 40, 40)
    end

    if not touchControls and selected then
        love.graphics.setLineWidth(10)
        lineWidth = love.graphics.getLineWidth()
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.rectangle("line", self.x * 100 - 50 + lineWidth, self.y * 100 - 50 + lineWidth, 100 - lineWidth * 2, 100 - lineWidth * 2)
    end

    love.graphics.setStencilTest()
end