local jokerInfo = {
	name = 'aJOreKEsR',
	config = {
		extra = {
			rank_id = 8,
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	hasSoul = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
	artist = 'gote',
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.rank_id}}
end

function jokerInfo.calculate(self, card, context)
	if context.mod_handlevel and context.arrow_before_level then
        local tick_cards = {}
		local hand_level = context.before
        for _, v in ipairs(context.scoring_hand) do
            if v:get_id() == card.ability.extra.rank_id then
				hand_level = hand_level + 1
                tick_cards[#tick_cards+1] = v
            end
        end

		if #tick_cards == 0 then return end

		for i, v in ipairs(tick_cards) do
			local fake_level = context.arrow_before_level + i
			local fake_mult = math.max(G.GAME.hands[context.handname].s_mult + G.GAME.hands[context.handname].l_mult*(fake_level - 1), 1)
			local fake_chips = math.max(G.GAME.hands[context.handname].s_chips + G.GAME.hands[context.handname].l_chips*(fake_level - 1), 0)
			G.E_MANAGER:add_event(Event({
				func = function()
					card:juice_up()
					v:juice_up()
					update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0, immediate = true}, {
						mult = fake_mult,
						chips = fake_chips,
						StatusText = true,
						level = '+1'
					})
					update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0.5, immediate = true}, {level=fake_level})
					play_sound('card1')
				return true
			end }))
			delay(0.7)
		end

		return {
			numerator = hand_level
		}
    end
end

return jokerInfo