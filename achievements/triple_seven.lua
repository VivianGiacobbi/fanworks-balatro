local trophyInfo = {
    rarity = 2,
    hidden_text = false,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "triple_seven" then
            return true
        end
    end,
}

return trophyInfo