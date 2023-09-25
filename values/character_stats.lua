local geom = require "geom.operations"

local stats = {}


---comment
---@param character Character
---@return table<number, Item>
local function all_items(character) 
    local tab = {}
    if character.garb then table.insert(tab, character.garb) end
    if character.hat then table.insert(tab, character.hat) end
    if character.weapon then table.insert(tab, character.weapon) end

    return tab
end

---comment
---@param item Item
---@return table<number, Modifier>
local function all_mods_item(item)
    local tab = {}

    table.insert(tab, item.implicit)
    if item.prefix then table.insert(tab, item.prefix) end
    if item.suffix then table.insert(tab, item.suffix) end

    return tab
end

---comment
---@param character Character
---@return table<number, Modifier>
local function all_mods(character)
    local mods = {}
    local items = all_items(character)

    for i, item in ipairs(items) do
        for i, mod in ipairs(all_mods_item(item)) do
            table.insert(mods, mod)
        end
    end

    return mods
end

---comment
---@param character Character
---@param tag MODIFIER_TAG
---@return number
local function count_modifier_value(character, tag)
    local count = 0
    for _, mod in ipairs(all_mods(character)) do
        if mod.tag == tag then
            count = count + mod.value
        end
    end
    return count
end

---comment
---@param character Character
---@return number
function stats.max_hp(character)
    return character.strength * 10
        +  count_modifier_value(character, MODIFIER_TAG.MAX_HP)
end

---@param character Character
---@return number
function stats.max_mana(character)
    return character.intelligence * 10 
        +  count_modifier_value(character, MODIFIER_TAG.MAX_MANA)
end

---@param character Character
---@return number
function stats.max_shield(character)
    return character.intelligence
end

---@param character Character
---@return number
function stats.dodge_recovery(character)
    return character.dexterity / 10
end

function stats.melee_range(character)
    return 10
end

function stats.hp_regen(character)
    return 10
        +  count_modifier_value(character, MODIFIER_TAG.HP_REGEN)
end

function stats.mana_regen(character)
    return 10
        +  count_modifier_value(character, MODIFIER_TAG.MANA_REGEN)
end

function stats.speed(character)
    return 100 + character.dexterity
end

function stats.cast_speed(character)
    return 1
        +  character.dexterity / 10
        +  count_modifier_value(character, MODIFIER_TAG.CAST_SPEED)
end

function stats.size(character)
    return character.strength
end

---comment
---@param a Character
---@param b Character
---@return number
function stats.dist(a, b)
    return geom.norm(geom.difference(a.position, b.position))
end

return stats