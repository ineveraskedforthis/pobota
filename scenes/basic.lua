STASH_ENTER = {x= 200, y = 20, w = 50, h = 50}
ARENA_ENTER = {x= 100, y = 20, w = 50, h = 50}


return function()
    for _, character in pairs(GAME.characters) do
        require "render.character"(character)
    end

    for _, projectile in pairs(GAME.projectiles) do
        require "render.projectile"(projectile)
    end
end