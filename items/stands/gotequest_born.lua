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
    artist = 'gote',
}

function consumInfo.loc_vars(self, info_queue, card)
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
    if card.debuff then return end
    if context.before and context.scoring_name == 'Straight' and context.poker_hands['Straight'][1].fnwk_valid_born_straight then
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

return consumInfo