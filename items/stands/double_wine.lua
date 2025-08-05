local consumInfo = {
    name = 'Wine Song',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FB5D53DC', 'A34B6EDC' },
        extra = {
            suits = {
                ['Hearts'] = true,
                ['Diamonds'] = true
            },
            mult_min = 1,
            mult_max = 5
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'double',
		},
        custom_color = 'double',
    },
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}

    local strings = {}
    for i=card.ability.extra.mult_min, card.ability.extra.mult_max do
        strings[#strings+1] = {string = '+'..i, colour = G.C.MULT, outer_colour = G.C.UI.TEXT_DARK, suffix = ' '..(localize('k_mult'))}
    end
    
    local main_end = {{
        n=G.UIT.O, config={object = DynaText({
            string = strings ,
            colours = {G.C.UI.TEXT_DARK}, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.2011, scale = 0.32, min_cycle_time = 0
        })}
    }}

    return { vars = {
            localize('Hearts', 'suits_plural'),
            localize('Diamonds', 'suits_plural'),
            colours = {
                G.C.SUITS['Hearts'],
                G.C.SUITS['Diamonds']
            }
        },
        main_end = main_end
    }
end

function consumInfo.calculate(self, card, context)
    if not (context.individual and context.cardarea == G.hand) or context.end_of_round then
        return
    end

    if card.debuff or context.other_card.debuff or not card.ability.extra.suits[context.other_card.base.suit] then
        return
    end

    local rand_mult = pseudorandom(pseudoseed('fnwk_winesong'), card.ability.extra.mult_min, card.ability.extra.mult_max)
    local flare_card = context.blueprint_card or card
    return {
        func = function()
            ArrowAPI.stands.flare_aura(flare_card, 0.5)
        end,
        extra = {
            mult = rand_mult,
            card = context.other_card
        }
    }
end

return consumInfo