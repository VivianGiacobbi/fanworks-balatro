local rotten_states = {
	state_0 = {
		top_left = {0.505, 0.28},
		top_right = {0.745, 0.28},
		bottom_left = {0.505, 0.49},
		bottom_right = {0.745, 0.49}
	},
	state_1 = {
		top_left = {0.3, 0.3},
		top_right = {0.42, 0.24},
		bottom_left = {0.31, 0.40},
		bottom_right = {0.51, 0.38}
	},
	state_2 = {
		top_left = {0.43, 0.605},
		top_right = {0.59, 0.605},
		bottom_left = {0.37, 0.76},
		bottom_right = {0.65, 0.76}
	},
	state_3 = {
		top_left = {0.395, 0.475},
		top_right = {0.635, 0.475},
		bottom_left = {0.395, 0.715},
		bottom_right = {0.635, 0.715}
	},
}

SMODS.DrawStep {
    key = 'rotten_graft',
    order = 92,
    func = function(self)
        if not self.config.center.discovered or not self.children.rotten_sprite then
            return
        end
		
		-- set perspective transform vals
		for k, v in pairs(rotten_states['state_'..self.ability.extra.fnwk_rotten_state]) do
			G.SHADERS['fnwk_rotten_graft']:send(k, v)
		end

		local atlas = G.ASSET_ATLAS[self.config.center.atlas]
		G.SHADERS['fnwk_rotten_graft']:send('mask_tex', atlas.image)
		G.SHADERS['fnwk_rotten_graft']:send('mask_texture_details', self.children.center:get_pos_pixel())
		G.SHADERS['fnwk_rotten_graft']:send('mask_image_details', self.children.center:get_image_dims())

		self.children.rotten_sprite:draw_shader('fnwk_rotten_graft')
    end,
}


local jokerInfo = {
	name = 'Rotten Graft',
	config = {
        x_mult = 2,
        blind_type = nil,
		extra = {
			sprite_pos_max = 3,
			rotten_state = 0
		}
    },
	no_doe = true,
	rarity = 1,
	cost = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	no_collection = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'spirit',
		},
        custom_color = 'spirit',
    },
	artist = 'coop',
}

local function set_rotten_sprite(card)
	local rand_pos = math.random(0, card.ability.extra.sprite_pos_max)

	local atlas = G.ANIMATION_ATLAS[card.ability.blind_type.atlas] or G.ANIMATION_ATLAS['blind_chips']
	if not card.children.rotten_sprite then
		local offset = card.T.w/6
		card.children.rotten_sprite = AnimatedSprite(card.T.x-offset, card.T.y, card.T.w, card.T.h, atlas, card.ability.blind_type.pos)
		card.children.rotten_sprite:set_role({
			role_type = 'Minor',
			major = card,
			offset = { x = -offset, y = 0 },
			xy_bond = 'Strong',
			wh_bond = 'Strong',
			r_bond = 'Strong',
			scale_bond = 'Strong',
			draw_major = card
		})
		card.children.rotten_sprite.custom_draw = true
	end

	card.config.center.pos = { x = rand_pos, y = 0 }
	card:set_sprites(card.config.center)
	card.config.center.pos = { x = 0, y = 0 }

	card.ability.extra.fnwk_rotten_state = rand_pos
end

function jokerInfo.in_pool(self, args)
    return false
end

function jokerInfo.loc_vars(self, info_queue, card)
	local main_end = nil
	if card.ability.blind_type then
		local blind = card.ability.blind_type
		local disabled = card.ability.extra.disabled
		local blind_name = disabled and localize('k_blind_disabled_ex') or localize{type ='name_text', key = blind.key, set = 'Blind'}
		main_end = {
			{n=G.UIT.C, config={align = "bm", padding = 0.1}, nodes={
				{n=G.UIT.C, config={align = "m", colour = disabled and G.C.FILTER or get_blind_main_colour(blind.key), r = 0.05, padding = 0.075, shadow = true}, nodes={
					{n=G.UIT.T, config={text = ' '..blind_name..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
				}}
			}}
		}

		local loc_vars = nil
		if blind.name == 'The Ox' then
			loc_vars = {localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands')}
		end
		if blind.loc_vars and type(blind.loc_vars) == 'function' then
			local res = blind:loc_vars() or {}
            loc_vars = res.vars or loc_vars
		end
		info_queue[#info_queue+1] = disabled and {set = 'Other', key = 'fnwk_disabled_blind'} or {set = 'Blind', key = blind.key, vars = loc_vars }
	end
	
	return { 
		vars = {
			card.ability.x_mult
		},
		main_end = main_end
	}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	if from_debuff or not card.ability.blind_type then return end

	local extra_blind = ArrowAPI.game.create_extra_blind(card, card.ability.blind_type)
	set_rotten_sprite(card)
	if G.GAME.blind.in_blind and next(SMODS.find_card('j_chicot')) then
		extra_blind:disable()
	end
end

function jokerInfo.load(self, card, card_table, other_card)
	if card.children.rotten_sprite then card.children.rotten_sprite:remove() end

	local atlas = G.ANIMATION_ATLAS[card_table.ability.blind_type.atlas] or G.ANIMATION_ATLAS['blind_chips']
	local offset = card.T.w/6
	card.children.rotten_sprite = AnimatedSprite(card.T.x-offset, card.T.y, card.T.w, card.T.h, atlas, card_table.ability.blind_type.pos)
	card.children.rotten_sprite:set_role({
		role_type = 'Minor',
		major = card,
		offset = { x = -offset, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	})
	card.children.rotten_sprite.custom_draw = true

	card.config.center.pos = { x = card_table.ability.extra.fnwk_rotten_state, y = 0 }
	card:set_sprites(card.config.center)
	card.config.center.pos = { x = 0, y = 0 }
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea ~= G.jokers or context.blueprint then return end

	if context.blind_disabled then
		for _, v in ipairs(G.GAME.arrow_extra_blinds) do
			if v.arrow_extra_blind == card and v == G.GAME.blind then
				card.ability.extra.disabled = true
				break
			end
		end
	end

	if context.end_of_round then
		card.ability.extra.disabled = nil
	end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	if from_debuff and G.GAME.blind.in_blind then
		-- disables the blind when debuffed ala Luchador
		for _, v in ipairs(G.GAME.arrow_extra_blinds) do
			if v.arrow_extra_blind == card then
				local old_main_blind = G.GAME.blind
				v.chips = old_main_blind.chips
				v.chip_text = number_format(old_main_blind.chips)
				v.dollars = old_main_blind.dollars
				G.GAME.blind = v

				v:disable()

				old_main_blind.chips = v.chips
				old_main_blind.chip_text = number_format(v.chips)
				old_main_blind.dollars = v.dollars
				G.GAME.blind = old_main_blind
				break
			end
		end

		return
	end

	ArrowAPI.game.remove_extra_blinds(card)
end

return jokerInfo