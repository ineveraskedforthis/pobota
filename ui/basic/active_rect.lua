local geom = require "geom.operations"

---@param rect rect
---@param position vec2|nil
return function(rect, position)
    local flag = false
    if position and geom.in_rect(position, rect) then
        flag = true
        love.graphics.setColor(0.5, 0.5, 0)
    else
        love.graphics.setColor(0.5, 0.5, 0, 0.5)
    end

    love.graphics.rectangle('fill', rect.x, rect.y, rect.w, rect.h)

    return flag
end