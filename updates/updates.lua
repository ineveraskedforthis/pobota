local ai_turret = require "ai.turret"
local effects = require "effects.character"
local values = require "values.character_stats"
local geom = require "geom.operations"

local update = {}

---comment
---@param projectile Projectile
---@param dt number
function update.projectile(projectile, dt)
    projectile.position.x = projectile.position.x + projectile.speed.x * dt
    projectile.position.y = projectile.position.y + projectile.speed.y * dt

    for _, character in pairs(GAME.characters) do
        local difference = geom.difference(projectile.position, character.position)
        if (geom.norm(difference) < projectile.size + values.size(character)) and (character.team ~= projectile.caster.team) then
            projectile.spell.on_hit(projectile, character)
        end
    end
end

---comment
---@param character Character
---@param dt number
function update.character(character, dt)
    effects.regenerate_mana(character, dt * values.mana_regen(character))
    effects.regenerate_hp(character, dt * values.hp_regen(character))
    
    if character.current_cast then
        character.current_cast.cast_time = character.current_cast.cast_time + dt
        local spell = character.current_cast.spell
        if character.current_cast.cast_time > spell.cast_time(character) then
            spell.on_cast(character, character.target)
            character.current_cast = nil
        end
    end

    for _, aura in pairs(character.auras) do
        for _, target in pairs(GAME.characters) do
            if target.team ~= character.team then
                aura.enemy_aura(character, target, dt)
            end            
        end
    end

    if character.team == 10 then
        ai_turret(character)
    end
end



return update