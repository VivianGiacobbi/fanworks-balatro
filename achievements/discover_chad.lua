local trophyInfo = {
    rarity = 1,
    hidden_text = true,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "discover_chad" then
            return true
        end
    end,
}

return trophyInfo