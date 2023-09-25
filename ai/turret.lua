local effects = require "effects.character"

---@param character Character
return function(character)
    if GAME.player then
        character.target = GAME.player.position
        effects.cast_main_spell(character)
    end
end