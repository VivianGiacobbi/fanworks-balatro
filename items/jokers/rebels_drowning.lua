local jokerInfo = {
    name = 'Drowning Jokestar',
    config = {
        extra = {
            reps = 1
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rebels',
		},
        custom_color = 'rebels',
    },
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
    info_queue[#info_queue+1] = G.P_CENTERS.m_mult
    return { vars = {
        localize{type = 'name_text', set = 'Enhanced', key = 'm_bonus'},
        localize{type = 'name_text', set = 'Enhanced', key = 'm_mult'}
    } }
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        local enhancements = SMODS.get_enhancements(v)
        if enhancements['m_bonus'] or enhancements['m_mult'] then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and not context.blueprint then
        local enhancement_map = {m_bonus = true, m_mult = true}
        for _, v in ipairs(context.scoring_hand) do
            local enhancements = SMODS.get_enhancements(v)
            if enhancements['m_bonus'] and enhancement_map['m_bonus'] then
                enhancement_map['m_bonus'] = nil
            elseif enhancements['m_mult'] and enhancement_map['m_mult'] then
                enhancement_map['m_mult'] = nil
            end
        end
        card.ability.fnwk_valid_drowning_hand = not next(enhancement_map)
    end

    if context.after then
        card.ability.fnwk_valid_drowning_hand = nil
    end

    if card.ability.fnwk_valid_drowning_hand and context.repetition and context.cardarea == G.play then
        return {
            message = localize('k_again_ex'),
            repetitions = card.ability.extra.reps,
            card = context.blueprint_card or card,
        }
	end
end

return jokerInfo