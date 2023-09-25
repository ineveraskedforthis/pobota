local values = require "values.character_stats"
local geom = require "geom.operations"
local effects = require "effects.character"

---@class Spell
local spell = {}

function spell.mana_cost(caster)
    return 1
end

function spell.cooldown(caster)
    return 0.5 / (caster.dexterity + 1)
end

function spell.damage(caster)
    return caster.strength
end

function spell.on_cast(caster)
    -- local x, y = love.mouse.getPosition( )
    local dv = geom.difference(caster.target, caster.position)
    local alpha = math.atan2(dv.y, dv.x)
    -- if dv.x < 0 then
    --     alpha = alpha + math.pi
    -- end
    local range = values.melee_range(caster)
    for _, character in pairs(GAME.characters) do
        if character ~= caster then
            local caster_to_target = geom.difference(character.position, caster.position)
            local dist = geom.norm(caster_to_target)
            if dist <= range then
                local alpha2 = math.atan2(caster_to_target.y, caster_to_target.x)
                -- if caster_to_target.x < 0 then
                --     alpha2 = alpha2 + math.pi
                -- end
                if math.abs(alpha2 - alpha) <= math.pi/4 + 0.1 then
                    effects.deal_damage(character, 100)
                end
            end
        end
    end
end

function spell.render_cast(caster)
    local sweep_time = caster.current_cast.cast_time

    love.graphics.setColor(1, 1, 0, sweep_time)
    if sweep_time > spell.cooldown(caster) * 0.9 then
        love.graphics.setColor(1, 1, 0)
    end

    local x, y = love.mouse.getPosition( )
    local c_x, c_y = caster.position.x, caster.position.y
    local dx = (x-c_x)
    local dy = (y-c_y)
    local alpha = math.atan2(dy, dx)

    if dx < 0 then
        alpha = alpha + math.pi
    end
    love.graphics.arc('fill', c_x, c_y, values.melee_range(caster), alpha - math.pi/4, alpha + math.pi/4)

    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', c_x, c_y, 5)
end

function spell.on_update_projectile(dt, caster, projectile)

end

function spell.on_update_caster(dt, caster)

end

function spell.on_hit(caster, target)

end

return spell