local trophyInfo = {
    rarity = 4,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        local all = true
        for k, v in pairs(SMODS.Achievements) do
            if StringStartsWith(k, 'ach_fnwk_') then
                if k ~= 'ach_fnwk_big_meat' and not v.earned then
                    all = false
                end
            end
        end
        return all
    end,
}

return trophyInfo