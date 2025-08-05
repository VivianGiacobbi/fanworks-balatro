local consumInfo = {
    key = 'c_fnwk_rebels_rebel',
    name = 'Rebel Moon',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FD5F55DC', 'FDA200DC' },
        extra = {
            chips = 50,
            mult = 6
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    fanwork = 'rebels',
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rebels',
		},
        custom_color = 'rebels',
    },
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chips, card.ability.extra.mult}}
end

function consumInfo.calculate(self, card, context)
    if context.debuff then return end

    if context.cardarea == G.play and context.individual then
        if SMODS.has_enhancement(context.other_card, 'm_mult') then
            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    ArrowAPI.stands.flare_aura(flare_card, 0.5)
                end,
                extra = {
                    chips = card.ability.extra.chips,
                    card = flare_card
                }
            }
        elseif SMODS.has_enhancement(context.other_card, 'm_bonus') then
            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    ArrowAPI.stands.flare_aura(flare_card, 0.5)
                end,
                extra = {
                    mult = card.ability.extra.mult,
                    card = flare_card
                }
            }
        end
    end
end

return consumInfo