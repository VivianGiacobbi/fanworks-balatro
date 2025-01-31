local trophyInfo = {
    rarity = 3,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "the_band" then
            return true
        end
    end,
}

return trophyInfo