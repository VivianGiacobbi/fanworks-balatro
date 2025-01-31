local jokerInfo = {
	name = 'Depressed Brother',
	config = {
		trigger_allowed = true,
		extra = {
			chips = 0,
			chip_mod = 50
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "disabled_note", set = "Other"}
	info_queue[#info_queue+1] = {key = "guestartist1", set = "Other"}
	return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_sponge" })
end

-- DISABLED JOKER, this makes it so it never appears in-game
function jokerInfo.in_pool(self, args)
	return false
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and not card.debuff then
		if G.GAME.blind.triggered and not (context.blueprint or context.repetition or context.individual or context.after or context.before) then
			card.ability.trigger_allowed = false
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
		end
		if context.joker_main and card.ability.extra.chips > 0 then
			return {
				message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
				chip_mod = card.ability.extra.chips,
				colour = G.C.CHIPS
			}
		end
	end
end

-- DISABLED JOKER, This should make it so in collection (or if it does somehow appear in game) it's visually debuffed to show its disabled.
function jokerInfo.update(self, card)
	if not card.debuff then
		card.debuff = true
	end
end

return jokerInfo
	