local achInfo = {
    rarity = 1,
    config = {num_stands = 12},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'upto0',
		},
        custom_color = 'upto0',
    },
}

function achInfo.loc_vars(self)
    return {vars = {self.config.num_stands}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'discover_amount' then return false end

    return G.DISCOVER_TALLIES.stands.tally >= self.config.num_stands
end

return achInfo