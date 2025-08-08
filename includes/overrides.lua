
local ref_glass_calc = SMODS.Centers.m_glass.calculate
SMODS.Enhancement:take_ownership('glass', {
    calculate = function(self, card, context)
        if context.fnwk_dummy_flag then
            sendDebugMessage('dummy flag caught')
        end
        
        local ret, post = ref_glass_calc(self, card, context)
        
        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card
        and not context.destroy_card.glass_trigger then
            local shatter_mes = SMODS.find_card('c_fnwk_iron_shatter')
            local valid = false
            for _, v in ipairs(shatter_mes) do
                if not v.debuff then
                    valid = true
                    break
                end
            end
            
            if valid and SMODS.pseudorandom_probability(card, 'glass', 1, card.ability.extra) then
                card.glass_trigger = true
                ret = ret or {}
                ret.remove = true
            end
        end

        return ret, post
    end,
}, true)

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

if fnwk_enabled['enable_Queer'] then
    SMODS.Edition:take_ownership('e_polychrome',
    {
        loc_txt = {
            ['en-us'] = {
                label = 'Queer',
                name = 'Queer',
                text = {
                    "{X:mult,C:white} X#1# {} Mult"
                }
            }
        }
    },
    true
    )

    SMODS.Voucher:take_ownership('v_hone',
    {
        config = {
            extra = 2,
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    self.config.extra
                }
            } 	
        end,
        loc_txt = {
            ['en-us'] = {
                name = "Hone",
                text = {
                    "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, and",
                    "{C:dark_edition}Queer{} cards",
                    "appear {C:attention}#1#X{} more often"
                }
            }
        }
    },
    true
    )

    SMODS.Voucher:take_ownership('v_glow_up',
    {
        config = {
            extra = 4,
        },
        unlock_condition = 
        {	
            type = 'have_edition',
            extra = 5
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    self.config.extra
                }
            } 	
        end,
        loc_txt = {
            ['en-us'] = {
                name = "Glow Up",
                text = {
                    "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, and",
                    "{C:dark_edition}Queer{} cards",
                    "appear {C:attention}#1#X{} more often"
                },
                unlock = {
                    "Have at least {C:attention}#1#",
                    "{C:attention}Joker{} cards with",
                    "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
                    "{C:dark_edition}Queer{} edition"
                }
            }
        }
    },
    true
    )

    SMODS.Joker:take_ownership('j_bootstraps',
    {
        loc_txt = {
            ['en-us'] = {
                name = "Bootstraps",
                text = {
                    "{C:mult}+#1#{} Mult for every",
                    "{C:money}$#2#{} you have",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
                },
                unlock = {
                    "Have at least {E:1,C:attention}#1#",
                    "{C:dark_edition}Queer{} Jokers"
                }
            }
        }
    },
    true
    )

    SMODS.Consumable:take_ownership('c_hex',
    {
        loc_txt = {
            ['en-us'] = {
                name = "Hex",
                text = {
                    "Add {C:dark_edition}Queer{} to a",
                    "random {C:attention}Joker{}, destroy",
                    "all other Jokers"
                }
            }
        }
    },
    true
    )

    SMODS.Tag:take_ownership('tag_polychrome',
    {
        loc_txt = {
            ['en-us'] = {
                name = "Queer Tag",
                text = {
                    "Next base edition shop",
                    "Joker is free and",
                    "becomes {C:dark_edition}Queer"
                }
            }
        }
    },
    true
    )
end

