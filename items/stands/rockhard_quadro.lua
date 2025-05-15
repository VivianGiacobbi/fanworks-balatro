local consumInfo = {
	name = 'Quadrophenia',
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { '6A62D2DC', 'B64038DC' },
        extra = {
            hand = 'Four of a Kind',
            tarots = {'c_death', 'c_hanged_man'}
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'rockhard',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.tarots[1]]
    info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.tarots[2]]
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cringe }}
    return { 
        vars = {
            G.P_CENTERS[card.ability.extra.tarots[1]].name,
            G.P_CENTERS[card.ability.extra.tarots[2]].name,
            card.ability.extra.hand,
            colours = {
                G.C.SECONDARY_SET.Tarot,
                G.C.SECONDARY_SET.Tarot,
            }
        }
    }
end

function consumInfo.calculate(self, card, context)
    if context.after and context.scoring_name == card.ability.extra.hand and G.GAME.current_round.hands_played == 0 then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        local random_tarot = pseudorandom_element(card.ability.extra.tarots, pseudoseed('fnwk_quadro'))
        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(card, 0.5)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                    local new_tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, random_tarot, 'fnwk_quadro')
                    new_tarot:set_edition({negative = true}, true)
                    new_tarot:add_to_deck()
                    G.consumeables:emplace(new_tarot)
                    G.GAME.consumeable_buffer = 0
                    return true end
                }))
            end,
            extra = {
                colour = G.C.SECONDARY_SET.Tarot,
                message_card = card,
                message = localize('k_plus_tarot'),
            },
        }
	end
end

return consumInfo