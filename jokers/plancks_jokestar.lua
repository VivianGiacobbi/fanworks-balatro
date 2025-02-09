local jokerInfo = {
    name = 'Creaking Bjokestar',
    config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.2,
        }
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    fanwork = 'plancks',
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_mod} }
end

function jokerInfo.calculate(self, card, context)
    if context.before and context.cardarea == G.jokers then
        local matchTable = { 2, 3, 5, 8, 14 }
        local handTable = {}
        for i=1, #context.full_hand do
            handTable[#handTable+1] = context.full_hand[i]:get_id()
        end
        table.sort(handTable, function (a, b) return a < b end)
        for i=1, #matchTable do
            if handTable[i] ~= matchTable[i] then
                return
            end
        end
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod	
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}}, colour = G.C.MULT})
    end
	if context.joker_main and context.cardarea == G.jokers and not card.debuff and card.ability.extra.x_mult > 1 then
		return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
            card = context.blueprint_card or card,
            Xmult_mod = card.ability.extra.x_mult,
        }
	end
end

return jokerInfo