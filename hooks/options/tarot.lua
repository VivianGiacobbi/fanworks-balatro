if fnwk_enabled['enableTarotSkins'] then
    -- Tarot Atlas
    SMODS.Atlas{
        key = "tarotreskins",
        path = "tarotreskins.png",
        px = 71,
        py = 95,
        atlas_table = "ASSET_ATLAS"
    }

    SMODS.Consumable:take_ownership('c_wheel_of_fortune',
        {
            atlas = 'fnwk_tarotreskins',
        },
        true
    )
end

