local jokerInfo = {
    name = 'Jokers of Fortune',
    config = {
        extra = {
            x_mult_mod = 1,
            hand_compare = 9,
        }
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jojojidai',
		},
        custom_color = 'jojojidai',
    },
    artist = 'jester'
}

function jokerInfo.loc_vars(self, info_queue, card)
    if not G.hand then
        return { vars = { card.ability.extra.x_mult_mod, card.ability.extra.hand_compare, 1 }}
    end

    return {
        vars = {
            card.ability.extra.x_mult_mod,
            card.ability.extra.hand_compare,
            1 + (card.ability.extra.hand_compare - G.hand.config.card_limit) * card.ability.extra.x_mult_mod 
        }
    }
end

function jokerInfo.calculate(self, card, context)
    if not context.joker_main or card.debuff then
        return
    end

    if card.ability.extra.hand_compare - G.hand.config.card_limit > 0 then
        local x_mult = 1 + (card.ability.extra.hand_compare - G.hand.config.card_limit) * card.ability.extra.x_mult_mod
		return {
            card = context.blueprint_card or card,
            x_mult = x_mult,
        }
	end
end

return jokerInfo