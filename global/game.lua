local q = require "events.queue"

local game = {}

---@type table<Character, Character>
game.characters = {}

---@type table <Projectile, Projectile>
game.projectiles = {}

---@type Queue<EventProjectile>
game.projectiles_events = q.new()

---@type Queue<EventPositional>
game.positional_events = q.new()

---@type Queue<EventCharacter>
game.character_events = q.new()

---@type Character|nil
game.player = nil

---@type Scene
game.scene = require "scenes.main_menu"

---@type table<Item, Item>
game.items = {}

return game