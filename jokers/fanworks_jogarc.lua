SMODS.Atlas({ key = 'fanworks_jogarc_mask', path = 'jokers/fanworks_jogarc_mask.png', px = 71, py = 95 })
SMODS.Atlas({ key = '100', path = '100.png', px = 64, py = 64 })

local jokerInfo = {
	key = 'j_fnwk_fanworks_jogarc',
	name = 'Jogarc',
	config = {
		extra = {
            mult = 4,
			x_mult = 4,
		},
        form = 'garc',
		water_time = 0,
        water_atlas = 'fnwk_fanworks_jogarc_mask'
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

local function transform_sludgemass(card, transform)


end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gar", set = "Other"}       
    return {vars = { card.ability.extra.mult }}
end

function jokerInfo.calculate(self, card, context)

	if context.joker_main and context.cardarea == G.jokers and not card.debuff then
		return {
            message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
            card = context.blueprint_card or card,
            mult_mod = card.ability.extra.mult,
        }
	end
	
end

return jokerInfo