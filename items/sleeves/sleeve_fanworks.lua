local sleeveInfo = {
    name = 'Fanworks Sleeve',
    config = { fnwk_jokers_rate = 2, fnwk_jokers_rate_alt = 1.5, },
    unlocked = false,
    unlock_condition = { deck = "b_fnwk_fanworks", stake = "stake_green" },
}

sleeveInfo.loc_vars = function(self, info_queue)
    local key, vars
    if self.get_current_deck_key() == "b_fnwk_fanworks" then
        key = self.key .. "_alt"
        vars = { localize{type = 'name_text', key = 'v_overstock_plus', set = 'Voucher'}, self.config.fnwk_jokers_rate_alt }
        self.config.voucher = "v_overstock_plus"
    else
        key = self.key
        vars = { localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}, self.config.fnwk_jokers_rate }
        self.config.voucher = "v_overstock_norm"
    end
    return { key = key, vars = vars }
end

sleeveInfo.apply = function(self, sleeve)
    if self.get_current_deck_key() == "b_fnwk_fanworks" then
        G.GAME.starting_params.fnwk_jokers_rate = G.GAME.starting_params.fnwk_jokers_rate or 1
        G.GAME.starting_params.fnwk_jokers_rate = G.GAME.starting_params.fnwk_jokers_rate * sleeve.config.fnwk_jokers_rate
    else
        G.GAME.starting_params.fnwk_jokers_rate = G.GAME.starting_params.fnwk_jokers_rate or 1
        G.GAME.starting_params.fnwk_jokers_rate = G.GAME.starting_params.fnwk_jokers_rate * sleeve.config.fnwk_jokers_rate_alt
    end
    CardSleeves.Sleeve.apply(sleeve)
end

return sleeveInfo