local effects = require "effects.character"
local geom = require "geom.operations"
-- local active_rect = require "ui.basic.active_rect"
local active_rect_text = require "ui.basic.active_rect_text"
local scene = {}

function scene.load()
    require "scenes.reset_objects"()
    if GAME.player then
        effects.restore_hp(GAME.player)
        effects.restore_mana(GAME.player)
    end
end

local character_magic_ball = false
local character_wither = false

local select_magic_ball = {x= 200, y= 200, w= 100, h = 100}
local select_wither = {x= 400, y= 200, w= 100, h = 100}

function scene.draw()
    if not GAME.player then
        return
    end

    character_magic_ball = active_rect_text(
        select_magic_ball, GAME.player.position, 'Selena - Magic Ball', 'press Enter')
    character_wither = active_rect_text(
        select_wither, GAME.player.position, 'Mo\'lno - Wither', 'press Enter')
end

function scene.update(dt)
end

function scene.keypressed(key, scancode, isrepeat)
    if not GAME.player then
        return
    end

    if key == 'return' and character_magic_ball then
        GAME.player.main_spell = require "skills.magic_ball"
        GAME.player.model = "character_1"
        local new_scene = require "scenes.main_menu"
        require "scenes.switch_scene"(new_scene)
    end

    if key == 'return' and character_wither then
        GAME.player.main_spell = require "skills.wither"
        GAME.player.model = "character_2"
        local new_scene = require "scenes.main_menu"
        require "scenes.switch_scene"(new_scene)
    end
end


return scene