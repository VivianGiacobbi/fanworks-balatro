local consumInfo = {
    name = 'A Stranger I Remain',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'CDE3F0DC', 'EC9BEEDC' },
        evolved = true,
        extra = {
            x_mult = 2,
            non_hand = 'High Card',
            hand_gain = 1
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'spirit',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = { card.ability.extra.x_mult, card.ability.extra.non_hand, card.ability.extra.hand_gain }}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.pre_draw and context.individual then
        context.drawn.joker_force_facedown = true
	end

    if context.before and context.scoring_name ~= card.ability.extra.non_hand then
        ease_hands_played(card.ability.extra.hand_gain)
        local key_var = card.ability.extra.hand_gain == 1 and 'a_hand' or 'a_hands'
        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(card, 0.38)
            end,
            card = card,
            message = localize{type = 'variable', key = key_var, vars = {card.ability.extra.hand_gain}},
            colour = G.C.BLUE
        }
    end

    if context.individual and context.cardarea == G.play and context.other_card.ability.played_while_flipped then
        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(card, 0.5)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    func = function()
                        card:juice_up()
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