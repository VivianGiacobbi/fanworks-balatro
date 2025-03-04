local jokerInfo = {
	name = 'Speedwagon Foundation Card',
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
	fanwork = 'scepter',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
    return { vars = {G.GAME.probabilities.normal, card.ability.extra.chance, card.ability.extra.mult}}
end

function jokerInfo.calculate(self, card, context)
    if not (context.individual and context.cardarea == G.play) then
		return
	end

    if card.debuff or context.other_card.debuff then
        return
    end

    if pseudorandom('scepter_card') >= G.GAME.probabilities.normal/card.ability.extra.chance then 
        return
    end

    if not context.other_card:is_face() then
        return
    end

    return {
        mult = card.ability.extra.mult,
        colour = G.C.RED,
        card = card
    }
end

return jokerInfo