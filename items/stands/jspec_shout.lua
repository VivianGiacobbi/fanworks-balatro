local consumInfo = {
    name = 'Miracle Row',
    set = 'Stand',
    config = {
        stand_mask = true,
        evolve_key = 'c_fnwk_jspec_miracle_together',
        aura_colors = { 'C9DCFFDC', 'A5A5FFDC' },
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

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
end

function consumInfo.calculate(self, card, context)
    if not (context.end_of_round and context.main_eval)
    or context.joker_retrigger or context.blueprint or card.debuff then
        return
    end

    -- if there are multiple, only let the leftmost one do this
    if SMODS.find_card('c_fnwk_jspec_shout')[1] ~= card or G.jokers.config.card_count <= G.jokers.config.card_limit then
        return
    end

    ArrowAPI.stands.flare_aura(card, 0.5)
    local joker_count = G.jokers.config.card_count
    for i=#G.jokers.cards, 1, -1 do
        local check_card = G.jokers.cards[i]
        if not check_card.fnwk_disturbia_joker and not check_card.ability.eternal and not
        (check_card.edition and check_card.edition.card_limit) then
            check_card:start_dissolve(nil, i ~= #G.jokers.cards)
            joker_count = joker_count - 1
        end

        if joker_count <= G.jokers.config.card_limit then
            break
        end
    end
    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_shout'), colour = G.C.STAND})
end

return consumInfo