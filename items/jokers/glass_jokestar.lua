local jokerInfo = {
	name = 'Starry-Eyed Jokestar',
	config = {
        extra = {
            mult = 0,
            mult_mod = 2,
        }
    },
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'glass',
		},
        custom_color = 'glass',
    },
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult} }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then
        return
    end

    if context.joker_main and card.ability.extra.mult > 0 then
        return {
			mult = card.ability.extra.mult,
			card = context.blueprint_card or card,
		}
    end


    if context.blueprint or not (context.remove_playing_cards or context.playing_card_added) then
        return
    end

    local count = 0
    count = count + (context.playing_card_added and #context.cards or 0)
    count = count + (context.remove_playing_cards and #context.removed or 0)

    if count == 0 then
        return
    end

    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * count
    local scale_table = { mult_mod = card.ability.extra.mult_mod * count }
    SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = "mult",
        scalar_table = scale_table,
        scalar_value = "mult_mod"
    })
    return {
        message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult} },
        card = card,
        color = G.C.MULT,
    }
end

return jokerInfo