local trophyInfo = {
    rarity = 4,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "discover_amount" then
            local fnwkJokers = 0
            local fnwkDiscovered = 0
            for k, v in pairs(SMODS.Centers) do
                if starts_with(k, 'j_fnwk_') then
                    fnwkJokers = fnwkJokers + 1
                    if v.discovered == true then
                        fnwkDiscovered = fnwkDiscovered + 1
                    end
                end
            end
            if fnwkDiscovered == fnwkJokers then
                return true
            end
        end
    end,
}

return trophyInfo