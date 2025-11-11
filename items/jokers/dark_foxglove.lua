local jokerInfo = {
    name = 'Golden Heart',
    config = {
        extra = {
            mult = 30,
            mult_mod = 6,
            sell_value = 90,
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'dark',
		},
        custom_color = 'dark',
    },
    artist = 'Vivian Giacobbi',
    programmer = 'Vivian Giacobbi'
}

function jokerInfo.loc_vars(self, info_queue, card)
    if not card.ability.eternal then
        info_queue[#info_queue + 1] = { set = "Other", key = "eternal" }
    end

    return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod } }
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
    if not self.discovered and not card.bypass_discovery_center then
        return
    end

    card:set_eternal(true)
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main and card.ability.extra.mult > 0 then
        return {
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card
        }
    end

    if context.blueprint then return end

    if context.before and context.scoring_name == 'Straight Flush' then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                card:set_eternal(false)
                return true
            end
        }))
        return {
            message = localize('k_cured'),
            card = card
        }
    end

    if context.end_of_round and context.main_eval and card.ability.extra.mult > 0 then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "mult",
            scalar_value = "mult_mod",
            operation = '-',
            scaling_message = {
                message = localize { type = 'variable', key = 'a_mult_minus', vars = {card.ability.extra.mult_mod} },
                card = card,
                color = G.C.MULT,
            }
        })
    end
end

return jokerInfo