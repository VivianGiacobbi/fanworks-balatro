local jokerInfo = {
	name = "Cousin's Club",
	config = {
		extra = {
			chips = 0,
			chip_mod = 1
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "guestartist0", set = "Other"}
	return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_cousinsclub" })
end

function jokerInfo.calculate(self, card, context)
	if context.individual and context.cardarea == G.play and not card.debuff and not context.blueprint and context.other_card:is_suit('Clubs') then
		local chip = card.ability.extra.chip_mod
		if next(context.poker_hands['Flush']) then
			chip = chip * 2
		end
		card.ability.extra.chips = card.ability.extra.chips + chip
		return {
			extra = {focus = card, message = next(context.poker_hands['Flush']) and localize('k_upgrade_double_ex') or localize('k_upgrade_ex'), colour = G.C.CHIPS},
			card = card
		}
	end
	if context.joker_main and context.cardarea == G.jokers then
		return {
			message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
			chip_mod = card.ability.extra.chips, 
			colour = G.C.CHIPS
		}
	end
end



return jokerInfo
	