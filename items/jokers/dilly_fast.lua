SMODS.Joker {
    name = 'Fast Food',
    config = {
        isFood = true,
        extra = {
            chips_bonus = 150,
            max_uses = 2,
            uses_remaining = 2,
        }
    },
    loc_txt = {
        name = 'Fast Food',
        text = {
            'Adds {C:chips}+#1#{} chips',
            'to your next {C:attention}#2#{}',
            'played hands',
            '{C:inactive}(Currently: {C:attention}#3#{} remaining)'
        }
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips_bonus,
                card.ability.extra.max_uses,
                card.ability.extra.uses_remaining
            }
        }
    end,
      
    calculate = function(self, card, context)
        -- Initialize uses_remaining if nil
        if not context.cardarea == G.jokers then
            return
        end
    
        if context.scoring_hand and context.joker_main then
            return {
                message = localize{type='variable', key='a_chips', vars = {card.ability.extra.chips_bonus} },
                chip_mod = card.ability.extra.chips_bonus,
                colour = G.C.CHIPS,
                message_card = context.blueprint_card or card
            }
        end
    
        if context.blueprint then return end
    
        if context.after then
            card.ability.extra.uses_remaining = card.ability.extra.uses_remaining - 1
            if card.ability.extra.uses_remaining > 0 then
                return {
                    message = localize{type='variable', key='a_remaining', vars = {card.ability.extra.uses_remaining} },
                    message_card = context.blueprint_card or card
                }
            end
    
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
                        func = function()
                                G.jokers:remove_card(self)
                                card:remove()
                                card = nil
                            return true; end})) 
                    return true
                end
            }))
        end
    end,
}  
  
