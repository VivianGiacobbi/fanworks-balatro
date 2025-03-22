local jokerInfo = {
	name = 'Stand-Off Spreadsheet',
	config = {
        extra = {
            chips = 30,
            mult = 15,
            x_mult = 3,
        }
    },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'fanworks',
    in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult }}
end

return jokerInfo