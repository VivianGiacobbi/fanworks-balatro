local trophyInfo = {
    rarity = 3,
    hidden_text = true,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "red_convert" then
            return true
        end
    end,
}

return trophyInfo