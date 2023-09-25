local active_rect = require "ui.basic.active_rect"

---@param rect rect
---@param position vec2
---@param text_above string
---@param text_below string
return function(rect, position, text_above, text_below)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(text_above, rect.x, rect.y - 20)

    if active_rect(rect, position) then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(text_below, rect.x, rect.y + rect.h)
        return true
    end

    return false
end