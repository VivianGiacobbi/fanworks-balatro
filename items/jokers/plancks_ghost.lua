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
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.coop }}
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
    if context.fnwk_joker_destroyed and context.joker ~= card and context.joker.config.center.key ~= 'j_fnwk_plancks_ghost' then	
		
		-- single level compare for valid keys in the main ability table
		local changed = false
		for k,v in pairs(context.joker.ability) do
			if valid_keys[k] and v ~= context.joker.config.center.config[k] then
				changed = true
				break
			end
		end

		if not changed then
			changed = FnwkDeepCompare(context.joker.ability.extra, context.joker.config.center.config.extra)
		end	
		
		if not changed then return end
		
		-- store relevant ability and extra values
		local saved_ability = {}
		for k, v in pairs(context.joker.ability) do
			if valid_keys[k] then saved_ability[k] = v end
		end
		saved_ability.extra = FnwkRecursiveTableMod(context.joker.ability.extra)

		-- save this table
		card.ability.extra.saved_abilities[context.joker.config.center.key] = saved_ability
	end

	if context.cardarea == G.jokers and context.fnwk_created_card and context.card ~= card and card.ability.extra.saved_abilities[context.card.config.center.key] then			
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
				
				local explode_time = 1.3*(0.6 or 1)*(math.sqrt(G.SETTINGS.GAMESPEED))
				self.dissolve = 0
				self.dissolve_colours = {G.C.WHITE}

				local start_time = G.TIMERS.TOTAL
				local percent = 0
				play_sound('explosion_buildup1')
				self.juice = {
					scale = 0,
					r = 0,
					handled_elsewhere = true,
					start_time = start_time, 
					end_time = start_time + explode_time
				}

				local particles = Particles(0, 0, 0,0, {
					timer_type = 'TOTAL',
					timer = 0.01*explode_time,
					scale = 0.2,
					speed = 2,
					lifespan = 0.2*explode_time,
					attach = self,
					colours = self.dissolve_colours,
					fill = true
				})

				G.E_MANAGER:add_event(Event({
					blockable = false,
					func = (function()
							if self.juice then 
								percent = (G.TIMERS.TOTAL - start_time)/explode_time
								self.juice.r = 0.05*(math.sin(5*G.TIMERS.TOTAL) + math.cos(0.33 + 41.15332*G.TIMERS.TOTAL) + math.cos(67.12*G.TIMERS.TOTAL))*percent
								self.juice.scale = percent*0.15
							end
							if G.TIMERS.TOTAL - start_time > 1.5*explode_time then return true end
						end)
				}))

				G.E_MANAGER:add_event(Event({
					trigger = 'ease',
					blockable = false,
					ref_table = self,
					ref_value = 'dissolve',
					ease_to = 0.3,
					delay =  0.9*explode_time,
					func = (function(t) return t end)
				}))

				G.E_MANAGER:add_event(Event({
					blockable = false,
					delay = 1.6*explode_time,
					func = (function() 
						if G.TIMERS.TOTAL - start_time > 1.55*explode_time then  
							self.dissolve = 0
							percent = 0
							self.juice = {
								scale = 0,
								r = 0,
								handled_elsewhere = true,
								start_time = start_time, 
								end_time = G.TIMERS.TOTAL
							}
							return true 
						end
					end)
				}))
				particles:fade()

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

    card.children.center:draw_shader('dissolve')
	card.children.patsy_overlay:draw_shader('dissolve')
end

return jokerInfo