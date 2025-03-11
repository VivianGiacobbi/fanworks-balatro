local jokerInfo = {
    key = 'j_fnwk_glass_jokestar',
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
	perishable_compat = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_coop", set = "Other"}
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult} }
end

function jokerInfo.calculate(self, card, context)
    if not context.cardarea == G.jokers or card.debuff then
        return
    end

    if context.joker_main and card.ability.extra.mult > 0 then
        return {
			message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult} },
			card = context.blueprint_card or card,
            color = G.C.MULT,
			mult_mod = card.ability.extra.mult,
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
    return {
        message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult} },
        card = context.blueprint_card or card,
        color = G.C.MULT,
    }
end

return jokerInfo