local bar = require "ui.basic.bar"
return function(x, y, width, height, ratio, main_color, background_color)
    bar(x, y, width, height, background_color)
    bar(x, y, width * ratio, height, main_color)

    love.graphics.rectangle("line", x, y, width, height)
end