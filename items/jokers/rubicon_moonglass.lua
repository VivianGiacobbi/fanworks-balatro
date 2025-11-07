local jokerInfo = {
	name = 'Moonglass Joker',
	config = {
        extra = 3
    },
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'rubicon',
		},
        custom_color = 'rubicon',
    },
	artist = 'CreamSodaCrossroads',
    programmer = 'Vivian Giacobbi',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_glass
    return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra, 'fnwk_rubicon_bone')}}
end

function jokerInfo.calculate(self, card, context)
    if not context.before or card.debuff then return end

    for _, v in ipairs(context.scoring_hand) do
        if v:is_suit('Spades') and v.config.center.key ~= 'm_glass' and
        SMODS.pseudorandom_probability(card, 'fnwk_rubicon_bone', 1, card.ability.extra, 'fnwk_rubicon_bone') then
            v:set_ability(G.P_CENTERS.m_glass, nil, 'manual')

            -- flip first
            G.E_MANAGER:add_event(Event({
                func = function()
                    v:flip()
                    play_sound('card1')
                    v:juice_up(0.3, 0.3)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    v:set_sprites(v.config.center)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    v:flip()
                    play_sound('tarot2', 1, 0.6)
                    v:juice_up(0.3, 0.3)
                    return true
                end
            }))

            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                message = localize('k_glass_ex'),
                colour = G.C.GREY,
                delay = 0.3
            })
        end
    end
end

return jokerInfo