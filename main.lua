require "scenes.basic"

local effects = require "effects.character"
local effects_proj = require "effects.projectile"
local values = require "values.character_stats"
local q = require "events.queue"

local update = require "updates.updates"

function love.load()
    WIDTH = 800
    HEIGHT = 600
    love.window.setMode( WIDTH, HEIGHT)

    GAME = require "global.game"
    PORTRAIT = love.graphics.newImage("p.png", {linear = false})
    GAME.scene = require "scenes.character_selection"
    GAME.player = require "entity.character"()
    -- GAME.player.main_spell = require "skills.magic_ball"
    GAME.characters[GAME.player] = GAME.player

    RESTART = false
end


function love.draw()
    local status_margin = WIDTH * 0.2
    require "ui.status"(GAME.player, status_margin, HEIGHT - 50, WIDTH - status_margin * 2, 50)
    GAME.scene.draw()
    require "scenes.basic"()
end

local function update_player_movement(dt)
    local speed = values.speed(GAME.player)
    if love.keyboard.isDown('w') then
        effects.shift(GAME.player, {x = 0, y = - speed * dt})
    end
    if love.keyboard.isDown('s') then
        effects.shift(GAME.player, {x = 0, y = speed * dt})
    end
    if love.keyboard.isDown('a') then
        effects.shift(GAME.player, {x = - speed * dt, y = 0})
    end
    if love.keyboard.isDown('d') then
        effects.shift(GAME.player, {x = speed * dt, y = 0})
    end
end

function love.update(dt)
    if RESTART then
        require "scenes.switch_scene"(require "scenes.main_menu")
        love.load()
    end

    if GAME.characters[GAME.player] == nil then
        RESTART = true
    end

    GAME.scene.update(dt)

    for _, character in pairs(GAME.characters) do
        update.character(character, dt)
    end

    for _, projectile in pairs(GAME.projectiles) do
        update.projectile(projectile, dt)
    end

    while q.length(GAME.character_events) > 0 do
        local event = q.pop(GAME.character_events)
        event.callback(event.root)
    end

    while q.length(GAME.positional_events) > 0 do
        local event = q.pop(GAME.positional_events)
        event.callback(event.root)
    end

    while q.length(GAME.projectiles_events) > 0 do
        local event = q.pop(GAME.projectiles_events)
        event.callback(event.root)
    end

    update_player_movement(dt)

    if love.mouse.isDown(1) then
        effects.cast_main_spell(GAME.player)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    GAME.player.target = {x = x, y = y}
end

function love.mousepressed(x, y, button, istouch)
    if (button == 1) then
        effects.cast_main_spell(GAME.player)
    end
end

function love.keyreleased( key)

end

function love.keypressed( key, scancode, isrepeat)
    if not GAME.player then
        return
    end

    GAME.scene.keypressed(key, scancode, isrepeat)
end
