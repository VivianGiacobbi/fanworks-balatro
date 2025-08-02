local consumInfo = {
    name = 'A Stranger I Remain',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'CDE3F0DC', 'EC9BEEDC' },
        evolved = true,
        extra = {
            x_mult = 2,
            non_hand = 'High Card',
            hand_gain = 1
        }
    },
    cost = 4,
    rarity = 'arrow_EvolvedRarity',
    hasSoul = true,
    fanwork = 'spirit',
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.wario }}
    return { vars = { card.ability.extra.x_mult, card.ability.extra.non_hand, card.ability.extra.hand_gain }}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if not context.blueprint and not context.retrigger_joker and context.stay_flipped then
        return {
            stay_flipped = true,
        }
    end

    if context.before and context.scoring_name ~= card.ability.extra.non_hand then
        ease_hands_played(card.ability.extra.hand_gain)
        local key_var = card.ability.extra.hand_gain == 1 and 'a_hand' or 'a_hands'
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                G.FUNCS.flare_stand_aura(flare_card, 0.38)
            end,
            card = flare_card,
            message = localize{type = 'variable', key = key_var, vars = {card.ability.extra.hand_gain}},
            colour = G.C.BLUE
        }
    end

    if context.individual and context.cardarea == G.play and context.other_card.ability.wheel_flipped then
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
end

return consumInfo