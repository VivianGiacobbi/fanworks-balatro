SMODS.Sound({
	key = "gyahoo",
	path = "yahouuu.ogg",
})
SMODS.Sound({
	key = "sludge",
	path = "sludge.ogg",
})

SMODS.Atlas({ key = 'fanworks_jogarc_dark', path = 'jokers/fanworks_jogarc_dark.png', px = 71, py = 95 })
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
	fanwork = 'fanworks',
}

local function try_transform_sludgemass(card, added_card)
	if card.ability.form == 'sludge' or not G.jokers then
		return
	end

	local transform = false
	for i=1, #G.jokers.cards do
		if FnwkStringStartsWith(G.jokers.cards[i].config.center.key, 'j_fnwk_crimson_') then
			transform = true
			break
		end
	end

	if not transform then
		return
	end

	card.config.center.atlas = 'fnwk_fanworks_jogarc_dark'
    card:set_sprites(card.config.center)
	card.ability.water_time = 0
	card.ability.form = 'sludge'
	card:juice_up(0.8)
	play_sound('fnwk_sludge', 1, 0.5)
end

local function try_revert_sludgemass(card, removed_card)
	if card.ability.form == 'garc' then
		return
	end

	local transform = true
	for i=1, #G.jokers.cards do
		if G.jokers.cards[i] ~= removed_card and FnwkStringStartsWith(G.jokers.cards[i].config.center.key, 'j_fnwk_crimson_') then
			transform = false
			break
		end
	end

	if not transform then 
		return
	end

	card.config.center.atlas = 'fnwk_fanworks_jogarc'
    card:set_sprites(card.config.center)
	card.ability.form = 'garc'
	card.ability.water_time = nil
	card:juice_up(0.4)
	play_sound('fnwk_gyahoo', 1, 0.5)
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.gar}}  
    return {
		vars = {
			card.ability.extra.mult,
			card.ability.extra.x_mult
		}
	}
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	local info_key = 'j_fnwk_fanworks_jogarc'
	if card.ability.form == 'sludge' then
		info_key = info_key..'_sludge'
	end
	if card.config.center.discovered then
		-- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
		full_UI_table.name = localize{type = 'name', key = info_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
	end
	localize{type = 'descriptions', key = info_key, set = self.set, nodes = desc_nodes, vars = self.loc_vars(self, info_queue, card).vars}
end

function jokerInfo.update(self, card, dt)
	if card.ability.water_time then
		card.ability.water_time = card.ability.water_time + G.real_dt
	end
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	try_transform_sludgemass(card, card)
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	if from_debuff then
		return
	end

	try_transform_sludgemass(card, card)
end

function jokerInfo.calculate(self, card, context)

	if card.debuff then
		return
	end

	if context.cardarea == G.jokers and context.joker_main then
		if card.ability.form == 'sludge' then
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
				card = context.blueprint_card or card,
				Xmult_mod = card.ability.extra.mult,
			}
		else
			return {
				message = localize{type='variable',key='a_mult',vars={card.ability.extra.x_mult}},
				card = context.blueprint_card or card,
				mult_mod = card.ability.extra.x_mult,
			}
		end
	end

	if (context.buying_card or (context.joker_created and context.cardarea == G.jokers)) and not context.blueprint then
            
        if context.card == card then
            return
        end

		try_transform_sludgemass(card, context.card)
    end

	if context.selling_card or context.joker_destroyed then
		try_revert_sludgemass(card, context.card)
	end
end

return jokerInfo