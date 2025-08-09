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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'plancks',
		},
        custom_color = 'plancks',
    },
	artist = 'coop',
	alt_art = true
}

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
	if context.blueprint then return end
    if context.removed_card and context.removed_card ~= card and context.removed_card.config.center.key ~= 'j_fnwk_plancks_ghost' then	
		
		-- single level compare for valid keys in the main ability table
		local changed = false
		for k,v in pairs(context.removed_card.ability) do
			if G.fnwk_valid_scaling_keys[k] and v ~= context.removed_card.config.center.config[k] then
				changed = true
				break
			end
		end

		if not changed then
			changed = ArrowAPI.table.deep_compare(context.removed_card.ability.extra, context.removed_card.config.center.config.extra)
		end
		
		if not changed then return end
		
		-- store relevant ability and extra values
		local saved_ability = {}
		for k, v in pairs(context.removed_card.ability) do
			if G.fnwk_valid_scaling_keys[k] then saved_ability[k] = v end
		end
		saved_ability.extra = ArrowAPI.table.recursive_mod(context.removed_card.ability.extra)

		-- save this table
		card.ability.extra.saved_abilities[context.removed_card.config.center.key] = saved_ability
	end

	if context.created_card and context.created_card ~= card and card.ability.extra.saved_abilities[context.created_card.config.center.key] then			
		for k, v in pairs(card.ability.extra.saved_abilities[context.created_card.config.center.key]) do
			context.created_card.ability[k] = v
		end

		card.ability.extra.saved_abilities[context.created_card.config.center.key] = nil
		context.created_card:set_cost()

		FnwkReviveEffect(context.created_card)
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

	local ease = ArrowAPI.math.ease_funcs.in_out_sin(card.ability.extra.lerp)
	card.dissolve = ease * card.ability.extra.disRange + card.ability.extra.minDis
end

function jokerInfo.draw(self, card, layer)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

	if not card.children.patsy_overlay then
		return
	end

	local last_dissolve = card.dissolve
	card.dissolve = 0
    card.children.center:draw_shader('dissolve')

	card.dissolve = last_dissolve
	card.children.patsy_overlay:draw_shader('dissolve')
end

return jokerInfo