local jokerInfo = {
	name = 'Moscow Mule',
	config = {
		extra = {
			chance = 5
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
	artist = 'Poul Shmidt',
	programmer = 'Vivian Giacobbi'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'fnwk_moscow_mule')} }
end

function jokerInfo.calculate(self, card, context)
	if context.after then
		if G.GAME.fnwk_moscow_changes and G.GAME.fnwk_moscow_changes >= 5 then
			check_for_unlock({type = 'fnwk_moscow_mixed'})
		end

		G.GAME.fnwk_moscow_changes = nil
	end

	if not (context.individual and context.cardarea == G.play)
	or card.debuff or context.other_card.debuff
	or context.other_card.config.center.key ~= 'c_base' then
        return
    end

	if SMODS.pseudorandom_probability(card, 'fnwk_moscow_mule', 1, card.ability.extra.chance, 'fnwk_moscow_mule') then
		local change_card = context.other_card
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.8,
			blocking = false,
			func = function()
				local rand_enhancement = pseudorandom_element(G.P_CENTER_POOLS['Enhanced'], pseudoseed('fnwk_mule_enhance'))
				change_card:set_ability(G.P_CENTERS[rand_enhancement.key])
				change_card:juice_up()
				return true
			end
		}))

		G.GAME.fnwk_moscow_changes = (G.GAME.fnwk_moscow_changes or 0) + 1

		return {
			message = localize('k_enhanced'),
			card = context.blueprint_card or card,
		}
	end
end

return jokerInfo