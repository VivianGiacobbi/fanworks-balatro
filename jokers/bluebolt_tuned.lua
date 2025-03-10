SMODS.Sound({
	key = "breaking",
	path = "breaking.ogg",
})
SMODS.Sound({
	key = "saul",
	path = "saul.ogg",
})

local jokerInfo = {
	key = 'j_fnwk_bluebolt_tuned',
	name = 'Tuned Rust Joker',
	config = {
		extra = {
			mult = 10,
			x_mult = 1.5
		},
		tune_mode = 'none',
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'bluebolt'
}

local function update_tuned_mode(card)
	if not card.area or card.area ~= G.jokers then
		return
	end

	local joker_idx = 1
	for i=1, #card.area.cards do
		if card.area.cards[i] == card then 
			joker_idx = i 
			break
		end
	end

	if joker_idx == card.ability.last_idx and card.ability.last_count == #card.area.cards and card.ability.last_area == card.area then
		return
	end

	card.ability.last_count = #card.area.cards
	card.ability.last_idx = joker_idx
	card.ability.last_area = card.area

	if card.ability.last_idx == #card.area.cards then
		if card.ability.tuned_mode == 'mult' then
			return
		end

		card.ability.tuned_mode = 'mult'
		card_eval_status_text(card, 'extra', nil, nil, nil, {
			message = localize('k_tuned_m'),
			colour = G.C.RED,
			sound = 'fnwk_breaking',
			extra = {
				instant = true
			}
		})
	elseif card.ability.last_idx == 1 then
		if card.ability.tuned_mode == 'xmult' then
			return
		end

		card.ability.tuned_mode = 'xmult'
		card_eval_status_text(card, 'extra', nil, nil, nil, {
			message = localize('k_tuned_x'),
			colour = G.C.RED,
			sound = 'fnwk_saul',
			extra = {
				instant = true
			}
		})
	else
		if card.ability.tuned_mode == 'none' then
			return
		end
		card.ability.tuned_mode = 'none'
		card_eval_status_text(card, 'extra', nil, nil, nil, {
			message = localize('k_reset'),
			extra = {
				instant = true
			}
		})
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artist_winter", set = "Other"}
	
	local mult_display = ''
	local x_mult_display = ''
	local text_display = ' Mult'
	if card.ability.tuned_mode == 'mult' then
		mult_display = '+'..card.ability.extra.mult
	elseif card.ability.tuned_mode == 'xmult' then
		x_mult_display = 'X'..card.ability.extra.x_mult
	else
		text_display = 'None'
	end

    return { 
		vars = {
			card.ability.extra.mult,
			card.ability.extra.x_mult,
			mult_display,
			x_mult_display,
			text_display
		}
	}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	update_tuned_mode(card)
end

function jokerInfo.calculate(self, card, context)
	if not context.cardarea == G.jokers or not context.joker_main or card.debuff then
		return
	end

	if card.ability.tuned_mode == 'xmult' then
		return {
			message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
			card = context.blueprint_card or card,
			Xmult_mod = card.ability.extra.x_mult,
		}
	elseif card.ability.tuned_mode == 'mult' then
		return {
			message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult} },
			card = context.blueprint_card or card,
			mult_mod = card.ability.extra.mult,
		}
	end
end

function jokerInfo.update(self, card, dt)
	update_tuned_mode(card)
end

return jokerInfo