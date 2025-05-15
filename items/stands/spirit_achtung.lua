local consumInfo = {
    name = 'Achtung Baby',
    set = 'csau_Stand',
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
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'spirit',
    in_progress = true,
    requires_stands = true,
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

    if context.pre_draw and not context.individual then
        G.deck.cards[#G.deck.cards].joker_force_facedown = true
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
                card = context.other_card
            }
        }
    end

    if context.after and context.scoring_name == card.ability.extra.evolve_hand then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.FUNCS.csau_evolve_stand(card)
                return true 
            end 
        }))
    end
end

return consumInfo