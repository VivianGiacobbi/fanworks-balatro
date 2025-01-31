local trophyInfo = {
    rarity = 1,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "discover_meat" then
            return true
        end
    end,
}

return trophyInfo