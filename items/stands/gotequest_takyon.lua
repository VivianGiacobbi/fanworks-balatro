local consumInfo = {
    name = 'Takyon',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            current_rank = 2,
            x_mult = 2
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    local rank_key = '2'
    for k, v in pairs(SMODS.Ranks) do
        if v.id == card.ability.extra.current_rank then
            rank_key = k
        end
    end
    return { vars = {rank_key, card.ability.extra.x_mult}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.individual and context.cardarea == G.play
    and context.other_card:get_id() == card.ability.extra.current_rank then
        card.ability.extra.fnwk_takyon_this_hand = true
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

    if context.after and card.ability.extra.fnwk_takyon_this_hand then
        card.ability.extra.current_rank = (card.ability.extra.current_rank + 1) % SMODS.Rank.max_id.value
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            extra = {
                message = localize{type = 'variable', key = 'a_rank', vars = {1}},
            }
        }
    end
end

return consumInfo