local jokerInfo = {
	name = 'Starry-Eyed Jokestar',
	config = {
        extra = {
            mult = 0,
            mult_mod = 2,
        }
    },
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'glass',
		},
        custom_color = 'glass',
    },
    artist = 'Vivian Giacobbi',
    programmer = 'Vivian Giacobbi'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult} }
end

function jokerInfo.set_sprites(self, card, front)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    card.children.center:set_sprite_pos({x = 1, y = 0})

    local atlas = G.ASSET_ATLAS[self.atlas]
    local role = {
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	}

    card.children.glass_pipes_back = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, atlas, { x = 2, y = 0})
	card.children.glass_pipes_back:set_role(role)
	card.children.glass_pipes_back.custom_draw = true

    card.children.glass_josephine = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, atlas,{ x = 3, y = 0})
	card.children.glass_josephine:set_role(role)
	card.children.glass_josephine.custom_draw = true

    card.children.glass_pipes_front = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, atlas,{ x = 4, y = 0})
	card.children.glass_pipes_front:set_role(role)
	card.children.glass_pipes_front.custom_draw = true
    card.late_center_draw = true
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then
        return
    end

    if context.joker_main and card.ability.extra.mult > 0 then
        return {
			mult = card.ability.extra.mult,
			card = context.blueprint_card or card,
		}
    end


    if context.blueprint or not (context.remove_playing_cards or context.playing_card_added) then
        return
    end

    local count = 0
    count = count + (context.playing_card_added and #context.cards or 0)
    count = count + (context.remove_playing_cards and #context.removed or 0)

    if count == 0 then
        return
    end

    local scale_table = { mult_mod = card.ability.extra.mult_mod * count }
    SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = "mult",
        scalar_table = scale_table,
        scalar_value = "mult_mod",
        scaling_message = {
            message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult} },
            card = card,
            color = G.C.MULT,
        }
    })
end

function jokerInfo.draw(self, card, layer)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    if not card.children.glass_pipes_back or not card.children.glass_josephine or not card.children.glass_pipes_front then
        return
    end

    G.SHADERS['fnwk_wave_warp']:send('wave_time', G.TIMERS.REAL)
    G.SHADERS['fnwk_wave_warp']:send('wave_t', 1)
    G.SHADERS['fnwk_wave_warp']:send('mask_offset', 0.5)
    card.children.glass_pipes_back:draw_shader('fnwk_wave_warp')

    card.children.glass_josephine:draw_shader('dissolve')

    G.SHADERS['fnwk_wave_warp']:send('wave_time', G.TIMERS.REAL + 0.5)
    G.SHADERS['fnwk_wave_warp']:send('wave_t', 2)
    G.SHADERS['fnwk_wave_warp']:send('mask_offset', 1/6)
    card.children.glass_pipes_front:draw_shader('fnwk_wave_warp')
end

return jokerInfo