local consumInfo = {
    name = 'Neon Trees',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'E8C9FCDC', '8A71E1DC' },
        extra = {
			rounds_val = 4,
			current_rounds = 0,
            num_tags = 2,
            tag_key = 'tag_voucher',
		},
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
    artist = 'piano',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            card.ability.extra.rounds_val,
            card.ability.extra.current_rounds,
            card.ability.extra.num_tags,
            localize{type = 'name_text', key = card.ability.extra.tag_key, set = 'Tag'}
        }
    }
end

function consumInfo.calculate(self, card, context)
    if not context.blueprint and not context.retrigger_joker and context.skip_blind and card.ability.extra.current_rounds > 0 then
        card.ability.extra.current_rounds = 0
        return {
            card = card,
            message = localize('k_reset')
        }
    end

    if context.setting_blind then
        if card.ability.extra.current_rounds + 1 >= card.ability.extra.rounds_val then		
            local flare_card = context.blueprint_card or card
            ArrowAPI.stands.flare_aura(flare_card, 0.5)
            card_eval_status_text(flare_card, 'extra', nil, nil, nil, {message = localize('k_method_4')})
            for i=1, card.ability.extra.num_tags do
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_voucher'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
                delay(0.4)
            end
        elseif not context.blueprint and not context.retrigger_joker then
            return {
                message = localize('k_method_'..card.ability.extra.current_rounds+1),
                colour = G.C.STAND
            }
        end
    end

    if context.first_hand_drawn and not context.blueprint and not context.retrigger_joker then
        card.ability.extra.current_rounds = card.ability.extra.current_rounds + 1
        if card.ability.extra.current_rounds >= card.ability.extra.rounds_val then
            card.ability.extra.current_rounds = 0
        end
    end
end

return consumInfo