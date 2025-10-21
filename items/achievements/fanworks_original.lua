local achInfo = {
    rarity = 2,
    config = {valid_keys = {j_fnwk_glass_jokestar = true, j_fnwk_city_neet = true}},
    origin = 'fanworks',
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_mood_replace' then return false end

    if self.config.valid_keys[args.old] then
        local new_obj = G.P_CENTERS[args.new]
        return not new_obj.original_mod or new_obj.original_mod.id ~= 'fanworks'
    end
end

return achInfo