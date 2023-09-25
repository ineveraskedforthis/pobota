return function(x, y, width, height, color)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(r, g, b, a)
end