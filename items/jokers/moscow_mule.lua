local jokerInfo = {
	name = 'Moscow Mule',
	config = {
		extra = {
			enhance_chance = 5
		}
	},
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'moscow',
		},
        custom_color = 'moscow',
    },
	artist = 'poul'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {G.GAME.probabilities.normal, card.ability.extra.enhance_chance} }
end

function jokerInfo.calculate(self, card, context)
	if not (context.individual and context.cardarea == G.play) then
		return
	end
    if card.debuff or context.other_card.debuff then
        return
    end

	if context.other_card.config.center.key ~= 'c_base' then
		return { no_retrigger = true }
	end
	
	local seed_result = pseudorandom(pseudoseed('mule_roll'))
	if seed_result < G.GAME.probabilities.normal / card.ability.extra.enhance_chance then
		local change_card = context.other_card
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.8,
			blocking = false,
			func = function()
				local rand_enhancement = pseudorandom_element(G.P_CENTER_POOLS['Enhanced'], pseudoseed('mule_enhance'))
				change_card:set_ability(G.P_CENTERS[rand_enhancement.key])
				change_card:juice_up()
				return true
			end
		})) 

		return {
			message = localize('k_enhanced'),
			card = context.blueprint_card or card,
		}
	end
end

return jokerInfo