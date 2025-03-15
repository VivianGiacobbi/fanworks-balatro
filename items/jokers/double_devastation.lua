local jokerInfo = {
	name = 'The Devastation',
    config = {extra = {h_size = 3, a_mult = 100}},
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'double',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_notdaedalus", set = "Other"}
    return { vars = { card.ability.extra.h_size, card.ability.extra.a_mult} }
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
        return {
            message = localize{type='variable', key='a_mult', vars = {card.ability.extra.a_mult} },
            mult_mod = card.ability.extra.a_mult,
            colour = G.C.MULT,
            card = context.blueprint_card or card
        }
    end
end

return jokerInfo
