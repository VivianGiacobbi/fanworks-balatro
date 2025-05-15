local consumInfo = {
    name = 'Wine Song',
    set = 'csau_Stand',
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
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'double',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {
            localize('Hearts', 'suits_plural'),
            localize('Diamonds', 'suits_plural'),
            colours = {
                G.C.SUITS['Hearts'],
                G.C.SUITS['Diamonds']
            }
        }
    }
end

function consumInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local key = card.config.center.key
    if card.config.center.discovered then
        -- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
        full_UI_table.name = localize{type = 'name', key = key, set = self.set, name_nodes = desc_nodes, vars = specific_vars or {}}
    end
    
    localize{type = 'descriptions', key = key, set = self.set, nodes = desc_nodes, vars = self.loc_vars(self, info_queue, card).vars}

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
    desc_nodes[#desc_nodes+1] = main_end
end

function consumInfo.calculate(self, card, context)
    if not (context.individual and context.cardarea == G.hand) or context.end_of_round then
        return
    end

    if context.other_card.debuf or not card.ability.extra.suits[context.other_card.base.suit] then
        return
    end

    local rand_mult = pseudorandom(pseudoseed('fnwk_winesong'), card.ability.extra.mult_min, card.ability.extra.mult_max)
    return {
        func = function()
            G.FUNCS.csau_flare_stand_aura(card, 0.5)
        end,
        extra = {
            mult = rand_mult,
            card = context.other_card
        }
    }
end

return consumInfo