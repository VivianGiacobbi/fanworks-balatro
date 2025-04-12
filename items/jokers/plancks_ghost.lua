local valid_keys = {
	['mult'] = true,
	['h_mult'] = true,
	['h_x_mult'] = true,
	['h_dollars'] = true,
	['p_dollars'] = true,
	['t_mult'] = true,
	['t_chips'] = true,
	['x_mult'] = true,
	['h_chips'] = true,
	['x_chips'] = true,
	['h_x_chips'] = true,
	['h_size'] = true,
	['d_size'] = true,
	['extra_value'] = true,
	['perma_bonus'] = true,
	['perma_x_chips'] = true,
	['perma_mult'] = true,
	['perma_x_mult'] = true,
	['perma_h_chips'] = true,
	['perma_h_mult'] = true,
	['perma_h_x_mult'] = true,
	['perma_p_dollars'] = true,
	['perma_h_dollars'] = true,
	['caino_xmult'] = true,
	['yorick_discards'] = true,
	['invis_rounds'] = true
}

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
	rarity = 2,
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
	if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
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
	if not context.cardarea == G.jokers or context.blueprint then return end
    if context.joker_destroyed and context.removed ~= card and context.removed.config.center.key ~= 'j_fnwk_plancks_ghost' then	
		
		-- single level compare for valid keys in the main ability table
		local changed = false
		for k,v in pairs(context.removed.ability) do
			if valid_keys[k] and v ~= context.removed.config.center.config[k] then
				changed = true
				break
			end
		end

		if not changed then
			changed = FnwkDeepCompare(context.removed.ability.extra, context.removed.config.center.config.extra)
		end	

		sendDebugMessage(context.removed.config.center.key..'changed: '..tostring(changed))
		
		if not changed then return end
		
		-- store relevant ability and extra values
		local saved_ability = {}
		for k, v in pairs(context.removed.ability) do
			if valid_keys[k] then saved_ability[k] = v end
		end
		saved_ability.extra = FnwkRecursiveTableMod(context.removed.ability.extra)

		-- save this table
		card.ability.extra.saved_abilities[context.removed.config.center.key] = saved_ability
	end

	if context.cardarea == G.jokers and context.joker_created and context.card ~= card and card.ability.extra.saved_abilities[context.card.config.center.key] then			
		for k, v in pairs(card.ability.extra.saved_abilities[context.card.config.center.key]) do
			context.card.ability[k] = v
		end

		card.ability.extra.saved_abilities[context.card.config.center.key] = nil
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

function jokerInfo.update(self, card, dt)
	if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
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

	local ease = FnwkEaseInOutSin(card.ability.extra.lerp)
	card.dissolve = ease * card.ability.extra.disRange + card.ability.extra.minDis
end

function jokerInfo.draw(self, card, layer)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

	if not card.children.patsy_overlay then
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