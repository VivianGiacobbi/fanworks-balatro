local achInfo = {
    rarity = 2,
    config = {num_mods = 5},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
}

function achInfo.loc_vars(self)
    return {vars = {self.config.num_mods}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'use_consumable' then return false end

    return args.consumable.ability.max_highlighted
    and args.consumable.ability.max_highlighted >= self.config.num_mods
    and #G.hand.highlighted >= self.config.num_mods
end

return achInfo