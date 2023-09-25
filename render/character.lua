local values = require "values.character_stats"

---@param character Character
return function(character)
    if character.current_cast then
        character.current_cast.spell.render_cast(character)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', character.position.x, character.position.y, values.size(character))


    for _, aura in pairs(character.auras) do
        aura.render_aura(character)
    end
end