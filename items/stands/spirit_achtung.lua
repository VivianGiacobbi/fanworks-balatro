local consumInfo = {
    name = 'Achtung Baby',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'CDE3F0DC', 'EC9BEEDC' },
        evolve_key = 'c_fnwk_spirit_achtung_stranger',
        extra = {
            num_facedown = 1,
            x_mult = 2,
            evolve_hand = 'Five of a Kind'
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'spirit',
    in_progress = true,
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { 
        vars = {
            card.ability.extra.num_facedown,
            card.ability.extra.x_mult,
            card.ability.extra.evolve_hand
        } 
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if not context.blueprint and not context.retrigger_joker and context.drawing_cards then
        G.deck.cards[#G.deck.cards].ability.fnwk_achtung_effect = true
    end

    if not context.blueprint and not context.retrigger_joker and context.stay_flipped and context.other_card.ability.fnwk_achtung_effect then
        context.other_card.ability.fnwk_achtung_effect = nil
        return {
            stay_flipped = true,
        }
    end

    if context.individual and context.cardarea == G.play and context.other_card.ability.played_while_flipped then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                G.FUNCS.flare_stand_aura(flare_card, 0.5)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    func = function()
                        flare_card:juice_up()
                        return true
                    end 
                }))
            end,
            extra = {
                x_mult = card.ability.extra.x_mult,
                card = context.other_card
            }
        }
    end

    if not context.blueprint and not context.retrigger_joker and context.after and context.scoring_name == card.ability.extra.evolve_hand then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.FUNCS.evolve_stand(card)
                return true 
            end 
        }))
    end
end

return consumInfo