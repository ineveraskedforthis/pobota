local geom = require "geom.operations"

---@param rect rect
---@param position vec2|nil
return function(rect, position)
    local flag = false
    if position and geom.in_rect(position, rect) then
        flag = true
        love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
    else
        love.graphics.setColor(0.5, 0.5, 0.5, 0.3)
    end

    love.graphics.rectangle('fill', rect.x, rect.y, rect.w, rect.h)

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('line', rect.x, rect.y, rect.w, rect.h)

    return flag
end