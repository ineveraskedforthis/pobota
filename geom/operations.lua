local operations = {}

---comment
---@param a vec2
---@param b vec2
---@return vec2
function operations.difference(a, b)
    return {
        x = a.x - b.x,
        y = a.y - b.y
    }
end

---comment 
---@param a vec2
---@return vec2
function operations.normalize(a)
    local l = math.sqrt(a.x * a.x + a.y * a.y)
    return {
        x = a.x / l,
        y = a.y / l
    }
end

---comment
---@param a vec2
---@return number
function operations.norm(a)
    return math.sqrt(a.x * a.x + a.y * a.y)
end

---comment
---@param a vec2
---@param rect rect
---@return boolean
function operations.in_rect(a, rect) 
    return (a.x >= rect.x) and (a.x <= rect.x + rect.w) and (a.y >= rect.y) and (a.y <= rect.y + rect.h)
end

return operations