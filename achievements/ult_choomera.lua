local trophyInfo = {
    rarity = 3,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "ult_choomera" then
            return true
        end
    end,
}

return trophyInfo