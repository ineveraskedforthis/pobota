local geom = require "geom.operations"
local values = require "values.character_stats"

local effects = {}

---comment
---@param position vec2
---@param speed vec2
---@param spell Spell
---@param caster Character
function effects.spawn_projectile(position, speed, spell, caster)
    ---@type Projectile
    local projectile = {
        position = position,
        speed = speed,
        spell = spell,
        caster = caster,
        size = math.sqrt(spell.damage(caster)),
        damage = spell.damage(caster),
    }

    GAME.projectiles[projectile] = projectile
end




return effects