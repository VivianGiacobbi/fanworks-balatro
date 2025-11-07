local sleeveInfo = {
    name = 'Shimmering Sleeve',
    config = { rerolls = 2, pack_rerolls = 1 },
    unlocked = false,
    unlock_condition = { deck = "b_fnwk_bone_shimmering", stake = "stake_green" },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bone',
		},
        custom_color = 'bone',
    },
    artist = 'TorchDreemurr',
    programmer = 'Vivian Giacobbi',
}

sleeveInfo.loc_vars = function(self, info_queue)
    local key = self.key
    if self.get_current_deck_key() == "b_fnwk_bone_shimmering" then
        key = key.."_alt"
        self.config.pack_rerolls = 1
    end
    return { key = key, vars = {self.config.rerolls, self.config.pack_rerolls} }
end

sleeveInfo.apply = function(self, sleeve)
    if self.get_current_deck_key() == "b_fnwk_bone_shimmering" then
        G.GAME.starting_params.fnwk_pack_rerolls = (G.GAME.starting_params.fnwk_pack_rerolls or 0) + 1
    else
        G.GAME.starting_params.fnwk_only_free_rerolls = true
        SMODS.change_free_rerolls(self.config.rerolls)
    end
    CardSleeves.Sleeve.apply(sleeve)
end

return sleeveInfo