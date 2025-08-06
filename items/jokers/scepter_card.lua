local jokerInfo = {
	name = 'Foundation Card',
	config = {
        extra =  {
            mult = 15,
            chance = 2,
        }
    },
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'scepter',
		},
        custom_color = 'scepter',
    },
	artist = 'gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'fnwk_scepter_card')
    return { vars = {num, dom, card.ability.extra.mult}}
end

function jokerInfo.calculate(self, card, context)
    if not (context.individual and context.cardarea == G.play) then
		return
	end

    if card.debuff or context.other_card.debuff then
        return
    end

    if SMODS.pseudorandom_probability(card, 'fnwk_scepter_card', 1, card.ability.extra.chance, 'fnwk_scepter_card') then
        return
    end

    if not context.other_card:is_face() then
        return
    end

    return {
        mult = card.ability.extra.mult,
        colour = G.C.RED,
        card = context.blueprint_card or card
    }
end

return jokerInfo