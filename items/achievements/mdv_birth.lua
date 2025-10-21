local achInfo = {
    rarity = 1,
    config = {num_mods = 2},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'mdv',
		},
        custom_color = 'mdv',
    },
}

function achInfo.loc_vars(self)
    return {vars = {self.config.num_mods}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'use_consumable'
    or args.consumable.config.center.key ~= 'c_lovers' then return false end

    return args.consumable.ability.max_highlighted
    and args.consumable.ability.max_highlighted >= self.config.num_mods
    and #G.hand.highlighted >= self.config.num_mods
end

return achInfo