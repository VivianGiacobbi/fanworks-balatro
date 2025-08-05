local jokerInfo = {
	name = 'Evasive Jokestar',
	config = {
        extra = {
            currentDiscount = 0
        },
    },
	rarity = 1,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'bluebolt',
		},
		custom_color = 'bluebolt',
	},
    artist = 'winter',
}

function jokerInfo.loc_vars(self, info_queue, card)
    local sign = card.ability.extra.currentDiscount > 0 and '-' or ''
    return { vars = {sign, card.ability.extra.currentDiscount}}
end

function jokerInfo.calculate(self, card, context)

    if context.blueprint then
        return
    end

    if context.skip_blind then
        card.ability.extra.currentDiscount = card.ability.extra.currentDiscount + 1
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_discount')})
    end

    if context.cardarea == G.jokers and context.starting_shop and not context.blueprint then
        G.GAME.inflation = G.GAME.inflation - card.ability.extra.currentDiscount
        if card.ability.extra.currentDiscount ~= 0 then
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_discount_apply'), colour = G.C.MONEY})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, 
            
            func = function()
                for k, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true 
            end}))
        end
    end

    if context.cardarea == G.jokers and context.ending_shop and not context.blueprint then
        if card.ability.extra.currentDiscount ~= 0 then
            G.GAME.inflation = G.GAME.inflation + card.ability.extra.currentDiscount
            card.ability.extra.currentDiscount = 0
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
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
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if card.ability.extra.currentDiscount ~= 0 then
        G.GAME.inflation = G.GAME.inflation + card.ability.extra.currentDiscount
        card.ability.extra.currentDiscount = 0
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true 
        end}))
    end
end

return jokerInfo