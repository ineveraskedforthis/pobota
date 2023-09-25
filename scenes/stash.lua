local effects = require "effects.character"
local geom = require "geom.operations"
local active_rect_text = require "ui.basic.active_rect_text"

local scene = {}

function scene.load()
    require "scenes.reset_objects"()
    if GAME.player then
        effects.restore_hp(GAME.player)
        effects.restore_mana(GAME.player)
    end
end

local exit_flag = false
---@type Item|nil
local current_item = nil

function scene.draw()
    if not GAME.player then
        return
    end

    exit_flag = active_rect_text(
        STASH_ENTER, GAME.player.position, 'Exit', 'press Enter')


    -- drawing items
    local i = 0
    local j = 0
    current_item = nil
    for _, item in pairs(GAME.items) do
        ---@type rect
        local item_rect = {
            x = 300 + i * 100,
            y = 100 + j * 70,
            w = 30,
            h = 30
        }

        if active_rect_text(
            item_rect, GAME.player.position, item.name .. i .. j, 'Enter: equip') then
                current_item = item
            end

        i = i + 1
        if i > 4 then
            i = 0
            j = j + 1
        end
    end

    love.graphics.print(tostring(current_item), 0, 0)
end

function scene.update(dt)

end

function scene.keypressed(key, scancode, isrepeat)
    local player = GAME.player
    if not player then
        return
    end

    if key == 'return' and exit_flag then
        local new_scene = require "scenes.main_menu"
        require "scenes.switch_scene"(new_scene)
    end

    if current_item and key == 'return' then
        -- print('equip')
        local slot = current_item.equip_slot

        if slot == EQUIP_SLOT.GARB then
            local temp = player.garb

            GAME.items[current_item] = nil
            GAME.player.garb = current_item

            if temp then
                GAME.items[temp] = temp
            end
        end

        if slot == EQUIP_SLOT.HAT then
            local temp = player.hat

            GAME.items[current_item] = nil
            GAME.player.hat = current_item

            if temp then
                GAME.items[temp] = temp
            end
        end

        if slot == EQUIP_SLOT.WEAPON then
            local temp = player.weapon

            GAME.items[current_item] = nil
            GAME.player.weapon = current_item

            if temp then
                GAME.items[temp] = temp
            end
        end
    end
end


return scene