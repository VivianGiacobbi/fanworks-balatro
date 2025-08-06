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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'rockhard',
		},
        custom_color = 'rockhard',
    },
	artist = 'cringe',
	alt_art = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.base, card.ability.extra.base + card.ability.extra.stand_mod}}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	local stand = ArrowAPI.stands.get_leftmost_stand()
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

	if context.removed_card and context.removed_card.ability.set == 'Stand' and card.ability.fnwk_vasos_mod > card.ability.extra.base then
		if ArrowAPI.stands.get_leftmost_stand() then
			return
		end
		G.consumeables:change_size(-card.ability.extra.stand_mod)
		card.ability.fnwk_vasos_mod = card.ability.fnwk_vasos_mod - card.ability.extra.stand_mod
	end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	local stand = ArrowAPI.stands.get_leftmost_stand()
	local mod = card.ability.extra.base + (stand and card.ability.extra.stand_mod or 0)
	G.consumeables:change_size(-mod)
	card.ability.fnwk_vasos_mod = card.ability.fnwk_vasos_mod - mod
end

return jokerInfo