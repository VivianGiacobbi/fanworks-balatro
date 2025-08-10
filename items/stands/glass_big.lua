local consumInfo = {
    name = 'Big Poppa',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            x_mult = 2,
            chance = 2,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'glass',
		},
        custom_color = 'glass',
    },
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'fnwk_glass_big')
    return { vars = { card.ability.extra.x_mult, num, dom }}
end

function consumInfo.calculate(self, card, context)
    if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_stone') then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            extra = {
                x_mult = card.ability.extra.x_mult,
                card = context.other_card
            }
        }
    end

    if not context.blueprint and not context.retrigger_joker and context.destroy_card and context.cardarea == G.play and not context.repetition then
        if SMODS.has_enhancement(context.destroy_card, 'm_stone')
        and SMODS.pseudorandom_probability(card, 'fnwk_glass_big', 1, card.ability.extra.chance, 'fnwk_glass_big') then
            return {
                remove = true
            }
        end
    end
end

return consumInfo