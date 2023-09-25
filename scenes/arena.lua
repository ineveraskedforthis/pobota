local effects = require "effects.character"
local scene = {}

local function spawn_dummy(x, y)
    local dummy = require "entity.character"()

    dummy.position.x = x
    dummy.position.y = y
    dummy.strength = 10
    dummy.dexterity = 2
    dummy.intelligence = 2
    dummy.team = 10

    dummy.main_spell = require "skills.magic_ball"

    GAME.characters[dummy] = dummy
end

local function spawn_dummy_cluster(x, y)
    for i = -3, 3 do
        for j = -3, 3 do
            spawn_dummy(x + i * 40, y + j * 40)
        end
    end
end

local function spawn_enemies()
    spawn_dummy_cluster(400, 400)
end

function scene.load()
    require "scenes.reset_objects"()
    if GAME.player then
        effects.restore_hp(GAME.player)
        effects.restore_mana(GAME.player)
    end
    spawn_enemies()
end

local timer = 0

function scene.update(dt)
    timer = timer + dt

    if timer > 0.04 then
        timer = 0

        local enemies_left = 0
        for _, character in pairs(GAME.characters) do
            if character.team ~= GAME.player.team then
                enemies_left = enemies_left + 1
            end
        end

        if enemies_left < 1 then
            require "scenes.switch_scene"(require "scenes.main_menu")
        end
    end
end

function scene.draw()

    local enemies_left = 0
    for _, character in pairs(GAME.characters) do
        if character.team ~= GAME.player.team then
            enemies_left = enemies_left + 1
        end
    end

    love.graphics.print(tostring(enemies_left), 20, 20)
end

function scene.keypressed()

end

return scene