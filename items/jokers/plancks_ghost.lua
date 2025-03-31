local jokerInfo = {
	name = 'Ghost Girl',
	config = {
		extra = {
			saved_abilities = {

			},
			minDis = 0,
			maxDis = 0.4,
			mod = 0.2,
			unlock_sell_count = 20
		},
	},
	rarity = 3,
	cost = 6,
	unlocked = false,
	unlock_condition = {type = 'patsy_jokers_sold', amount = 20},
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = "plancks",
	alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_coop", set = "Other"}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.unlock_sell_count}}
end

function jokerInfo.check_for_unlock(self, args)
	if args.type ~= self.unlock_condition.type then
		return false
	end

	return args.amount >= self.unlock_condition.amount
end

function jokerInfo.set_sprites(self, card, front)
	if not card.config.center.discovered then
        return
    end

    card.children.center:set_sprite_pos({x = 1, y = 0})   
	card.children.center.custom_draw = true
    card.children.patsy_overlay = Sprite(
        card.T.x,
        card.T.y,
        card.T.w,
        card.T.h,
        G.ASSET_ATLAS['fnwk_plancks_ghost'],
        { x = 0, y = 0}
    )
	card.children.patsy_overlay:set_role({
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	})
	card.children.patsy_overlay.custom_draw = true
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint then return end
    if context.cardarea == G.jokers and context.joker_destroyed and context.removed ~= card and context.removed.ability.name ~= 'Crazy Creaking Joker' then	
		local chips_diff =  context.removed.ability.chips ~= 0 and context.removed.config.center.config.chips ~= context.removed.ability.chips
		local mult_diff = context.removed.ability.mult ~= 0 and context.removed.config.center.config.mult ~= context.removed.ability.mult
		local x_mult_diff = context.removed.ability.x_mult ~= 1 and context.removed.config.center.config.x_mult ~= context.removed.ability.x_mult
		local extra_val_diff = context.removed.ability.extra_value ~= 0 and context.removed.config.center.config.extra_value ~= context.removed.ability.extra_value
		local extra_diff = not DeepCompare(context.removed.config.center.config.extra, context.removed.ability.extra)
		if chips_diff or mult_diff or x_mult_diff or extra_val_diff or extra_diff then
			card.ability.extra.saved_abilities[context.removed.ability.name] = {}
			if chips_diff then card.ability.extra.saved_abilities[context.removed.ability.name].chips = context.removed.ability.chips end
			if mult_diff then card.ability.extra.saved_abilities[context.removed.ability.name].mult = context.removed.ability.mult end
			if x_mult_diff then card.ability.extra.saved_abilities[context.removed.ability.name].x_mult = context.removed.ability.x_mult end
			if extra_val_diff then card.ability.extra.saved_abilities[context.removed.ability.name].extra_val = context.removed.ability.extra_value end
			if extra_diff then card.ability.extra.saved_abilities[context.removed.ability.name].extra = context.removed.ability.extra end
		end
	end

	if context.cardarea == G.jokers and context.joker_created and context.card ~= card then			
		if context.card.ability.name == 'Crazy Creaking Joker' then
			context.card.ability.extra.saved_abilities = card.ability.extra.saved_abilities
		elseif card.ability.extra.saved_abilities[context.card.ability.name] then
			local saved_ability = card.ability.extra.saved_abilities[context.card.ability.name]
			if saved_ability.chips then context.card.ability.chips = saved_ability.chips end
			if saved_ability.mult then context.card.ability.mult = saved_ability.mult end
			if saved_ability.x_mult then context.card.ability.x_mult = saved_ability.x_mult end
			if saved_ability.extra_val then context.card.ability.extra_value = saved_ability.extra_val end
			if saved_ability.extra then context.card.ability.extra = saved_ability.extra end
			card.ability.extra.saved_abilities[context.card.ability.name] = nil
			context.card:set_cost()

			G.E_MANAGER:add_event(Event({
				blockable = false,
				trigger = 'after', 
				func = function()
					context.card.ability.make_vortex = true
					context.card:explode(nil, 0.6, true)
					G.E_MANAGER:add_event(Event({
						blockable = false,
						trigger = 'after', 
						delay = 1.2, 
						func = function()
							context.card.ability.make_vortex = nil
							return true 
						end
					}))
					card_eval_status_text(context.card or card, 'extra', nil, nil, nil, {message = localize('k_revived'), colour = G.C.DARK_EDITION, sound = 'negative', delay = 1.25})
					return true 
				end
			}))
			
		end
	end
end

function jokerInfo.update(self, card, dt)
	if not card.config.center.discovered then
        return
    end

	if not card.ability.extra.initialized then
		card.ability.extra.direction = 1
		card.ability.extra.lerp = 0
		
		-- initialize dissolve values
		card.ability.extra.disRange = card.ability.extra.maxDis - card.ability.extra.minDis
		card.dissolve = 0.15
		card.forceID = math.random() * 1000
		card.dissolve_colours = { HEX('3F5959BB'), HEX('3B5D63DC'), HEX('29484F'), HEX('29484F'), G.C.JOKER_GREY}

		card.ability.extra.initialized = true
	end

	if card.ability.extra.direction > 0 and card.ability.extra.lerp < 1 then
		card.ability.extra.lerp = card.ability.extra.lerp + G.real_dt * card.ability.extra.mod
		
		if (card.ability.extra.lerp >= 1) then
			card.ability.extra.lerp = 1
			card.ability.extra.direction = -1
		end
	end

	if card.ability.extra.direction < 0 and card.ability.extra.lerp > 0 then
		card.ability.extra.lerp = card.ability.extra.lerp - G.real_dt * card.ability.extra.mod
		if (card.ability.extra.lerp <= 0) then
			card.ability.extra.lerp = 0
			card.ability.extra.direction = 1
			card.ability.extra.initialized = false
		end
	end

	local ease = EaseInOutSin(card.ability.extra.lerp)
	card.dissolve = ease * card.ability.extra.disRange + card.ability.extra.minDis
end

function jokerInfo.draw(self, card, layer)
    if not card.config.center.discovered or not card.children.patsy_overlay then
        return
    end

    local cursor_pos = {}
    cursor_pos[1] = card.tilt_var and card.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
    cursor_pos[2] = card.tilt_var and card.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
    local screen_scale = G.TILESCALE*G.TILESIZE*(card.children.center.mouse_damping or 1)*G.CANV_SCALE
    local hovering = (card.hover_tilt or 0)

    G.SHADERS['fnwk_basic']:send('mouse_screen_pos', cursor_pos)
    G.SHADERS['fnwk_basic']:send('screen_scale', screen_scale)
    G.SHADERS['fnwk_basic']:send('hovering', hovering)
    love.graphics.setShader(G.SHADERS['fnwk_basic'], G.SHADERS['fnwk_basic'])
    card.children.center:draw_self()

	card.children.patsy_overlay:draw_shader('dissolve')
end

return jokerInfo