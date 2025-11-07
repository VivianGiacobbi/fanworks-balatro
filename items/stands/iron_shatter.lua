local consumInfo = {
    name = 'Shatter Me',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            enhancement = 'm_glass',
            reps = 1,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    fanwork = 'iron',
    blueprint_compat = true,
    artist = 'CreamSodaCrossroads',
    programmer = 'Vivian Giacobbi',
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, G.GAME.probabilities.normal, card.ability.extra.chance }}
end

function consumInfo.calculate(self, card, context)
    if context.repetition and context.cardarea == G.play
    and SMODS.has_enhancement(context.other_card, card.ability.extra.enhancement) then
		local flare_card = context.blueprint_card or card
        return {
            pre_func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            message = localize('k_again_ex'),
            repetitions = card.ability.extra.reps,
            card = flare_card,
        }
	end
end

return consumInfo