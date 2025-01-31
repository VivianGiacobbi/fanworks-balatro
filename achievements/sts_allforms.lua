local trophyInfo = {
    rarity = 3,
    hidden_text = false,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "sts_allforms" then
            return true
        end
    end,
}

return trophyInfo