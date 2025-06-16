local jokerInfo = {
	name = 'Vasos y Besos',
	config = {
		extra = {
			base = 1,
			stand_mod = 1
		},
		fnwk_vasos_mod = 0
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'rockhard',
	alt_art = true,
	dependencies = {'ArrowAPI'},
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cringe }}
	return { vars = {card.ability.extra.base, card.ability.extra.base + card.ability.extra.stand_mod}}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	local stand = G.FUNCS.get_leftmost_stand()
	local mod = card.ability.extra.base + (stand and card.ability.extra.stand_mod or 0)
	G.consumeables:change_size(mod)
	card.ability.fnwk_vasos_mod = card.ability.fnwk_vasos_mod + mod
end

function jokerInfo.calculate(self, card, context)
	if context.card_added and context.card.ability.set == 'Stand'
	and card.ability.fnwk_vasos_mod < (card.ability.extra.base + card.ability.extra.stand_mod) then
		G.consumeables:change_size(card.ability.extra.stand_mod)
		card.ability.fnwk_vasos_mod = card.ability.fnwk_vasos_mod + card.ability.extra.stand_mod
	end

	if context.fnwk_card_removed and context.card.ability.set == 'Stand' and card.ability.fnwk_vasos_mod > card.ability.extra.base then
		if G.FUNCS.get_leftmost_stand() then
			return
		end
		G.consumeables:change_size(-card.ability.extra.stand_mod)
		card.ability.fnwk_vasos_mod = card.ability.fnwk_vasos_mod - card.ability.extra.stand_mod
	end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	local stand = G.FUNCS.get_leftmost_stand()
	local mod = card.ability.extra.base + (stand and card.ability.extra.stand_mod or 0)
	G.consumeables:change_size(-mod)
	card.ability.fnwk_vasos_mod = card.ability.fnwk_vasos_mod - mod
end

return jokerInfo