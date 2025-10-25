local sleeveInfo = {
    name = 'Arcane Sleeve',
    config = { select_limit = 1 },
    unlocked = false,
    unlock_condition = { deck = "b_fnwk_gotequest_arcane", stake = "stake_green" },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
}

sleeveInfo.loc_vars = function(self, info_queue)
    local key
    if self.get_current_deck_key() == "b_fnwk_gotequest_arcane" then
        key = self.key .. "_alt"
        self.config.consumable_slot = nil
    else
        key = self.key
        self.config.consumable_slot = -1
    end
    return { key = key, vars = {self.config.select_limit, self.config.stand_limit_mod, self.config.consumable_slot} }
end

sleeveInfo.apply = function(self, sleeve)
    ArrowAPI.game.consumable_selection_mod(self.config.select_limit)

    CardSleeves.Sleeve.apply(sleeve)
end

return sleeveInfo