local jokerInfo = {
	name = 'Evasive Jokestar',
	config = {
        extra = {
            currentDiscount = 0
        }
    },
	rarity = 1,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'bluebolt'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local sign = card.ability.extra.currentDiscount > 0 and '-' or ''
    return { vars = {sign, card.ability.extra.currentDiscount}}
end

function jokerInfo.calculate(self, card, context)

    if context.skip_blind then
        card.ability.extra.currentDiscount = card.ability.extra.currentDiscount + 1
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_discount')})
    end

    if context.cardarea == G.jokers and context.start_shop then
        G.GAME.inflation = G.GAME.inflation - card.ability.extra.currentDiscount
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_discount_apply'), colour = G.C.MONEY})
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true 
        end}))
    end

    if context.cardarea == G.jokers and context.ending_shop then
        G.GAME.inflation = G.GAME.inflation + card.ability.extra.currentDiscount
        card.ability.extra.currentDiscount = 0
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true 
        end}))
        return {
            card = card,
            message = localize('k_reset')
        }
    end
end

return jokerInfo