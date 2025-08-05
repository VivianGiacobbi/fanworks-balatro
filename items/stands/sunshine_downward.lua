local consumInfo = {
    name = 'Downward Spiral',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'D36DD4DC', 'A3E7F6DC' },
        extra = {
            x_mult = 3,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'sunshine',
		},
        custom_color = 'sunshine',
    },
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.x_mult}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.debuff_hand and not context.blueprint and not context.retrigger_joker then
        local most_played, num_played = ArrowAPI.game.get_most_played_hand()
        if num_played > 0 and most_played ~= context.scoring_name then
            return {
                debuff = true,
                debuff_text = localize{type='variable',key='downward_warn_text',vars={localize(most_played, 'poker_hands')}},
                debuff_source = card
            }
        end
    end

    if context.joker_main then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            extra = {
                message_card = flare_card,
                Xmult = card.ability.extra.x_mult
            }
        }
    end
end

return consumInfo