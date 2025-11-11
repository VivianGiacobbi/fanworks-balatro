SMODS.Sound({
	key = "crocodile",
	path = "crocodile.ogg",
})
SMODS.Sound({
	key = "carry_on",
	path = "carry_on.ogg",
})

SMODS.Sound({
	key = "stereo",
	path = "stereo.ogg",
})

local jokerInfo = {
	name = 'Tuned Rust Joker',
	config = {
		extra = {
			mult = 10,
			x_mult = 1.5
		},
		tuned_mode = 'none',
	},
	rarity = 1,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'bluebolt',
		},
		custom_color = 'bluebolt',
	},
	artist = 'Vivian Giacobbi',
	programmer = 'Vivian Giacobbi'
}

local function update_tuned_mode(card)
	if not card.area or card.area ~= G.jokers then
		return
	end

	if card.rank == card.ability.last_idx and card.ability.last_count == #card.area.cards and card.ability.last_area == card.area then
		return
	end

	card.ability.last_count = #card.area.cards
	card.ability.last_idx = card.rank
	card.ability.last_area = card.area

	if card.ability.last_idx == #card.area.cards and card.ability.last_idx == 1 then
		if card.ability.tuned_mode == 'stereo' then
			return
		end

		card.ability.tuned_mode = 'stereo'
		card_eval_status_text(card, 'extra', nil, nil, nil, {
			message = localize('k_tuned_stereo'),
			colour = G.C.RED,
			sound = 'fnwk_crocodile',
			extra = {
				instant = true
			}
		})

	elseif card.ability.last_idx == #card.area.cards then
		if card.ability.tuned_mode == 'mult' then
			return
		end

		card.ability.tuned_mode = 'mult'
		card_eval_status_text(card, 'extra', nil, nil, nil, {
			message = localize('k_tuned_mult'),
			colour = G.C.RED,
			sound = 'fnwk_crocodile',
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
			message = localize('k_tuned_xmult'),
			colour = G.C.RED,
			sound = 'fnwk_carry_on',
		})
	else
		if card.ability.tuned_mode == 'none' then
			return
		end
		card.ability.tuned_mode = 'none'
		card_eval_status_text(card, 'extra', nil, nil, nil, {
			message = localize('k_reset'),
		})
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.mult,
			card.ability.extra.x_mult,
		},
		key = self.key..(card.ability.tuned_mode == 'none' and '' or '_'..card.ability.tuned_mode)
	}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	update_tuned_mode(card)
end

function jokerInfo.calculate(self, card, context)

	if context.blueprint then
		return
	end
	if not context.cardarea == G.jokers or not context.joker_main or card.debuff then
		return
	end

	if card.ability.tuned_mode == 'stereo' then
		return {
			mult = card.ability.extra.mult,
			xmult = card.ability.extra.x_mult,
		}
	elseif card.ability.tuned_mode == 'xmult' then
		return {
			xmult = card.ability.extra.x_mult,
		}
	elseif card.ability.tuned_mode == 'mult' then
		return {
			mult = card.ability.extra.mult,
		}
	end
end

function jokerInfo.update(self, card, dt)
	update_tuned_mode(card)
end

return jokerInfo