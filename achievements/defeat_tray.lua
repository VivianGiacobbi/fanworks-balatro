local trophyInfo = {
    rarity = 2,
    hidden_text = true,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "defeat_tray" then
            return true
        end
    end,
}

return trophyInfo