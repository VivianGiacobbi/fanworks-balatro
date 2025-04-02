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
    fanwork = 'gotequest',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_cejai", set = "Other"}
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
    if context.remove_playing_cards and context.cardarea == G.jokers and not context.debuffed then
        for i=1, #context.removed do
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
        end
        card.ability.extra.x_mult = math.min(card.ability.extra.x_mult_max, card.ability.extra.x_mult)
        G.E_MANAGER:add_event(Event({
            func = function()
                card.config.center.soul_pos = { x = card.ability.extra.x_mult + 1, y = 0}
                card:set_sprites(card.config.center)
                card:juice_up()
                return true
             end
        }))
        return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
            card = card,
        }
    end

    if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
        if card.ability.extra.x_mult > 1 then
            card.ability.extra.x_mult = card.ability.extra.x_mult - card.ability.extra.x_mult_mod
            G.E_MANAGER:add_event(Event({
                func = function()
                    card.config.center.soul_pos = { x = card.ability.extra.x_mult + 1, y = 0}
                    card:set_sprites(card.config.center)
                    card:juice_up()
                    return true
                end
            }))
            return {
                card = card,
                message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra.x_mult_mod}},
            }
        end
	end

    if not (context.joker_main and context.cardarea == G.jokers) or card.debuff then
        return
    end

    if card.ability.extra.x_mult > 1 then
		return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
            card = context.blueprint_card or card,
            Xmult_mod = card.ability.extra.x_mult,
        }
	end
end

return jokerInfo