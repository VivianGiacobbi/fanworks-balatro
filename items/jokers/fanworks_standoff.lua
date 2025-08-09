local jokerInfo = {
	name = 'Stand-Off Spreadsheet',
	config = {
        extra = {
            states = {
                ['none'] = {key = 'chips', value = 30},
                ['stand'] = {key = 'mult', value = 15},
                ['evolved'] = {key = 'x_mult', value = 3}
            }
        }
    },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'fanworks',
    artist = 'gote'
}

local function get_stand_state()
    local has_stand = ArrowAPI.stands.get_leftmost_stand()

    if not has_stand then
        return 'none'
    end

    for _, v in ipairs(G.consumeables.cards) do
        if v.ability.set == 'Stand' and v.ability.evolved then
            return 'evolved'
        end
    end

    return 'stand'
end

function jokerInfo.loc_vars(self, info_queue, card)
    local state = get_stand_state()
    return { 
        vars = {
            card.ability.extra.states.none.value,
            card.ability.extra.states.stand.value,
            card.ability.extra.states.evolved.value,
            card.ability.extra.states[state].value
        },
        key = card.config.center.key..'_'..state
    }
end

function jokerInfo.calculate(self, card, context)
    if not context.joker_main then
        return
    end

    local state = get_stand_state()
    return {
        [card.ability.extra.states[state].key] = card.ability.extra.states[state].value
    }
end

return jokerInfo