local consumInfo = {
    name = 'Thunderstruck D/C',
    set = 'Stand',
    config = {
        stand_mask = true,
        stand_shadow = 0,
        aura_colors = { 'BBDFEDDC', '71BEF2DC' },
        evolve_key = 'c_fnwk_bluebolt_thunder',
        extra = {
            destroy_hand = 'Flush',
            x_mult = 5,
        }
    },
    cost = 8,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'bluebolt',
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.set_card_type_badge(self, card, badges)
    badges[1] = create_badge(localize('k_stand_advanced'), get_type_colour(self or card.config, card), nil, 1.2)
end

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.coop }}
    return { vars = {card.ability.extra.destroy_hand, card.ability.extra.x_mult}}
end

function consumInfo.calculate(self, card, context)
    if not context.blueprint and not context.joker_retrigger and context.destroy_card and context.cardarea == G.play and next(context.poker_hands[card.ability.extra.destroy_hand]) then
        card.ability.fnwk_thunder_dc_activated = true
        return {
            remove = true
        }
    end

    if context.individual and context.cardarea == G.play and next(context.poker_hands[card.ability.extra.destroy_hand]) then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                G.FUNCS.flare_stand_aura(flare_card, 0.5)
            end,
            extra = {
                x_mult = card.ability.extra.x_mult,
                message_card = context.other_card
            }    
        }
    end

    if not context.blueprint and context.remove_playing_cards and context.scoring_hand and not context.joker_retrigger then
        return {
            func = function()
                G.FUNCS.flare_stand_aura(card, 0.5)
            end,
        }
    end

    if not context.blueprint and context.after and card.ability.fnwk_thunder_dc_activated and not context.joker_retrigger then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.FUNCS.evolve_stand(card, localize('k_stand_revert'))
                card.ability.evolved = false
                return true 
            end 
        }))
    end
end

return consumInfo