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

local arena_flag = false
local stash_flag = false

function scene.draw()
    if not GAME.player then
        return
    end

    arena_flag = active_rect_text(
        ARENA_ENTER, GAME.player.position, 'Arena', 'press Enter')
    stash_flag = active_rect_text(
        STASH_ENTER, GAME.player.position, 'Stash', 'press Enter')
end

function scene.update(dt)
end

function scene.keypressed(key, scancode, isrepeat)
    if not GAME.player then
        return
    end

    if key == 'return' and arena_flag then
        local new_scene = require "scenes.arena"
        require "scenes.switch_scene"(new_scene)
    end

    if key == 'return' and stash_flag then
        local new_scene = require "scenes.stash"
        require "scenes.switch_scene"(new_scene)
    end
end


return scene