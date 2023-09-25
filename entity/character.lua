---@class Cast
---@field spell Spell
---@field cast_time number

---@class Character
---@field strength number
---@field dexterity number
---@field intelligence number
---@field model string
---@field position vec2
---@field target vec2
---@field cooldowns table<Spell, number>
---@field hp number
---@field mana number
---@field current_cast Cast|nil
---@field main_spell Spell|nil
---@field team number
---@field garb Item|nil
---@field weapon Item|nil
---@field hat Item|nil
---@field auras table<Spell, Spell>

return function()
    local character = {}

    character.hp = 100
    character.mana = 100
    
    character.strength = 10
    character.dexterity = 10
    character.intelligence = 10

    character.model = "circle"

    character.position = {x = 0, y = 0}
    character.target = {x = 0, y = 0}

    character.main_spell = nil
    character.team = 0

    character.auras = {}

    character.cooldowns = {}
    return character
end