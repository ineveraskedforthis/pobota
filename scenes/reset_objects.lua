local q = require "events.queue"
local events = require "events.event"

return function()
    for _, character in pairs(GAME.characters) do
        q.push(GAME.character_events, events.delete_character(character))
    end
    if GAME.player and GAME.player.hp > 0 then
        q.push(GAME.character_events, events.add_character(GAME.player))
    end
end