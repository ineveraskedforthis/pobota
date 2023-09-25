---@param scene Scene
return function(scene)
    -- print('switch scene')
    GAME.scene = scene
    scene.load()
end