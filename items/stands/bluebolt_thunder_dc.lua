local consumInfo = {
    name = 'Thunderstruck D/C',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { '3EA8F3DC', '009CFDDC' },
        evolve_key = 'c_fnwk_bluebolt_thunder',
        evolved = true,
        extra = {
            destroy_hand = 'Flush',
            x_mult = 5,
        }
    },
    cost = 8,
    rarity = 'arrow_EvolvedRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'bluebolt',
    in_progress = true,
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.destroy_hand, card.ability.extra.x_mult}}
end

function consumInfo.calculate(self, card, context)
    if not context.blueprint and context.destroy_card and context.cardarea == G.play and next(context.poker_hands[card.ability.extra.destroy_hand]) then
        card.ability.fnwk_thunder_dc_activated = true
        return {
            remove = true
        }
    end

    if context.individual and context.cardarea == G.play and next(context.poker_hands[card.ability.extra.destroy_hand]) then
        return {
            func = function()
                G.FUNCS.flare_stand_aura(context.blueprint_card or card, 0.5)
            end,
            extra = {
                x_mult = card.ability.extra.x_mult,
                message_card = context.other_card
            }    
        }
    end

    if not context.blueprint and context.remove_playing_cards and context.scoring_hand then
        return {
            func = function()
                G.FUNCS.flare_stand_aura(card, 0.5)
            end,
        }
    end

    if not context.blueprint and context.after and card.ability.fnwk_thunder_dc_activated then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.FUNCS.evolve_stand(card, localize('k_stand_devolved'))
                card.ability.evolved = false
                return true 
            end 
        }))
    end
end

return consumInfo