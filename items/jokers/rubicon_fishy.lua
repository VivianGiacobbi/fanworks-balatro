local jokerInfo = {
	name = 'Fishy Jokestar',
	config = {},
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'rubicon',
		},
        custom_color = 'rubicon',
    },
	artist = 'cream',
}

function jokerInfo.calculate(self, card, context)
    if not (context.individual and context.cardarea == G.play) then
		return
	end
    if card.debuff then
        return
    end

    local return_table = { }
    if context.other_card.ability.bonus > 0 then return_table.chips = context.other_card.ability.bonus end
    if context.other_card.ability.x_chips and context.other_card.ability.x_chips > 1 then return_table.x_chips = context.other_card.ability.x_chips end
    if context.other_card.ability.mult > 0 then 
        if context.other_card.ability.effect == "Lucky Card" and SMODS.pseudorandom_probability(self, 1, 5, 'lucky_mult') then
            context.other_card.lucky_trigger = true
            return_table.mult = context.other_card.ability.mult
        else
            return_table.mult = context.other_card.ability.mult 
        end
    end

    if context.other_card.ability.x_mult and context.other_card.ability.x_mult > 1 then return_table.x_mult =  context.other_card.ability.x_mult end

    if context.other_card.ability.p_dollars > 0 then 
        if context.other_card.ability.effect == "Lucky Card" and SMODS.pseudorandom_probability(self, 1, 15, 'lucky_money') then
            context.other_card.lucky_trigger = true
            return_table.p_dollars = context.other_card.ability.p_dollars
        else 
            return_table.p_dollars = context.other_card.ability.p_dollars
        end
    end

    local enhancement = context.other_card:calculate_enhancement(context)
    if enhancement then
        SMODS.trigger_effects({{enhancement = enhancement}}, context.other_card)
    end

    if next(return_table) then
        return return_table
    end
end

return jokerInfo