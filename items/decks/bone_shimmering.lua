local deckInfo = {
    name = 'Shimmering Deck',
    config = {
        extra = 2,
    },
    discovered = true,
    unlocked = false,
    unlock_condition = {type = 'fnwk_shop_rerolled', num = 25},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bone',
		},
		custom_color = 'bone',
	},
    artist = 'torch'
}

function deckInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then
        return false
    end

    return args.amt >= self.unlock_condition.num
end

function deckInfo.loc_vars(self, info_queue, card)
    return {vars = {self.config.extra}}
end

function deckInfo.locked_loc_vars(self, info_queue, card)
    return {vars = {self.unlock_condition.num}}
end

function deckInfo.apply(self, back)
    G.GAME.starting_params.fnwk_only_free_rerolls = true
    SMODS.change_free_rerolls(self.config.extra)
end

return deckInfo