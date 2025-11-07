local jokerInfo = {
    name = "Feel Like Killing It",
    config = {
        extra = {
			x_mult = 1,
            x_mult_mod = 1,
            x_mult_max = 9
		}
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
	artist = 'SegaciousCejai',
    programmer = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            card.ability.extra.x_mult_mod,
            card.ability.extra.x_mult_max,
            card.ability.extra.x_mult
        }
    }
end

function jokerInfo.load(self, card, card_table, other_card)
    card.config.center.soul_pos = { x = card_table.ability.extra.x_mult + 1, y = 0}
    card:set_sprites(card.config.center)
end

function jokerInfo.calculate(self, card, context)
    if context.remove_playing_cards and not card.debuff  and not context.blueprint then
        local scale_table = {x_mult_mod = card.ability.extra.x_mult_mod * #context.removed}
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "x_mult",
            scalar_table = scale_table,
            scalar_value = "x_mult_mod",
            no_message = true,
        })
        card.ability.extra.x_mult = math.min(card.ability.extra.x_mult_max, card.ability.extra.x_mult)
        if card.ability.extra.x_mult == card.ability.extra.x_mult_max then
            check_for_unlock({type = 'gotequest_itgoes'})
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                card.config.center.soul_pos = { x = card.ability.extra.x_mult + 1, y = 0}
                card:set_sprites(card.config.center)
                return true
            end
        }))

        return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
            card = card,
        }
    end

    if context.end_of_round and context.main_eval and not context.blueprint then
        if card.ability.extra.x_mult > 1 then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "x_mult",
                scalar_value = "x_mult_mod",
                operation = "-",
                no_message = true,
            })

            G.E_MANAGER:add_event(Event({
                func = function()
                    card.config.center.soul_pos = { x = card.ability.extra.x_mult + 1, y = 0}
                    card:set_sprites(card.config.center)
                    return true
                end
            }))

            return {
                card = card,
                message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra.x_mult_mod}},
            }
        end
	end

    if not context.joker_main or card.debuff then return end

    if card.ability.extra.x_mult > 1 then
		return {
            x_mult = card.ability.extra.x_mult,
            card = context.blueprint_card or card,
        }
	end
end

return jokerInfo