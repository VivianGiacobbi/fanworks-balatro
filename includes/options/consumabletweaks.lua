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