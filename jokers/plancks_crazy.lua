local jokerInfo = {
	name = 'Crazy Creaking Joker',
	config = {
		extra = {
			saved_abilities = {

			},
			minDis = 0,
			maxDis = 0.4,
			mod = 0.08,
		},
	},
	rarity = 3,
	cost = 9,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = "plancks",
}

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.joker_destroyed and context.removed ~= card and context.removed.ability.name ~= 'Crazy Creaking Joker' then	
		local chips_diff =  context.removed.ability.chips ~= 0 and context.removed.config.center.config.chips ~= context.removed.ability.chips
		local mult_diff = context.removed.ability.mult ~= 0 and context.removed.config.center.config.mult ~= context.removed.ability.mult
		local x_mult_diff = context.removed.ability.x_mult ~= 1 and context.removed.config.center.config.x_mult ~= context.removed.ability.x_mult
		local extra_val_diff = context.removed.ability.extra_value ~= 0 and context.removed.config.center.config.extra_value ~= context.removed.ability.extra_value
		local extra_diff = not deep_compare(context.removed.config.center.config.extra, context.removed.ability.extra)
		if chips_diff or mult_diff or x_mult_diff or extra_val_diff or extra_diff then
			card.ability.extra.saved_abilities[context.removed.ability.name] = {}
			if chips_diff then card.ability.extra.saved_abilities[context.removed.ability.name].chips = context.removed.ability.chips end
			if mult_diff then card.ability.extra.saved_abilities[context.removed.ability.name].mult = context.removed.ability.mult end
			if x_mult_diff then card.ability.extra.saved_abilities[context.removed.ability.name].x_mult = context.removed.ability.x_mult end
			if extra_val_diff then card.ability.extra.saved_abilities[context.removed.ability.name].extra_val = context.removed.ability.extra_value end
			if extra_diff then card.ability.extra.saved_abilities[context.removed.ability.name].extra = context.removed.ability.extra end
		end
	end

	if context.cardarea == G.jokers and context.joker_created and context.new_joker ~= card then			
		if context.new_joker.ability.name == 'Crazy Creaking Joker' then
			context.new_joker.ability.extra.saved_abilities = card.ability.extra.saved_abilities
		elseif card.ability.extra.saved_abilities[context.new_joker.ability.name] then
			local saved_ability = card.ability.extra.saved_abilities[context.new_joker.ability.name]
			if saved_ability.chips then context.new_joker.ability.chips = saved_ability.chips end
			if saved_ability.mult then context.new_joker.ability.mult = saved_ability.mult end
			if saved_ability.x_mult then context.new_joker.ability.x_mult = saved_ability.x_mult end
			if saved_ability.extra_val then context.new_joker.ability.extra_value = saved_ability.extra_val end
			if saved_ability.extra then context.new_joker.ability.extra = saved_ability.extra end
			card.ability.extra.saved_abilities[context.new_joker.ability.name] = nil
			context.new_joker:set_cost()

			G.E_MANAGER:add_event(Event({
				blockable = false,
				trigger = 'after', 
				func = function()
					context.new_joker.ability.make_vortex = true
					context.new_joker:explode(nil, 0.6, true)
					G.E_MANAGER:add_event(Event({
						blockable = false,
						trigger = 'after', 
						delay = 1.2, 
						func = function()
							context.new_joker.ability.make_vortex = nil
							return true 
						end
					}))
					card_eval_status_text(context.new_joker or card, 'extra', nil, nil, nil, {message = localize('k_revived'), colour = G.C.DARK_EDITION, sound = 'negative', delay = 1.25})
					return true 
				end
			}))
			
		end
	end
end

function jokerInfo.update(self, card, dt)
	if not card.ability.extra.initialized then
		card.ability.extra.direction = 1
		card.ability.extra.lerp = 0
		
		-- initialize dissolve values
		card.ability.extra.disRange = card.ability.extra.maxDis - card.ability.extra.minDis
		card.dissolve = 0.15
		card.forceID = math.random() * 1000
		card.dissolve_colours = {G.C.GREY, G.C.WHITE, G.C.CLEAR, G.C.CLEAR, G.C.JOKER_GREY}

		card.ability.extra.initialized = true
	end

	if card.ability.extra.direction > 0 and card.ability.extra.lerp < 1 then
		card.ability.extra.lerp = card.ability.extra.lerp + dt * card.ability.extra.mod
		local ease = ease_in_out_sin(card.ability.extra.lerp)
		card.dissolve = ease * card.ability.extra.disRange + card.ability.extra.minDis
		if (card.ability.extra.lerp >= 1) then
			card.ability.extra.lerp = 1
			card.ability.extra.direction = -1
		end
	end

	if card.ability.extra.direction < 0 and card.ability.extra.lerp > 0 then
		card.ability.extra.lerp = card.ability.extra.lerp - dt * card.ability.extra.mod
		local ease = ease_in_out_sin(card.ability.extra.lerp)
		card.dissolve = ease * card.ability.extra.disRange + card.ability.extra.minDis
		if (card.ability.extra.lerp <= 0) then
			card.ability.extra.lerp = 0
			card.ability.extra.direction = 1
			card.ability.extra.initialized = false
		end
	end
end

return jokerInfo