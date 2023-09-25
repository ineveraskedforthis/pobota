---@enum MODIFIER_TAG
MODIFIER_TAG = {
    CAST_SPEED = "CAST_SPEED",
    MANA_REGEN = "MANA_REGEN",
    HEALTH_REGEN = "HEALTH_REGEN",
    MAX_HP = "MAX_HP",
    MAX_MANA = "MAX_MANA",
}


---@enum EQUIP_SLOT
EQUIP_SLOT = {
    WEAPON = "MAIN_HAND",
    HAT = "HAT",
    GARB = "GARB"
}

---@class Modifier
---@field tag MODIFIER_TAG
---@field value number

---@class Affix
---@field name string
---@field modifier Modifier

---@class Item
---@field name string
---@field equip_slot EQUIP_SLOT
---@field weight number
---@field implicit Modifier
---@field prefix Affix|nil
---@field suffix Affix|nil


local items = {}

---@type table<string, Item>
items.bases = {
    speed_wand = {
        name = "Sapphire Wand",
        weight = 100,
        equip_slot = EQUIP_SLOT.WEAPON,
        implicit = {
            tag = MODIFIER_TAG.CAST_SPEED,
            value = 5
        },
    },

    health_chest = {
        name = "Silk Robe",
        weight = 100,
        equip_slot = EQUIP_SLOT.GARB,
        implicit = {
            tag = MODIFIER_TAG.HEALTH_REGEN,
            value = 10
        }
    },

    mana_hat = {
        name = "Wizard Hat",
        weight = 100,
        equip_slot = EQUIP_SLOT.HAT,
        implicit = {
            tag = MODIFIER_TAG.MANA_REGEN,
            value = 10
        }
    }
}


return items