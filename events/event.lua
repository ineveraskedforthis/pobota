local projectile_effects = require "effects.projectile"
local geom = require "geom.operations"

---@class EventProjectile
---@field root Projectile
---@field callback fun(root:Projectile)

---@class EventPositional
---@field root vec2
---@field callback fun(root:vec2)

---@class EventCharacter
---@field root vec2
---@field callback fun(root:vec2)

local basic_events = {}

---comment
---@param root vec2
---@param speed vec2
---@param spell Spell
---@param caster Character
---@return EventPositional
function basic_events.spawn_projectile(root, speed, spell, caster)
    ---@type EventPositional
    local event = {
        root = root,
        callback = function(root)
            projectile_effects.spawn_projectile(root, speed, spell, caster)
        end
    }
    return event
end

---comment
---@param root Character
---@return EventCharacter
function basic_events.delete_character(root)
    return {
        root = root,
        callback = function(root)
            GAME.characters[root] = nil
        end
    }
end

---@param root Character
---@return EventCharacter
function basic_events.add_character(root)
    return {
        root = root,
        callback = function(root)
            GAME.characters[root] = root
        end
    }
end


---@return EventProjectile
function basic_events.projectile_hit(root, target)
    ---@type EventProjectile
    local event = {
        root = root,
        callback = function(root)
            root.spell.on_hit(root, target)
            GAME.projectiles[root] = nil
        end
    }
    return event
end


return basic_events