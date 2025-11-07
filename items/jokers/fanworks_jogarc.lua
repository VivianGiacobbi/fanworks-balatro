SMODS.Sound({
	key = "gyahoo",
	path = "yahouuu.ogg",
})
SMODS.Sound({
	key = "sludge",
	path = "sludge.ogg",
})

SMODS.Atlas({ key = 'fanworks_jogarc_mask', path = 'jokers/fanworks_jogarc_mask.png', px = 71, py = 95 })
SMODS.Atlas({ key = '100', path = '100.png', px = 64, py = 64 })

local jokerInfo = {
	name = 'Jogarc',
	config = {
		extra = {
            mult = 4,
			x_mult = 4,
		},
        form = 'garc',
        water_atlas = 'fnwk_fanworks_jogarc_mask'
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	artist = 'GarPlatinum',
	programmer = 'Vivian Giacobbi'
}

local function transform_sludgemass(card, to_sludge)
	card.ability.form = to_sludge and 'sludge' or 'garc'

	if to_sludge then
		card.children.center:set_sprite_pos({x = 1, y = 0})
		card.ability.water_time = 0
		card:juice_up(0.8)
		play_sound('fnwk_sludge', 1, 0.5)
		check_for_unlock({type = 'fanworks_gyahoo'})
	else
		card.children.center:set_sprite_pos({x = 0, y = 0})
		card.ability.water_time = nil
		card:juice_up(0.4)
		play_sound('fnwk_gyahoo', 1, 0.5)
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
    return {
		vars = {
			card.ability.extra.mult,
			card.ability.extra.x_mult
		},
		key = self.key..(card.ability.form == 'sludge' and '_sludge' or '')
	}
end

function jokerInfo.update(self, card, dt)
	if card.ability.water_time then
		card.ability.water_time = card.ability.water_time + G.real_dt
	end
end

function jokerInfo.set_sprites(self, card, front)
	if card.ability and card.ability.form == 'sludge' then
		card.children.center:set_sprite_pos({x = 1, y = 0})
		card.ability.water_time = 0
	end
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	for i=1, #G.jokers.cards do
		local obj = G.jokers.cards[i].config.center
		if type(obj.origin) == 'table' and obj.origin.sub_origins[1] == 'crimson' then
			transform_sludgemass(card, true)
			return
		end
	end
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.joker_main then
		local sludge = card.ability.form == 'sludge'
		return {
			x_mult = sludge and card.ability.extra.x_mult,
			mult = not sludge and card.ability.extra.mult,
			card = context.blueprint_card or card,
		}
	end

	if context.blueprint then return end

	if context.card_added and context.card ~= card and card.ability.form == 'garc' then
		local obj = context.card.config.center
		if type(obj.origin) == 'table' and obj.origin.sub_origins[1] == 'crimson' then
			transform_sludgemass(card, true)
		end
    end

	if context.removed_card and context.removed_card ~= card and card.ability.form == 'sludge' then
		for _, v in ipairs(G.jokers.cards) do
			local obj = v.config.center
			if v ~= context.removed_card and type(obj.origin) == 'table'
			and obj.origin.sub_origins[1] == 'crimson' then
				return
			end
		end

		transform_sludgemass(card, false)
	end
end

return jokerInfo