local jokerInfo = {
	name = 'Quiet Riot',
	config = {
		extra = {
			scoring_name = 'Three of a Kind',
			mult = 0,
			mult_mod = 3,
		}
	},
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'whiplash',
	in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return {
		vars = {
			card.ability.extra.mult_mod,
			card.ability.extra.scoring_name,
			card.ability.extra.mult_mod * (G.GAME.hands and G.GAME.hands[card.ability.extra.scoring_name].played or 0)
		}
	}
end

return jokerInfo