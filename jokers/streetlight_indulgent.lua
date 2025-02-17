SMODS.Atlas({
	key = "glow_1",
	path = "glow_1.png",
	px = 69,
	py = 93
})

SMODS.Atlas({
	key = "glow_2",
	path = "glow_2.png",
	px = 79,
	py = 106
})

SMODS.Atlas({
	key = "glow_3",
	path = "glow_3.png",
	px = 87,
	py = 111
})

local jokerInfo = {
	name = 'Indulgent Streetlit Joker',
	config = {
		extra = {
			x_mult = 1,
			x_mult_mod = 0.25,
			spend_val = 30,
			current_spend = 0,
			max_dist = 3,
			glow_step = 0.2,
		},
	},
	rarity = 2,
	cost = 12,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'streetlight',
}

function jokerInfo.loc_vars(self, info_queue, card)
        
    return { 
		vars = {
			card.ability.extra.x_mult_mod,
			card.ability.extra.spend_val,
			card.ability.extra.current_spend,
			card.ability.extra.x_mult
		}
	}
end

function jokerInfo.calculate(self, card, context)

	if context.joker_main and context.cardarea == G.jokers and not card.debuff and card.ability.extra.x_mult > 1 then
		return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
            card = context.blueprint_card or card,
            Xmult_mod = card.ability.extra.x_mult,
        }
	end
	
	if not context.blueprint and context.cardarea == G.jokers and context.ending_shop then
		card.ability.extra.current_spend = 0
	end

	if not context.blueprint and card.ability.extra.current_spend < card.ability.extra.spend_val then
		if context.cardarea == G.jokers and context.buying_card then 
			card.ability.extra.current_spend = card.ability.extra.current_spend + context.card.cost
		elseif context.cardarea == G.jokers and context.open_booster then
			card.ability.extra.current_spend = card.ability.extra.current_spend + context.card.cost
		end

		if card.ability.extra.current_spend >= card.ability.extra.spend_val then
			card.ability.extra.current_spend = card.ability.extra.spend_val
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
			return {
				card = card,
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
				colour = G.C.RED
			}
		end
	end
end

function jokerInfo.update(self, card, dt)

	G.NEON_VALS.AMT = G.NEON_VALS.AMT + 0.0001	
	update_jokers_glow(card)
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	update_jokers_glow(card, true)
end

function update_jokers_glow(card, removed)
	
	-- reset the area it was moved from
	if (card.ability.glow_area and card.ability.glow_area ~= card.area) or (card.ability.glow_area and removed) then
		sendDebugMessage('Removed: '..tostring(removed))
		for i=1, #card.ability.glow_area.cards do
			sendDebugMessage('Resetting '..i)
			card.ability.glow_area.cards[i].ability.glow = nil
			card.ability.glow_area.cards[i].no_shadow = false
			card.ability.glow_area.cards[i].children.glow_sprite = nil
		end
	end

	if not card.area or (card.area ~= G.jokers and card.area ~= G.shop_jokers and card.area ~= G.pack_cards) then

		card.ability.glow_area = nil
		return
	end
	
	local joker_idx = 1
	local area_changed = #card.area.cards ~= (card.ability.old_glow_cards and #card.ability.old_glow_cards or -1)
	for i=1, #card.area.cards do
		if card.area.cards[i] == card then joker_idx = i end
		if not area_changed and card.area.cards[i].ID ~= card.ability.old_glow_cards[i] then
			area_changed = true
		end
	end
	
	-- don't do potentially expensive sprite creation if nothing has changed
	if not area_changed and card.ability.glow_area == card.area and joker_idx == card.ability.glow_idx then
		return
	end

	card.ability.glow_area = card.area
	card.ability.glow_idx = joker_idx

	if card.ability.glow_area then
		card.ability.old_glow_cards = {}
		for i=1, #card.ability.glow_area.cards do
			card.ability.old_glow_cards[#card.ability.old_glow_cards+1] = card.ability.glow_area.cards[i].ID
		end
	end
	

	for i=1, #card.ability.glow_area.cards do
		local dist = math.abs(card.ability.glow_idx - i)
		local dist_mod = (card.ability.extra.max_dist - dist + 1)
		local glow_card = card.ability.glow_area.cards[i]
		if i ~= card.ability.glow_idx and dist <= card.ability.extra.max_dist then
			local glow = 1 + (card.ability.extra.glow_step * fact(dist_mod))
			glow_card.ability.glow = glow
			glow_card.no_shadow = true


			local scale_x = G.ASSET_ATLAS['fnwk_glow_'..dist_mod].px / glow_card.children.center.atlas.px
			local scale_y = G.ASSET_ATLAS['fnwk_glow_'..dist_mod].py / glow_card.children.center.atlas.py
			if glow_card.ability.set ~= 'Joker' then scale_x = scale_x * 0.9 end
			local glow_width = glow_card.T.w * scale_x
			local glow_height = glow_card.T.h * scale_y
			local x_offset = (glow_width - glow_card.T.w) / 2
			local y_offset = (glow_height - glow_card.T.h) / 2
			
			glow_card.children.glow_sprite = Sprite(
				glow_card.T.x - x_offset,
				glow_card.T.y - y_offset,
				glow_width,
				glow_height,
				G.ASSET_ATLAS['fnwk_glow_'..dist_mod],
				glow_card.children.center.config.pos
			)
			glow_card.children.glow_sprite:set_role({
				role_type = 'Minor',
				major = glow_card,
				offset = { x = -x_offset, y = -y_offset },
				xy_bond = 'Strong',
				wh_bond = 'Weak',
				r_bond = 'Strong',
				scale_bond = 'Weak',
				draw_major = glow_card
			})
			glow_card.children.glow_sprite:align_to_major()
			glow_card.children.glow_sprite.custom_draw = true
		else
			glow_card.children.glow_sprite = nil
			glow_card.ability.glow = nil
			glow_card.no_shadow = false
		end
	end
end


return jokerInfo