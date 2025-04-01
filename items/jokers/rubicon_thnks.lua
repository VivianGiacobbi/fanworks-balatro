local jokerInfo = {
	key = 'j_fnwk_rubicon_thnks',
	name = 'Thnks fr th Jkrs',
	config = {
		extra = {
			chips = 0
		},
		scroll = {
			fps = 10,
			update_rate = 1,
			update_timer = 0,
			frames = 20,
			current_frame = 0,
			scale = 8,
			mod = 0,
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'rubicon',
}

SMODS.Atlas({ key = 'thnks_base', path ='jokers/rubicon_thnks.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'thnks_overlay', path ='jokers/rubicon_thnks_overlay.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'thnks_underlay', path ='jokers/rubicon_thnks_underlay.png', px = 71, py = 95 })

function jokerInfo.set_ability(self, card, initial, delay_sprites)
	card.ability.scroll.update_rate = 1 / card.ability.scroll.fps
	card.ability.scroll.update_timer = 0
	card.ability.scroll.mod = card.ability.scroll.scale / card.ability.scroll.frames
end

function jokerInfo.set_sprites(self, card, front)
	if (not card.config.center.discovered and card.area ~= G.shop_jokers) then
        return
    end

	card.children.thnks_underlay = Sprite(
		card.T.x,
		card.T.y,
		card.T.w,
		card.T.h,
		G.ASSET_ATLAS['fnwk_thnks_underlay'],
		{ x = 0, y = 0 }
	)
	card.children.thnks_underlay:set_role({
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	})
	card.children.thnks_underlay.custom_draw = true

	card.children.thnks_overlay = Sprite(
		card.T.x,
		card.T.y,
		card.T.w,
		card.T.h,
		G.ASSET_ATLAS['fnwk_thnks_overlay'],
		{ x = 0, y = 0 }
	)
	card.children.thnks_overlay:set_role({
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	})
	card.children.thnks_overlay.custom_draw = true
	card.late_center_draw = true
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_creamwinter", set = "Other"}
	return { vars = {card.ability.extra.chips }}
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.play and context.individual and not context.debuff and not context.other_card.debuff and not context.blueprint then
		local individual_chips = context.other_card.base.nominal + context.other_card.ability.bonus + context.other_card.ability.perma_bonus
		card.ability.extra.chips = card.ability.extra.chips + individual_chips
		if individual_chips > 0 then
			return {
				message = localize{ type='variable', key='a_chips', vars = {card.ability.extra.chips} },
				message_card = card,
				colour = G.C.CHIPS,
			}
		end
	end

	if context.cardarea == G.jokers and context.joker_main and not card.debuff then
		return {
			message = localize{ type='variable', key='a_chips', vars = {card.ability.extra.chips} },
			chip_mod = card.ability.extra.chips, 
			colour = G.C.CHIPS,
			card = context.blueprint_card or card
		}
	end

	if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
		card.ability.extra.chips = 0
		return {
			card = card,
			message = localize('k_reset')
		}
	end
end

function jokerInfo.update(self, card, dt)
	if (not card.config.center.discovered and card.area ~= G.shop_jokers) then
        return
    end
	if not card.children.thnks_underlay or not card.children.thnks_underlay.sprite_pos then 
		return 
	end

	card.ability.scroll.update_timer = card.ability.scroll.update_timer + G.real_dt
	if card.ability.scroll.update_timer > card.ability.scroll.update_rate then
		card.ability.scroll.current_frame = (card.ability.scroll.current_frame + 1) % (card.ability.scroll.frames)
		card.ability.scroll.update_timer = card.ability.scroll.update_timer % card.ability.scroll.update_rate
		return
	end
	
	local scroll_val = card.ability.scroll.current_frame * card.ability.scroll.mod
	scroll_val = scroll_val + 0.005 * (math.random() * 2 - 1)
	local jitter = 0 + 0.002 * (math.random() * 2 - 1)
	card.children.thnks_underlay:set_sprite_pos({ x = jitter, y = scroll_val })
end

function jokerInfo.draw(self, card, layer)
	-- manually draw editions here
	if card.edition and not card.delay_edition then
		for k, v in pairs(G.P_CENTER_POOLS.Edition) do
			if card.edition[v.key:sub(3)] and v.shader then
				if type(v.draw) == 'function' then
					card.children.thnks_underlay:draw(card, layer)
				else
					-- because foil is transparent unlike the other edition shaders
					if v.key:sub(3) == 'foil' then
						card.children.thnks_underlay:draw_shader('dissolve')
					end
					card.children.thnks_underlay:draw_shader(v.shader, nil, card.ARGS.send_to_shader)
				end
			end
		end
	else 
		card.children.thnks_underlay:draw_shader('dissolve')
	end
	card.children.thnks_overlay:draw_shader('dissolve')
end

return jokerInfo