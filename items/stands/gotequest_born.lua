local consumInfo = {
    name = 'BORN 2B WILD',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            ranks = {'2', '5', '8', 'Jack', 'Ace'}
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
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return {
        vars = {
            card.ability.extra.ranks[1],
            card.ability.extra.ranks[2],
            card.ability.extra.ranks[3],
            card.ability.extra.ranks[4],
            card.ability.extra.ranks[5]
        }
    }
end

function consumInfo.calculate(self, card, context)
    if context.before and context.scoring_name == 'Straight' then
        local rank_map = {}
        local hand_ranks = {}
        for _, v in ipairs(card.ability.extra.ranks) do
            rank_map[v] = true
        end

        local count = 0
        for _, v in pairs(context.scoring_hand) do
            if rank_map[v.base.value] and not hand_ranks[v.base.value] then
                count = count + 1
                hand_ranks[v.base.value] = true
            end
        end

        if count >= card.ability.extra.ranks then
            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    ArrowAPI.stands.flare_aura(flare_card, 1.5)
                end,
                extra = {
                    level_up = true,
                    message_card = flare_card
                }
            }
        end
    end
end

return consumInfo