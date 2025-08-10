local consumInfo = {
    name = 'Thunderstruck A/C',
    set = 'Stand',
    config = {
        stand_mask = true,
        stand_shadow = 0,
        aura_colors = { 'BBDFEDDC', '71BEF2DC' },
        evolve_key = 'c_fnwk_bluebolt_thunder_dc',
        extra = {
            avoid_hand = 'Flush',
            x_mult = 2,
            evolve_procs = 0,
            evolve_num = 15
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bluebolt',
		},
		custom_color = 'bluebolt',
	},
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            card.ability.extra.avoid_hand,
            card.ability.extra.x_mult,
            card.ability.extra.evolve_num - card.ability.extra.evolve_procs
        }
    }
end

function consumInfo.calculate(self, card, context)    
    if not context.blueprint and not context.joker_retrigger and context.after and card.ability.extra.evolve_procs >= card.ability.extra.evolve_num then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                ArrowAPI.stands.evolve_stand(card, localize('k_stand_advance'))
                return true 
            end 
        }))
    end

    if not (context.individual and context.cardarea == G.play) then
        return
    end

    if next(context.poker_hands[card.ability.extra.avoid_hand]) or context.other_card == context.scoring_hand[1] then
        return
    end

    if (not context.scoring_hand[1].debuff and SMODS.has_any_suit(context.scoring_hand[1]))
    or (not context.other_card.debuff and SMODS.has_any_suit(context.scoring_hand[1]))
    or context.other_card:is_suit(context.scoring_hand[1].base.suit) then

        if not context.blueprint then
            card.ability.extra.evolve_procs = card.ability.extra.evolve_procs + 1
        end
        
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            extra = {
                Xmult = card.ability.extra.x_mult,
                message_card = context.other_card
            }    
        }
    end
end

return consumInfo