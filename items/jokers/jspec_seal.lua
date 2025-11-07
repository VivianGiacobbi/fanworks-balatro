local jokerInfo = {
	name = 'Seal Joker',
	config = {},
	rarity = 2,
	cost = 5,
	unlocked = false,
	unlock_condition = {type = 'modify_deck'},
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'jspec',
		},
        custom_color = 'jspec',
    },
	artist = 'Plusgal',
	programmer = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then
        return false
    end

	local num_seals = #G.P_CENTER_POOLS['Seal']
	local unique_seals = {}
	local unique_tally = 0
    for _, card in ipairs(G.playing_cards) do
        if card.seal and not unique_seals[card.seal] then
			unique_seals[card.seal] = true
			unique_tally = unique_tally + 1
		end

        if unique_tally >= num_seals then
			return true
		end
    end

    return false
end

function jokerInfo.calculate(self, card, context)
	if card.debuff or context.blueprint then return end
	if not (context.cardarea == G.play and context.individual) or context.other_card.debuff then return end

	if context.other_card.seal == "Purple" then
		context.discard = true
		context.other_card:calculate_seal(context)
		for _, v in ipairs(SMODS.find_card('j_csau_shrimp')) do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0,
				func = function()
					v:juice_up()
					return true
				end
			}))
			card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {message = localize('k_again_ex')})
			context.other_card:calculate_seal(context)
		end
		context.discard = false
    end

	if context.other_card.seal == "Blue" then
		context.other_card:get_end_of_round_effect(context)
		for _, v in ipairs(SMODS.find_card('j_csau_shrimp')) do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0,
				func = function()
					v:juice_up()
					return true
				end
			}))
			card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {message = localize('k_again_ex')})
			context.other_card:get_end_of_round_effect(context)
		end
    end
end

return jokerInfo