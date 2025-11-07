local consumInfo = {
    name = 'Neon Trees',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FDE8EEDC', 'FD7DC0DC' },
        evolve_key = 'c_fnwk_streetlight_neon_favorite',
        extra = {
            enhancement = 'm_gold',
            h_dollars_mod = 3,
            evolve_num = 100,
			current_spend = 0,
        }
    },
    cost = 4,
    hasSoul = true,
    rarity = 'StandRarity',
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist = 'Pianolote',
    programmer = 'Vivian Giacobbi',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            localize{type = 'name_text', set = 'Enhanced', key = card.ability.extra.enhancement},
            card.ability.extra.h_dollars_mod,
            math.max(0, card.ability.extra.evolve_num - card.ability.extra.current_spend),
        }
    }
end

function consumInfo.calculate(self, card, context)
    if context.individual and context.end_of_round and context.cardarea == G.hand
    and SMODS.has_enhancement(context.other_card, card.ability.extra.enhancement) then
        context.other_card.ability.perma_h_dollars = context.other_card.ability.perma_h_dollars + card.ability.extra.h_dollars_mod
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            extra = {
                message = '+$'..card.ability.extra.h_dollars_mod,
                colour = G.C.STAND,
                card = flare_card
            }
        }
    end

    if context.blueprint or context.retrigger_joker then return end

	if context.ending_shop then
		card.ability.extra.current_spend = 0
	end

	if card.ability.extra.current_spend < card.ability.extra.evolve_num then
		if context.buying_card or context.open_booster then
			card.ability.extra.current_spend = card.ability.extra.current_spend + context.card.cost
		elseif context.reroll_shop then
			card.ability.extra.current_spend = card.ability.extra.current_spend + context.cost
		end

		if card.ability.extra.current_spend >= card.ability.extra.evolve_num then
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    ArrowAPI.stands.evolve_stand(card)
                    return true
                end
            }))
		end
	end
end

return consumInfo