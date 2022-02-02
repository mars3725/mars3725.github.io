Shape = {}
function Shape:new (x, y, color, type)
    local shape = {}
    setmetatable(shape, self)
    self.__index = self
    shape.x = x
    shape.y = y
    shape.color = color
    shape.type = type
    shape.alpha = 1
    --flux.to(shape, 0.5, {alpha = 1})
    return shape
end

function Shape:draw()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
    if self.type == 'triangle' then
        love.graphics.polygon("fill",
                self.x * 100 - 20, self.y * 100 + 20,
                self.x * 100, self.y * 100 - 20,
                self.x * 100 + 20, self.y * 100 + 20)
    elseif self.type == 'circle' then
        love.graphics.circle("fill", self.x * 100, self.y * 100, 20)
    elseif self.type == 'square' then
        love.graphics.rectangle("fill", self.x * 100 - 20, self.y * 100 - 20, 40, 40)
    end

    love.graphics.setLineWidth(2)
    love.graphics.setColor(0, 0, 0, self.alpha)
    if self.type == 'triangle' then
        love.graphics.polygon("line",
                self.x * 100 - 20, self.y * 100 + 20,
                self.x * 100, self.y * 100 - 20,
                self.x * 100 + 20, self.y * 100 + 20)
    elseif self.type == 'circle' then
        love.graphics.circle("line", self.x * 100, self.y * 100, 20, 250)
    elseif self.type == 'square' then
        love.graphics.rectangle("line", self.x * 100 - 20, self.y * 100 - 20, 40, 40)
    end
end