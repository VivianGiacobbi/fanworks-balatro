local consumInfo = {
    name = "They're Red Hot",
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FD5F55DC', 'FDA200DC' },
        extra = {
            suits = {
                ['Hearts'] = true,
                ['Diamonds'] = true
            },
            x_mult = 1,
            x_mult_mod = 0.5
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'sunshine',
		},
        custom_color = 'sunshine',
    },
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { 
        vars = {
            card.ability.extra.x_mult_mod,
            card.ability.extra.x_mult,
            localize('Hearts', 'suits_plural'),
            localize('Diamonds', 'suits_plural'),
            colours = {
                G.C.SUITS['Hearts'],
                G.C.SUITS['Diamonds'],
            }
        }
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main and card.ability.extra.x_mult > 1 then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            extra = {
                message_card = flare_card,
                Xmult = card.ability.extra.x_mult
            }
        }
    end

    if context.blueprint or context.retrigger_joker then return end

    if context.before then
        local all_suit = true
        for _, v in ipairs(context.full_hand) do
            if not card.ability.extra.suits[v.base.suit] then
                all_suit = false
                break
            end
        end

        if not all_suit then return end

        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
        return {
            func = function()
                ArrowAPI.stands.flare_aura(card, 0.5)
            end,
            extra = {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                card = card
            }
        }
    end
end

return consumInfo