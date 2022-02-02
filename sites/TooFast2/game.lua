grid = {}
blocks = {}
shapes = {}
selected = nil
moves = 0

tileTicker = love.math.random(10, 20)
shapeTicker = love.math.random(1, 3)
tt = 0

function loadGame()
    grid = {}
    blocks = {}
    shapes = {}
    touches = {}
    selected = nil
    moves = 0
    compliment = compliments[love.math.random(#compliments)]

    if difficulty == 'easy' then
        numTiles = 10
        numBlocks = 5
        numSteps = 10
    elseif difficulty == 'medium' then
        numTiles = 20
        numBlocks = 10
        numSteps = 10
    elseif difficulty == 'hard' then
        numTiles = 50
        numBlocks = 25
        numSteps = 10
    end

    grid = Grid:new()
    table.insert(grid.tiles, Tile:new(0, 0))
    for i = 1, numTiles do
        grid:add('base')
    end

    bounds = grid:getBounds()

    cameraLoc[1] = love.graphics.getWidth()/2 - ((bounds[1][2] + bounds[1][1])*100)/2
    cameraLoc[2] = love.graphics.getHeight()/2 - ((bounds[2][2] + bounds[2][1])*100)/2

    grid:add('sink')

    for i = 1, numBlocks do
        local color = colorTypes[love.math.random(#colorTypes)]
        block = Block:new(grid.sinks[1].x, grid.sinks[1].y, color)
        table.insert(blocks, block)

        for j = 1, numSteps do
            step()
        end
    end

    placeShapes()

    for i = #blocks, 1, -1 do
        if grid:at(blocks[i].x, blocks[i].y).type == 'sink' then
            table.remove(blocks, i)
        end
    end

    --fadeIn()

    state = 'playing'
end

function fadeIn()
    grid.alpha = 0
    flux.to(grid, 0.25, {alpha = 1})

    for i, v in ipairs(blocks) do
        v.alpha = 0
        flux.to(v, 0.25, {alpha = 1})
    end

    for i, v in ipairs(shapes) do
        v.alpha = 0
        flux.to(v, 0.25, {alpha = 1})
    end
end

function step()
    block = blocks[love.math.random(#blocks)]
    loc = grid:at(block.x, block.y)

    dirs = {}
    for i, v in pairs(loc.adjacent) do
        if loc.adjacent[i].type == 'base' then
            table.insert(dirs, i)
        end
    end

    dir = dirs[love.math.random(#dirs)]
    block:move(dir, false)
end

function placeShapes()
    invalid = {}

    for i = #blocks, 1, -1 do
        if blocks[i].shape then
            color = blocks[i].color
            shape = blocks[i].shape
            options = {}

            for j, w in ipairs(grid.tiles) do
                if w.history == nil or (w.history.shape == shape and w.history.color == color) then
                    unoccupied = true
                    for k, z in ipairs(blocks) do
                        if z.x == w.x and z.y == w.y then
                            unoccupied = false
                        end
                    end

                    for k, z in ipairs(shapes) do
                        if z.x == w.x and z.y == w.y then
                            unoccupied = false
                        end
                    end

                    if unoccupied then
                        table.insert(options, {x = w.x, y = w.y})
                        break
                    end
                end
            end

            if #options == 0 or grid:at(blocks[i].x, blocks[i].y).type == 'sink' then
                table.remove(blocks, i)
            else
                loc = options[math.random(#options)]
                shape = Shape:new(loc.x, loc.y, color, shape)
                table.insert(shapes, shape)
            end
        end
    end
end

function updateGame(dt)
    flux.update(dt)
    tt = tt + dt
    updateKeyboardControls()
end

function drawUI()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(4)

    love.graphics.push()
    love.graphics.translate(50, love.graphics.getHeight() - 50)
    love.graphics.line(30, 0, 0, 0)
    love.graphics.line(0, 0, 10, -10)
    love.graphics.line(0, 0, 10, 10)
    love.graphics.circle('fill', 0, 0, 2)
    love.graphics.rectangle('line', -5, -20, 40, 40)
    love.graphics.pop()

    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth() - 90, love.graphics.getHeight() - 50)
    love.graphics.circle('line', 12, 0, 12, 250)
    love.graphics.line(24, 2, 16, -3)
    love.graphics.line(24, 2, 31, -5)
    love.graphics.rectangle('line', -5, -20, 40, 40)
    love.graphics.pop()

    love.graphics.printf(moves, FontLg, love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 15, 300, 'center')

    if state == 'finished' then
        love.graphics.printf(compliment, FontLg, love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 150, 300, 'center')
    end
end

function drawGame()
    love.graphics.push()
    love.graphics.translate(cameraLoc[1], cameraLoc[2])
    love.graphics.scale(scale)

    love.graphics.setLineStyle("smooth")

    grid:drawInterior()

    for i, v in ipairs(shapes) do
        v:draw()
    end

    for i, v in ipairs(blocks) do
        v:draw(selected == i)
    end

    grid:drawBoundary()

    love.graphics.pop()

    drawUI()
end

function addShape()
    if #blocks ~= 0 then
        local color = blocks[love.math.random(#blocks)].color --colorTypes[love.math.random(#colorTypes)]
        local shape = blocks[love.math.random(#blocks)].shape --shapeTypes[love.math.random(#shapeTypes)]

        if color ~= nil and shape ~= nil then
            i = 0
            repeat
                anchor = grid.tiles[math.random(#grid.tiles)]
                clear = true
                for i, v in ipairs(blocks) do
                    if v.x == anchor.x and v.y == anchor.y then
                        clear = false
                        break
                    end
                end
                for i, v in ipairs(shapes) do
                    if v.x == anchor.x and v.y == anchor.y then
                        clear = false
                        break
                    end
                end
                i = i+1
            until clear or i == #blocks

            if clear then
                shape = Shape:new(anchor.x, anchor.y, color, shape)
                table.insert(shapes, shape)
            end
        end
    end
end