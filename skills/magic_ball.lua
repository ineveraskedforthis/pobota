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
    return caster.intelligence * 10
end

function spell.cast_time(caster)
    return 2 / values.cast_speed(caster)
end

function spell.on_cast(caster, target_position)
    if caster.mana < spell.mana_cost(caster) then
        return
    end
    effects.spend_mana(caster, spell.mana_cost(caster))
    caster.current_cast = nil
    local speed = geom.difference(target_position, caster.position)
    speed = geom.normalize(speed)
    speed.x = speed.x * 1000
    speed.y = speed.y * 1000
    local start = {x= caster.position.x, y= caster.position.y}
    queue.push(GAME.projectiles_events, events.spawn_projectile(start, speed, spell, caster))
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
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle('fill', projectile.position.x, projectile.position.y, projectile.size)
    love.graphics.setColor(r, g, b, a)
end

function spell.on_update_caster(dt, caster)

end

function spell.on_hit(projectile, target)
    effects.deal_damage(target, projectile.damage)

    -- projectile_is_alive[proj] = false
    -- if projectiles_bounce[proj] > 0 then
    --     local x = enemies_x[enemy]
    --     local y = enemies_y[enemy]
    --     local t = math.random() * 2
    --     spawn_projectile(x, y, x + math.sin(t * 3.14), y + math.cos(t * 3.14), projectiles_bounce[proj] - 1, cproj_speed, 100, enemy, 0)
    --     local t = math.random() * 2
    --     spawn_projectile(x, y, x + math.sin(t * 3.14), y + math.cos(t * 3.14), projectiles_bounce[proj] - 1, cproj_speed, 100, enemy, 0)
    -- end
end

return spell