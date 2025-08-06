local consumInfo = {
    name = 'Artificial Stand',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        blueprint_compat = 'incompatible',
        blueprint_compat_ui = '',
        blueprint_compat_check = nil,
    },
    no_doe = true,
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'closer',
		},
        custom_color = 'closer',
    },
    blueprint_compat = true,
}

function consumInfo.in_pool(self, args)
    return false
end

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}

    local compat = 'incompatible'
    if G.consumeables and #G.consumeables.cards > 1 and card.rank < #G.consumeables.cards and G.consumeables.cards[card.rank+1].ability.set == 'Stand' then
        compat = G.consumeables.cards[card.rank+1].config.center.blueprint_compat and 'compatible' or 'incompatible'
    end

    card.ability.blueprint_compat = compat
    card.ability.blueprint_compat_ui = card.ability.blueprint_compat_ui or ''
    card.ability.blueprint_compat_check = nil

    local main_end = (card.area and card.area == G.consumeables) and {
        {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat'}, nodes={
                {n=G.UIT.T, config={ref_table = card.ability, ref_value = 'blueprint_compat_ui',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
            }}
        }}
    } or nil

    return {
        vars = {},
        main_end = main_end
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    local other_joker = nil
    if #G.consumeables.cards > 1 and card.rank < #G.consumeables.cards and G.consumeables.cards[card.rank+1].ability.set == 'Stand' then
        other_joker = G.consumeables.cards[card.rank+1]
    end

    if other_joker and not context.no_blueprint then
        if (context.blueprint or 0) > #G.consumeables.cards then return end

        local old_context_blueprint = context.blueprint
        context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1

        local old_context_blueprint_card = context.blueprint_card
        context.blueprint_card = context.blueprint_card or card
        local eff_card = context.blueprint_card
        
        card.ability.aura_colors = other_joker.ability.aura_colors
        local other_joker_ret = other_joker:calculate_joker(context)

        context.blueprint = old_context_blueprint
        context.blueprint_card = old_context_blueprint_card

        if other_joker_ret then 
            other_joker_ret.card = eff_card
            other_joker_ret.colour = G.C.STAND
            return other_joker_ret
        end
    end
end

return consumInfo