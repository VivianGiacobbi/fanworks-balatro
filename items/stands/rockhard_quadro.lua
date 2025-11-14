local consumInfo = {
	name = 'Quadrophenia',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { '6A62D2DC', 'B64038DC' },
        extra = {
            hand = 'Four of a Kind',
            tarots = {'c_death', 'c_hanged_man'}
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
	artist = 'Stupisms',
    programmer = 'Vivian Giacobbi',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.tarots[1]]
    info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.tarots[2]]
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
    if context.debuff then return end

    if context.after and context.scoring_name == card.ability.extra.hand and G.GAME.current_round.hands_played == 0 then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

        local tarots = {}
        for i, v in ipairs(card.ability.extra.tarots) do
            if not G.GAME.banned_keys[v] then
                tarots[#tarots+1] = v
            end
        end

        if #tarots == 0 then return end

        local random_tarot = pseudorandom_element(tarots, pseudoseed('fnwk_quadro'))
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
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
                message_card = flare_card,
                message = localize('k_plus_tarot'),
            },
        }
	end
end

return consumInfo