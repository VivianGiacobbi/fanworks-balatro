local jokerInfo = {
	name = 'Vasos y Besos',
	config = {
		extra = {
			base = 1,
			stand_mod = 1
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'rockhard',
	alt_art = true,
	in_progress = true,
	requires_stands = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cringe }}
	return { vars = {card.ability.extra.base, card.ability.extra.base + card.ability.extra.stand_mod}}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	if from_debuff then return end
	G.consumeables:change_size(card.ability.extra.base)
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	if from_debuff then return end
	G.consumeables:change_size(-card.ability.extra.base)
end

return jokerInfo