---------------------------
--------------------------- Jokers to implement scale context features
---------------------------

SMODS.Atlas({ key = 'scalers', path = "jokers/scalers.png", px = 71, py = 95, prefix_config = false })

SMODS.Joker({
	name = 'Increment Scaler',
    key = 'scaler_inc',
    prefix_config = false,
    atlas = 'scalers',
    pos = { x = 0, y = 0},
    loc_txt = {
        ['en-us'] = {
            name = 'Scale Incrementer',
            text = {
                "This Joker gains {C:mult}+#1#{} Mult",
                "when another Joker {C:attention}scales{}",
                "{C:inactive}(Currently{} {C:mult}+#2#{} {C:inactive}Mult){}"
            }
        }
    },
	config = {
        extra =  {
            mult = 0,
            mult_mod = 2
        },
        prevent_proxy = true,
    },
	rarity = 1,
	cost = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_mod, card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end

        if context.card_scale then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            return {
                scale_message = localize('k_upgrade_ex'),
                colour = G.C.FILTER
            }
        end

        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
})


SMODS.Joker({
	name = 'Mod Scaler',
    key = 'scaler_mod',
    prefix_config = false,
    atlas = 'scalers',
    pos = { x = 1, y = 0},
    loc_txt = {
        ['en-us'] = {
            name = 'Scale Modder',
            text = {
                "{C:attention}Doubles{} Joker {C:attention}scaling{}"
            }
        }
    },
	config = {
        extra =  {
            mod = 2,
        },
        prevent_proxy = true,
    },
	rarity = 1,
	cost = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
    calculate = function(self, card, context)
    if context.blueprint then return end
    
        if context.card_scale then
            return {
                scale_mod = card.ability.extra.mod
            }
        end
    end
})

SMODS.Joker({
	name = 'Prevent Scaler',
	key = 'scaler_prevent',
    prefix_config = false,
    atlas = 'scalers',
    pos = { x = 2, y = 0},
    loc_txt = {
        ['en-us'] = {
            name = 'Scale Preventer',
            text = {
                "{C:attention}Prevents{} Joker {C:attention}scaling{}"
            }
        }
    },
	config = {
        prevent_proxy = true,
    },
	rarity = 1,
	cost = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,

	calculate = function(self, card, context)
	if context.blueprint then return end
		if context.card_scale then
			return {
				prevent_scale = true
			}
		end
	end,
})