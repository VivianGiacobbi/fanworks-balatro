local consumInfo = {
    key = 'c_fnwk_rockhard_misirlou',
	name = 'Misirlou',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'CE608CDC', '945f7CDC' },
        extra = {
            stone_num = 10,
            enhancement = 'm_wild'
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rockhard',
		},
        custom_color = 'rockhard',
    },
	artist = 'cringe',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.enhancement]
    return { vars = { card.ability.extra.stone_num, localize({type = 'name_text', key = card.ability.extra.enhancement, set = 'Enhanced'})}}
end

function consumInfo.calculate(self, card, context)
    if context.debuff then return end

    if context.press_play and G.GAME.current_round.hands_played == 0 and ArrowAPI.game.get_enhanced_tally(card.ability.extra.enhancement) >= card.ability.extra.stone_num then
        card.ability.fnwk_misirlou_old_hands_left = G.GAME.current_round.hands_left
        G.GAME.current_round.hands_left = 1

        return {
            func = function()
                delay(0.2)
                ArrowAPI.stands.flare_aura(card, 0.5)
            end,
            extra = {
                message = localize('k_misirlou_final'),
                colour = G.C.STAND,
            }
        }
	end

    if context.after and card.ability.fnwk_misirlou_old_hands_left then
        -- main end of round calculation
        SMODS.calculate_context({end_of_round = true, game_over = false })

        -- playing card individual end of round calculation
        for _, v in ipairs(SMODS.get_card_areas('playing_cards', 'end_of_round')) do
            SMODS.calculate_end_of_round_effects({ cardarea = v, end_of_round = true })
        end

        G.GAME.current_round.hands_left = card.ability.fnwk_misirlou_old_hands_left - 1

        -- end of round dollars
        local dollar_bonus = 0
        for _, area in ipairs(SMODS.get_card_areas('jokers')) do
            for _, _card in ipairs(area.cards) do
                local ret = _card:calculate_dollar_bonus()
        
                -- TARGET: calc_dollar_bonus per card
                if ret then
                    dollar_bonus = dollar_bonus + ret

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            attention_text({
                                text = localize{type = 'name_text', set = 'Joker', key = _card.config.center.key},
                                scale = 0.7,
                                hold = 0.5 + 0.1*ret,
                                backdrop_colour = G.C.MONEY,
                                align = 'bm',
                                major = _card,
                                rotate = 0,
                                offset = {x = 0, y = 0.05*G.CARD_H}
                            })
                            return true
                        end
                    }))
                            
                    for i=0, ret do
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.28,
                            func = function()
                                play_sound('coin3', 0.9+0.2*math.random(), 0.7)
                                _card:juice_up(0.2, 0.1)
                                return true
                            end
                        }))
                    end
                    delay(0.46)
                end
            end
        end

        if dollar_bonus > 0 then
            return {
                dollars = dollar_bonus,
                remove_default_message = true
            }
        end
    end
end

return consumInfo