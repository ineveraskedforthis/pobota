local items = require "entity.item"

local item_effects = {}

local eps = 0.0001


---comment
---@return Item|nil
function item_effects.roll_item()
    local total_weight = 0

    for _, item in pairs(items.bases) do
        total_weight = total_weight + item.weight
    end

    local roll = love.math.random() * total_weight * 10

    for _, item in pairs(items.bases) do
        roll = roll - item.weight
        if roll <= eps then
            return {
                name = item.name,
                equip_slot = item.equip_slot,
                weight = item.weight,
                implicit = item.implicit,
            }
        end
    end
    return nil
end


return item_effects