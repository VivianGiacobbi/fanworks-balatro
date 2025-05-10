if not fnwk_enabled['enableVanillaTweaks'] then
    return
end

SMODS.Consumable:take_ownership('c_hermit',
    {
        use = function(self, card, area, copier)
            if card.ability.name == 'The Hermit' then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    play_sound('timpani')
                    card:juice_up(0.3, 0.5)
                    if G.GAME.dollars < 0 then
                        ease_dollars(math.max(-card.ability.extra, G.GAME.dollars), true)
                    else
                        ease_dollars(math.min(G.GAME.dollars, card.ability.extra), true)
                    end
                    return true end }))
                delay(0.6)
            end
        end,
    },
    true
)

SMODS.Consumable:take_ownership('c_black_hole',
    {
        use = function(self, card, area, copier)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true end }))
            update_hand_text({delay = 0}, {mult = '+', StatusText = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                return true end }))
            update_hand_text({delay = 0}, {chips = '+', StatusText = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true end }))
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
            delay(1.3)
            fnwk_batch_level_up(card, SMODS.PokerHands)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end,
    },
    true
)

SMODS.Joker:take_ownership('j_throwback', {
    loc_vars = function(self, info_queue, card)
        if not G.GAME then
            return { vars = { card.ability.extra, 1 }}
        end

        return { vars = {card.ability.extra, 1 + card.ability.extra * G.GAME.skips}}
    end,

    calculate = function(self, card, context)
        if not context.cardarea == G.jokers then return end
        
        if context.joker_main and G.GAME.skips > 0 then
            local x_mult = 1 + G.GAME.skips * card.ability.extra
            return {
                message = localize{type='variable',key='a_xmult',vars={x_mult}},
                colour = G.C.RED,
                Xmult_mod = x_mult,
                card = context.blueprint_card or card
            }
        end
        
        if context.blueprint then return end

        if context.skip_blind then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize{type = 'variable', key = 'a_xmult', vars = {1 + card.ability.extra * G.GAME.skips}},
                        colour = G.C.RED,
                        card = card
                    }) 
                    return true
                end
            }))
            return nil, true
        end
    end

}, true)

SMODS.Joker:take_ownership('j_stencil', {
    loc_vars = function(self, info_queue, card)
        if not G.jokers then
            return { vars = { 1 }}
        end

        local x_mult = (G.jokers.config.card_limit - #G.jokers.cards)
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.name == 'Joker Stencil' then x_mult = x_mult + 1 end
        end
        return { vars = {x_mult}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local x_mult = (G.jokers.config.card_limit - #G.jokers.cards)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'Joker Stencil' then x_mult = x_mult + 1 end
            end
            
            if x_mult > 0 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={x_mult}},
                    Xmult_mod = x_mult
                }
            end
        end
    end

}, true)

SMODS.Joker:take_ownership('j_swashbuckler', {
    loc_vars = function(self, info_queue, card)
        if not G.jokers then
            return { vars = { 0 } }
        else
            local sell_cost = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and (G.jokers.cards[i].area and G.jokers.cards[i].area == G.jokers) then
                    sell_cost = sell_cost + G.jokers.cards[i].sell_cost
                end
            end
            return { vars = { sell_cost } }
        end
    end,

    calculate = function(self, card, context)
        if not context.cardarea == G.jokers then return end
        
        if context.joker_main then
            local sell_cost = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= self and (G.jokers.cards[i].area and G.jokers.cards[i].area == G.jokers) then
                    sell_cost = sell_cost + G.jokers.cards[i].sell_cost * card.ability.extra.mult
                end
            end

            if sell_cost > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={sell_cost}},
                    mult_mod = sell_cost
                }
            end
        end
    end

}, true)

SMODS.Joker:take_ownership('j_duo', { config = { x_mult = 2, type = 'Pair'}} , true)
SMODS.Joker:take_ownership('j_trio', { config = { x_mult = 3, type = 'Three of a Kind'} } , true)
SMODS.Joker:take_ownership('j_family', { config = { x_mult = 4, type = 'Four of a Kind'} } , true)
SMODS.Joker:take_ownership('j_tribe', { config = { x_mult = 2, type = 'Flush'} } , true)
SMODS.Joker:take_ownership('j_order', { config = { extra = 3, type = 'Straight'} } , true)
SMODS.Joker:take_ownership('j_ramen', { config = { x_mult = 2, extra = 0.01} }, true)


SMODS.Joker:take_ownership('j_luchador', {
    loc_vars = function(self, info_queue, card)
        local has_message = (G.GAME and card.area and (card.area == G.jokers))
        local main_end = nil
        if has_message then
            
            local disableable = G.GAME.blind and (G.GAME.blind.boss and not G.GAME.blind.disabled)
            main_end = {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={ref_table = card, align = "m", colour = disableable and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                        {n=G.UIT.T, config={text = ' '..localize(disableable and 'k_active' or 'ph_no_boss_active')..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                    }}
                }}
            }
        end

        return {
            vars = {},
            main_end = main_end
        }
    end,

    calculate = function(self, card, context)
        if context.selling_self then 
            if G.GAME.blind.boss and not G.GAME.blind.disabled then 
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                G.GAME.blind:disable()
                return nil, true
            end
        end      
    end
})