local jokerInfo = {
    name = 'Oblivious Jokestar',
    config = {
        extra = {
            rank = 'Queen',
            x_mult = 1,
            x_mult_mod = 0.25
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rebels',
		},
        custom_color = 'rebels',
    },
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {
        card.ability.extra.x_mult_mod,
        card.ability.extra.x_mult
    } }
end

function jokerInfo.calculate(self, card, context)

    if context.joker_main then
        if not context.blueprint then
            local has_queen = false
            for _, v in ipairs(context.scoring_hand) do
                if v.base.value == card.ability.extra.rank then
                    has_queen = true
                    break
                end
            end

            if not has_queen then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "x_mult",
                    scalar_value = "x_mult_mod",
                })

                return
            end
        end

        if card.ability.extra.x_mult > 1 then
            if not context.blueprint then
                card.ability.fnwk_oblivious_reset = true
            end

            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end

    if context.after and card.ability.fnwk_oblivious_reset and not context.blueprint then
        card.ability.fnwk_oblivious_reset = nil
        card.ability.extra.x_mult = 0
        return {
            card = card,
            message = localize('k_reset')
        }
    end
end

return jokerInfo