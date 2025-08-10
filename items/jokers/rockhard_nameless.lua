SMODS.Atlas({ key = 'rockhard_nameless_mask', path = 'jokers/rockhard_nameless_mask.png', px = 71, py = 95 })

local jokerInfo = {
    key = 'j_fnwk_rockhard_nameless',
	name = 'Endless Nameless',
	config = {
        extra = {
            mult = 0,
            mult_mod = 1
        },
        water_time = 0,
        water_atlas = 'fnwk_rockhard_nameless_mask'
    },
	rarity = 1,
	cost = 6,
    hasSoul = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'rockhard',
		},
        custom_color = 'rockhard',
    },
	artist = 'cringe',
}

local function levels_over_one()
    local levels = 0
    for k, v in ipairs(SMODS.PokerHand.obj_buffer) do
        if SMODS.PokerHands[v].visible then
            levels = levels + G.GAME.hands[v].level - 1
        end
    end
    return levels
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.mult_mod, levels_over_one() * card.ability.extra.mult_mod }}
end

function jokerInfo.update(self, card, dt)
    card.ability.water_time = card.ability.water_time + G.real_dt
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and not card.debuff and levels_over_one() > 0 then
        return {
            mult = levels_over_one() * card.ability.extra.mult_mod,
            card = context.blueprint_card or card
        }
    end

    if context.blueprint then return end
    
end

return jokerInfo