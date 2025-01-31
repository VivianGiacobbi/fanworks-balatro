local trophyInfo = {
    rarity = 2,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "skin_vineshroom" then
            return true
        end
    end,
}

return trophyInfo