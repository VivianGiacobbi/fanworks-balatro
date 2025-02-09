local standsToLoad = {
}

if not fnwk_enabled['enableStands'] then
    return
end

--[[
-- Load Consumables
for i, v in ipairs(standsToLoad) do
    loadConsumable(v)
end

SMODS.Atlas({ key = 'fnwk_undiscovered', path ="undiscovered.png", px = 71, py = 95 })
if #standsToLoad > 0 then
    G.C.Stand = HEX('b85f8e')
    SMODS.ConsumableType{
        key = "Stand",
        primary_colour = G.C.Stand,
        secondary_colour = G.C.Stand,
        collection_rows = { 8, 8 },
        shop_rate = 0,
        loc_txt = {},
        default = "c_fnwk_blackspine",
        can_stack = false,
        can_divide = false,
    }

    SMODS.UndiscoveredSprite{
        key = "Stand",
        atlas = "fnwk_undiscovered",
        pos = { x = 0, y = 0 }
    }
end
--]]