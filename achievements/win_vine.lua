local trophyInfo = {
    rarity = 3,
    hidden_text = true,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == 'win_deck' then
            if get_deck_win_stake('b_fnwk_vine') then
                return true
            end
        end
    end,
}

return trophyInfo