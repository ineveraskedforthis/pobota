local values = require "values.character_stats"

---@param character Character
return function(character)
    if character.current_cast then
        character.current_cast.spell.render_cast(character)
    end

    love.graphics.setColor(1, 1, 1)

    if ASSETS[character.model] == nil then
        love.graphics.circle('fill', character.position.x, character.position.y, values.size(character))
    else
        local image_w = ASSETS[character.model]:getWidth()
        local image_h = ASSETS[character.model]:getHeight()

        local scale = values.size(character) / math.max(image_w, image_h) * 2

        local corner_x = character.position.x - image_w / 2 * scale
        local corner_y = character.position.y - image_h / 2 * scale

        love.graphics.draw(ASSETS[character.model], corner_x, corner_y, 0, scale, scale)
    end

    for _, aura in pairs(character.auras) do
        aura.render_aura(character)
    end
end