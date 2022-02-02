io.stdout:setvbuf("no")
flux = require "flux"

--package.cpath = package.cpath .. ';C:/Users/mattm/AppData/Roaming/JetBrains/IntelliJIdea2021.2/plugins/EmmyLua/classes/debugger/emmy/windows/x64/?.dll'
--local dbg = require('emmy_core')
--dbg.tcpListen('localhost', 9966)
--dbg.waitIDE()

require "camera"
require "defs"
require "block"
require "grid"
require "shapes"
require "game"
require 'menu'

debug = false
screenSize = 30
state = nil

function love.load()
    love.graphics.setBackgroundColor(hexColor("f9f5f1"))
    love.window.updateMode( 600, 600, {version = "11.3"} )

    state = "menu"
    loadMenu()
end

function love.update(dt)
    if state == 'menu' then
        updateMenu(dt)
    elseif state == 'playing' then
        updateGame(dt)
    end
end

function drawDev()
    local stats = love.graphics.getStats()
    love.graphics.setColor(0, 0, 0)

    love.graphics.print('Too Fast 2 (Alpha)', 0, 0)
    love.graphics.print('Time: ' .. math.floor(tt * math.pow(10, 1) + 0.5) / math.pow(10, 1), 0, 15)
    love.graphics.print('Draws Batched: ' .. stats.drawcallsbatched, 0, 30)
    love.graphics.print('Random Seed: ' .. love.math.getRandomSeed(), 0, 45)
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 60)
    love.graphics.print('Avg dt: ' .. love.timer.getAverageDelta(), 0, 75)
    if state == 'playing' then
        love.graphics.print('Objects: ' .. #grid.tiles + #blocks + #shapes .. ' (' .. #blocks + #shapes .. ' dynamic)', 0, 90)
    end
end

function love.draw()
    if state == 'menu' then
        drawMenu()
    elseif state == 'playing' or state == 'finished' then
        drawGame()
    end

    if debug then
        drawDev()
    end
end