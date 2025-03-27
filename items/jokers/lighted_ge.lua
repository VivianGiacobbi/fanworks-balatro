local jokerInfo = {
	key = 'j_fnwk_lighted_ge',
	name = 'Photograph', -- set to gypsy eyes after inheriting photograph's effects
	config = {
		extra = {
			chance = 3,
			remaining = 5,
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	fanwork = 'lighted',
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
	return { vars = {G.GAME.probabilities.normal, card.ability.extra.chance, card.ability.extra.remaining}}
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
	card.name = 'Gypsy Eyes'
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint or card.debuff then
		return
	end

	if not context.repetition and (context.individual and context.cardarea == G.play) and not context.other_card.debuff then
			
		local other_card = context.other_card
		if not other_card:is_face() or other_card.seal or card.ability.extra.remaining <= 0 then
			return
		end

		local seed_result = pseudorandom(pseudoseed('ge'))
		if seed_result < G.GAME.probabilities.normal / card.ability.extra.chance then
			if not next(SMODS.find_card('j_csau_bunji')) then
				card.ability.extra.remaining = card.ability.extra.remaining - 1
			end
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.8,
				blocking = false,
				func = function()
					other_card:set_seal(SMODS.poll_seal({guaranteed = true, type_key = 'wereputtingslursinbalatro'}), nil, true)
					other_card:juice_up()
					return true
				end
			}))

			return {
				message = localize('k_ge'),
				message_card = card,
			}
		end
	end


	if context.after and card.ability.extra.remaining <= 0 then
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('tarot1')
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.states.drag.is = true
				card.children.center.pinch.x = true
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.3,
					blockable = false,
					func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
						return true 
					end
				})) 
				return true
			end
		})) 
		return {
			message = localize('k_drank_ex'),
			colour = G.C.FILTER,
			message_card = card
		}
	end
end

return jokerInfo