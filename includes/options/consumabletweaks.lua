if not fnwk_enabled['enableConsumableTweaks'] then
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
            batch_level_up(card, SMODS.PokerHands)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end,
    },
    true
)