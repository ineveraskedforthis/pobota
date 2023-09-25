---@param model string
return function(model, rect)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 1, 1, 1)
    local image = ASSETS['portrait_' .. model]
    local w = image:getWidth()
    local h = image:getHeight()
    love.graphics.draw(image, rect.x, rect.y, 0, rect.w / w, rect.h / h)
    love.graphics.rectangle("line", rect.x, rect.y, rect.w, rect.h)

    love.graphics.setColor(r, g, b, a)
end