local ratio_bar = require "ui.basic.bar_percentage"
local values = require "values.character_stats"

---@param character Character
return function(character, x, y, width, height)

    love.graphics.setColor(0, 0, 0)

    local hp_ratio = character.hp / values.max_hp(character)
    ratio_bar(x, y, width, height / 2.1, hp_ratio, {1, 0, 0}, {0.5, 0.5, 0.5})

    local mana_ratio = character.mana / values.max_mana(character)
    ratio_bar(x, y + height / 2.1, width, height / 2, mana_ratio, {0, 0, 1}, {0.5, 0.5, 0.5})

    love.graphics.print('hp  ' .. tostring(character.hp), 600, 5)
    love.graphics.print('mana  ' .. tostring(math.floor(character.mana)), 600, 25)

    --- stash
    local i = 0
    for _, item in pairs(GAME.items) do
        i = i + 1
    end
    love.graphics.print("Items in stash: " .. i, 600, 50)

    -- equip
    if character.garb then
        love.graphics.print("Garb:   \n" .. tostring(character.garb.name),   5, 120)
    end
    if character.hat then
        love.graphics.print("Hat:    \n" .. tostring(character.hat.name),    5, 160)
    end
    if character.weapon then
        love.graphics.print("Weapon: \n" .. tostring(character.weapon.name), 5, 200)    
    end
    
    -- love.graphics.print('projectile speed  ' .. tostring(character.spell.speed), 600, 140)
    -- love.graphics.print('bounce amount  ' .. tostring(character.spell.bounce), 600, 155)
    -- love.graphics.print('attacks per second  ' .. tostring(1 / character.spell.cast_speed * get_stat(character, 'cast_speed')), 600, 170)
    -- love.graphics.print('mana regen  ' .. tostring(get_stat(character, 'mana_regen')), 600, 185)
    -- love.graphics.print('damage  ' .. tostring(character.spell.damage * get_stat(character, 'damage')), 600, 200)
    -- love.graphics.print('speed  ' .. tostring(get_stat(character, 'speed')), 600, 215)

    -- love.graphics.print('skill points  ' .. tostring(points), 600, 280)
    -- love.graphics.print('inc cast speed  press [1]', 600, 300)
    -- love.graphics.print('inc damage  press [2]', 600, 320)
    -- love.graphics.print('inc mana regen  press [3]', 600, 340)
end