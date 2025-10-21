local tarot_map = {
    c_fool = {j_fnwk_jspec_joepie = true, c_fnwk_jspec_miracle = true},
    c_lovers = {j_fnwk_gotequest_pair = true, c_fnwk_gotequest_sweet = true},
    c_empress = {j_fnwk_sunshine_duo = true},
    c_chariot = {j_fnwk_crimson_golden = true},
    c_justice = {j_fnwk_rubicon_infidel = true, c_fnwk_rubicon_infidelity = true},
    c_hermit = {j_fnwk_city_neet = true, c_fnwk_city_dead = true},
    c_wheel_of_fortune = {j_fnwk_jojopolis_high = true },
    c_death = {j_fnwk_rockhard_rebirth = true, c_fnwk_rockhard_peppers = true},
    c_tower = {j_fnwk_mania_jokestar = true},
    c_star = {j_fnwk_culture_adaptable = true, c_fnwk_culture_starboy = true},
    c_sun = {j_fnwk_streetlight_indulgent = true, c_fnwk_streetlight_neon = true, c_fnwk_streetlight_neon_favorite = true}
}

local achInfo = {
    rarity = 1,
    origin = 'fanworks',
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'use_consumable'then return false end

    local key = args.consumable.config.center.key
    if not tarot_map[key]then return false end

    for _, v in ipairs(G.jokers.cards) do
        if tarot_map[key][v.config.center.key] then return true end
    end

    for _, v in ipairs(G.consumeables.cards) do
        if tarot_map[key][v.config.center.key] then return true end
    end
end

return achInfo