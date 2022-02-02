scale = 0.5
cameraLoc = { 0, 0 }

touchControls = true
touches = {}

function love.keypressed(key, unicode)
    if not touchControls then
        if selected ~= nil and blocks[selected].transit == nil then
            if key == 'up' or key == 'down' or key == 'left' or key == 'right' then
                if blocks[selected]:move(key, true) then
                    moves = moves+1
                end
            end
        end
    end
end

function updateKeyboardControls()
    if not touchControls then
        mx, my = love.mouse.getPosition()
        mx = (mx - cameraLoc[1]) / scale
        my = (my - cameraLoc[2]) / scale

        if love.mouse.isDown(1) then
            x = math.ceil((mx - 50) / 100)
            y = math.ceil((my - 50) / 100)

            for i, v in ipairs(blocks) do
                if v.x == x and v.y == y then
                    selected = i
                    break
                end
                selected = nil
            end
        end

        if selected == nil then
            if love.keyboard.isDown("up") then
                cameraLoc[2] = cameraLoc[2] + 2
            elseif love.keyboard.isDown("down") then
                cameraLoc[2] = cameraLoc[2] - 2
            end
            if love.keyboard.isDown("left") then
                cameraLoc[1] = cameraLoc[1] + 2
            elseif love.keyboard.isDown("right") then
                cameraLoc[1] = cameraLoc[1] - 2
            end
        end

        if love.keyboard.isDown("-") and scale > 0.15 then
            scale = scale - 0.05
        elseif love.keyboard.isDown("=") and scale < 1 then
            scale = scale + 0.05
        end
    end
end

function love.mousepressed( x, y, button, istouch, presses )
    if istouch then
        touchControls = true
    else
        touchControls = false
    end

    checkButtons(x, y)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    if touchControls then
        if #touches < 2 then
            touch = { x = x, y = y, id = id, time = love.timer.getTime() }
            table.insert(touches, touch)

            wx = (x - cameraLoc[1]) / scale
            wy = (y - cameraLoc[2]) / scale
            wx = math.ceil((wx - 50) / 100)
            wy = math.ceil((wy - 50) / 100)

            for i, v in ipairs(blocks) do
                if v.x == wx and v.y == wy then
                    selected = i
                    break
                end
                selected = nil
            end
        end
    end
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    if touchControls then
        if #touches == 1 and touches[1].id == id and love.timer.getTime() - touches[1].time > 0.2 and selected == nil then
            cameraLoc[1] = cameraLoc[1] + dx
            cameraLoc[2] = cameraLoc[2] + dy
        elseif #touches == 2 and (touches[1].id == id or touches[2].id == id) then
            oldDx = touches[1].x - touches[2].x
            oldDy = touches[1].y - touches[2].y
            if id == touches[1].id then
                newDx = x - touches[2].x
                newDy = y - touches[2].y
            elseif id == touches[2].id then
                newDx = touches[1].x - x
                newDy = touches[1].y - y
            end
            delta = ((oldDx ^ 2 + oldDy ^ 2) - (newDx ^ 2 + newDy ^ 2)) / 500000
            if delta > 0.01 or delta < -0.01 then
                scale = scale - ((oldDx ^ 2 + oldDy ^ 2) - (newDx ^ 2 + newDy ^ 2)) / 5000000
            end

            if scale < 0.15 then
                scale = 0.14
            elseif scale > 1 then
                scale = 0.99
            end
        end
    end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    if touchControls then
        if #touches == 1 and touches[1].id == id then
            dx = x - touches[1].x
            dy = y - touches[1].y

            if selected ~= nil then
                if math.abs(dx) > math.abs(dy) then
                    if dx > 0 then
                        dir = 'right'
                    else
                        dir = 'left'
                    end
                elseif math.abs(dy) > math.abs(dx) then
                    if dy > 0 then
                        dir = 'down'
                    else
                        dir = 'up'
                    end
                end
                if blocks[selected]:move(dir, true) then
                    selected = nil
                    moves = moves+1
                end
            end
        end

        touches = {}
    end
end

function checkButtons(x, y)
    if state == 'menu' then
        if x > love.graphics.getWidth()/2 - 150 and x < love.graphics.getWidth()/2 + 150 and y > love.graphics.getHeight()/2 - 50 and y < love.graphics.getHeight()/2 + 50 then
            if difficulty == 'easy' then
                difficulty = 'medium'
            elseif difficulty == 'medium' then
                difficulty = 'hard'
            elseif difficulty == 'hard' then
                difficulty = 'easy'
            end
        else
            state = 'running'
            loadGame()
        end

    elseif state == 'playing' or state == 'finished' then
        if x > 50 and x < 90 and y > love.graphics.getHeight() - 90 and y < love.graphics.getHeight() - 10 then
            state = 'menu'
        end

        if x > love.graphics.getWidth() - 90 and x < love.graphics.getWidth() - 50 and y > love.graphics.getHeight() - 90 and y < love.graphics.getHeight() - 10 then
            loadGame()
        end
    end
end