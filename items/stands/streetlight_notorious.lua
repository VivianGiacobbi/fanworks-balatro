local consumInfo = {
    name = 'NOTORIOUS',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            x_mult = 5,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Vivian Giacobbi',
    blueprint_compat = true,
}

local function no_face_cards()
    if not G.playing_cards then return false end

    for _, v in ipairs(G.playing_cards) do
        if v:is_face() then return false end
    end

    return true
end

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.x_mult} }
end

function consumInfo.set_sprites(self, card, front)
    if not self.discovered and not card.bypass_discovery_center then
        return
    end

	card.children.noto_layer = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[self.atlas], {x = 2, y = 0})
	card.children.noto_layer:set_role({
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	})
    card.children.noto_layer.custom_draw = true
end

function consumInfo.calculate(self, card, context)
    if not context.joker_main or not no_face_cards() or card.debuff then return end

    local flare_card = context.blueprint_card or card
    return {
        func = function()
            ArrowAPI.stands.flare_aura(flare_card, 0.5)
        end,
        extra = {
            x_mult = card.ability.extra.x_mult,
            card = flare_card
        }
    }
end

return consumInfo