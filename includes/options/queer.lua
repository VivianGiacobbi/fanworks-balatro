if not fnwk_enabled['enableQueer'] then
    return
end
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
trues
)

SMODS.Consumable:take_ownership('c_wheel_of_fortune',
{
    config = {
        extra = 4,
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        return {
            vars = {
                G.GAME.probabilities.normal,
                self.config.extra
            }
        } 	
    end,
    loc_txt = {
        ['en-us'] = {
            name = "The Wheel of Fortune",
            text = {
                "{C:green}#1# in #2#{} chance to add",
                "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
                "{C:dark_edition}Queer{} edition",
                "to a random {C:attention}Joker"
            }
        }
    }
},
true
)

SMODS.Consumable:take_ownership('c_aura',
{
    loc_txt = {
        ['en-us'] = {
            name = "Aura",
            text = {
                "Add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{},",
                "or {C:dark_edition}Queer{} effect to",
                "{C:attention}1{} selected card in hand"
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
