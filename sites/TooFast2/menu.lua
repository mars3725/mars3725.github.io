difficulty = 'easy'

function loadMenu()

end

function updateMenu(dt)

end

function drawMenu()
    love.graphics.setColor(0,0,0)
    love.graphics.printf('Too Fast 2', FontLg, love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 4, 300, 'center')
    love.graphics.printf(difficulty, FontLg, love.graphics.getWidth() / 2 - 150, love.graphics.getHeight()*2 / 4, 300, 'center')
    love.graphics.printf('Tap To Begin', FontLg, love.graphics.getWidth() / 2 - 150, love.graphics.getHeight()*3 / 4, 300, 'center')
    love.graphics.printf('Made with LÖVE by Matt Mohandiss', FontSm, love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() - 25, 300, 'center')
end