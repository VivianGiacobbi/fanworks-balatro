local consumInfo = {
    name = 'Miracle Row',
    set = 'Stand',
    config = {
        stand_mask = true,
        evolve_key = 'c_fnwk_jspec_miracle_together',
        aura_colors = { 'FFD4BFDC', 'FFAF71DC' },
        extra = {
            evolve_seals = 4
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jspec',
		},
        custom_color = 'jspec',
    },
    artist = 'plus',
    blueprint_compat = false,
}

local function get_highest_level()
    local highest = 1
    for _, v in pairs(G.GAME.hands) do
        if v.level > highest then highest = v.level end
    end
    return highest
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.after then
        local seals_map = {}
        seal_count = 0
        for _, v in ipairs(context.full_hand) do
            if v.seal and not seals_map[v.seal] then 
                seals_map[v.seal] = true
                seal_count = seal_count + 1

                if seal_count >= card.ability.extra.evolve_seals then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            ArrowAPI.stands.evolve_stand(card)
                            return true 
                        end 
                    }))
                    break
                end
            end
        end
    end

    if context.debuff_hand then
        local highest_level = get_highest_level()
        if G.GAME.hands[context.scoring_name].level < highest_level then
            if not context.check then
                local juice_card = context.blueprint_card or card
                ArrowAPI.stands.flare_aura(juice_card, 2)
                level_up_hand(juice_card, context.scoring_name, nil, 1)
            end

            if not context.blueprint and not context.retrigger_joker then
                local name = localize(context.scoring_name, 'poker_hands')
                return {
                    debuff = true,
                    debuff_text = localize{type='variable',key='miracle_warn_text',vars={name}},
                    debuff_source = card
                }
            end
        end
    end
end

return consumInfo