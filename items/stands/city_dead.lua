local consumInfo = {
    name = 'Dead Weight',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'DCFB8CDC', '4CB3D9DC' },
        extra = {
            tarot = 'c_hermit'
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'city',
		},
        custom_color = 'city',
    },
    artist = 'jester',
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {G.P_CENTERS[card.ability.extra.tarot].name}}
end

function consumInfo.calculate(self, card, context)
    if context.blueprint or context.joker_retrigger or card.debuff then
        return
    end

    if context.using_consumeable then
        local center_key = context.consumeable.config.center.key
        if center_key == 'c_emperor' or center_key == 'c_fool' then
            ArrowAPI.stands.flare_aura(card, 0.38)
        end
    end
end

return consumInfo