function hexColor(hex)
    return { tonumber("0x" .. hex:sub(1, 2)) / 255, tonumber("0x" .. hex:sub(3, 4)) / 255, tonumber("0x" .. hex:sub(5, 6)) / 255 }
end

directions = { up = { 0, -1 }, down = { 0, 1 }, left = { -1, 0 }, right = { 1, 0 } }
colorTypes = { hexColor("D94745"), hexColor("FAAD61"), hexColor('44679C'), hexColor('12BA85') }
tapColors = { { .8, .19, .19 }, { .9, .7, .08 }, { .17, .78, .21 } }
shapeTypes = { 'triangle', 'circle', 'square' }

FontSm = love.graphics.newFont("JosefinSansRegular.ttf", 15)
FontLg = love.graphics.newFont("JosefinSansRegular.ttf", 35)

compliments = {
    "WOW!", "WAY TO GO!", "SUPER!", "THAT’S INCREDIBLE!", "OUTSTANDING!", "EXCELLENT!", "GREAT!", "GOOD!", "NEAT!",
    "I KNEW YOU COULD DO IT!", "I'M PROUD OF YOU!", "FANTASTIC!", "WHAT A SUPERSTAR!", "NICE WORK!", "LOOKING GOOD!",
    "BEAUTIFUL!", "NOW YOU'RE FLYING!", "YOU'RE CATCHING ON!", "NOW YOU'VE GOT IT!", "YOU'RE INCREDIBLE!", "BRAVO!",
    "HURRAY FOR YOU!", "YOU'RE ON TARGET!", "YOU'RE ON YOUR WAY!", "YOUR HARD WORK PAID OFF!", "SMART!", "GOOD JOB!",
    "YOU DID IT!", "DYNAMITE!", "WHAT A TALENT!", "NOTHING CAN STOP YOU NOW!", "GOOD FOR YOU!", "JUST LIKE THAT!",
    "REMARKABLE JOB!", "BEAUTIFUL WORK!", "SPECTACULAR!", "YOU DID IT!", "YOU WORKED SO HARD AND IT PAID OFF!",
    "YOU'VE FOUND THE SECRET!", "YOU FIGURED IT OUT!", "FANTASTIC JOB!", "HURRAY!", "BINGO!", "MAGNIFICENT!", "KEEP IT UP!",
    "PHENOMENAL!", "SENSATIONAL!", "SUPER WORK!", "CREATIVE JOB!", "SUPER JOB!", "FANTASTIC JOB!", "MARVELOUS!",
    "THAT WAS A GREAT IMPROVEMENT!", "OUTSTANDING PERFORMANCE!", "I LOVE HOW YOU DID THAT!", "THAT'S INCREDIBLE!",
    "YES!", "THAT'S CORRECT!", "WHAT A JOY!", "THAT’S EXACTLY IT!", "WONDERFUL!", "PERFECTLY DONE!", "AWESOME!", "YES!",
    "A+ JOB!", "YAY!", "YOU MADE MY DAY!", "WELL DONE!", "REMARKABLE!", "EXCEPTIONAL PERFORMANCE!", "NICELY DONE!",
    "HIGH FIVE!", "TERRIFIC!", "WHOOHOO!", "YOU'RE ON TOP OF IT!", "YOU'RE A WINNER!", "THAT’S EXACTLY IT!", "FABULOUS!",
    "I LOVE YOU LAUREN!", "I LOVE THAT FOR YOU!"
}