local q = require "events.queue"
local events = require "events.event"
local values = require "values.character_stats"
local item_effects = require "effects.items"

local effects = {}

---comment
---@param character Character
---@param x number
function effects.spend_mana(character, x)
    character.mana = character.mana - x
    if character.mana < 0 then
        character.mana = 0
    end
end

function effects.regenerate_mana(character, x)
    character.mana = character.mana + x
    if character.mana > values.max_mana(character) then
        character.mana = values.max_mana(character)
    end
end

function effects.regenerate_hp(character, x)
    character.hp = character.hp + x
    if character.hp > values.max_hp(character) then
        character.hp = values.max_hp(character)
    end
end

---@param character Character
---@param x number
function effects.deal_damage(character, x)
    character.hp = character.hp - x
    if character.hp < 0 then
        character.hp = 0
        if character.team ~= GAME.player.team then
            local item = item_effects.roll_item()
            if item then
                GAME.items[item] = item
            end
        end
        q.push(GAME.character_events, events.delete_character(character))
    end
end

---comment
---@param character Character
function effects.cast_main_spell(character)
    if character.current_cast == nil and character.main_spell then
        character.current_cast = {
            spell = character.main_spell,
            cast_time = 0
        }
    end
end

function effects.restore_hp(character)
    character.hp = values.max_hp(character)
end

function effects.restore_mana(character)
    character.mana = values.max_mana(character)
end

---comment
---@param character Character
---@param shift vec2
function effects.shift(character, shift)
    character.position.x = character.position.x + shift.x
    character.position.y = character.position.y + shift.y
end

return effects