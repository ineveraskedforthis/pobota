local effects = require "effects.character"
local projectile_effects = require "effects.projectile"
local events = require "events.event"
local geom = require "geom.operations"
local queue = require "events.queue"
local values = require "values.character_stats"


---@class Spell
local spell = {}

function spell.mana_cost(caster)
    return spell.damage(caster) / 10
end

function spell.cooldown(caster)
    return 0.5 / (caster.dexterity + 1)
end

function spell.damage(caster)
    return caster.intelligence * 10 * values.cast_speed(caster)
end

function spell.cast_time(caster)
    return 2
end

function spell.aura_radius(caster)
    return caster.intelligence * 10
end

function spell.enemy_aura(caster, target, dt)
    if values.dist(caster, target) < spell.aura_radius(caster) then
        effects.deal_damage(target, 
              spell.damage(caster)    * dt
            + values.hp_regen(target) * dt * 0.5)
    end
end

function spell.on_cast(caster, target_position)
    if caster.mana < spell.mana_cost(caster) then
        return
    end
    effects.spend_mana(caster, spell.mana_cost(caster))
    caster.current_cast = nil

    if caster.auras[spell] then
        caster.auras[spell] = nil
    else
        caster.auras[spell] = spell
    end
    
end

function spell.render_aura(caster)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 0, 1, 0.2)

    love.graphics.circle("fill", caster.position.x, caster.position.y, spell.aura_radius(caster))
    love.graphics.setColor(r, g, b, a)
end

function spell.on_update_projectile(dt, caster, projectile)

end

function spell.render_cast(caster)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 1, 0)
    local cast_time = spell.cast_time(caster)
    local current_cast_time = caster.current_cast.cast_time
    local progress = current_cast_time / cast_time
    love.graphics.circle(
        'line', 
        caster.position.x, 
        caster.position.y, 
        values.size(caster) * progress + 10 * math.sqrt(cast_time) * values.size(caster) * (1 - progress))
    love.graphics.setColor(r, g, b, a)
end

function spell.render_projectile(projectile)

end

function spell.on_update_caster(dt, caster)

end

function spell.on_hit(projectile, target)

end

return spell