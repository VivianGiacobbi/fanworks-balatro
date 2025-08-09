local consumInfo = {
    name = 'Ultimate Showdown of Ultimate Destiny',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'F4C275DC' },
        extra = {
            base_retriggers = 1,
            retrigger_mod = 0
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'spirit',
		},
        custom_color = 'spirit',
    },
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    local first_grammar = ArrowAPI.string.count_grammar(card.ability.extra.base_retriggers + card.ability.extra.base_retriggers * card.ability.extra.retrigger_mod)
    local second_grammar = ''
    if ArrowAPI.string.contains(first_grammar, ' times') then
        first_grammar = string.sub(first_grammar, 1, #first_grammar - 6)
        second_grammar = ' times'
    end
    return {
        vars = {
            first_grammar,
            second_grammar,
            card.ability.extra.base_retriggers
        }
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if not context.joker_retrigger and context.removed_card and context.removed_card ~= card
    and context.removed_card.ability and context.removed_card.ability.set == 'Joker'
    and not context.blueprint then
        local name = string.lower(context.removed_card.config.center.name)
        if ArrowAPI.string.contains(name, 'jokestar') then
            card.ability.extra.retrigger_mod = card.ability.extra.retrigger_mod + 1
            return {
                message = localize('k_upgrade_ex'),
            }
        end
    end

    if context.repetition and context.cardarea == G.play and not context.other_card.debuff and SMODS.has_enhancement(context.other_card, 'm_lucky') then
        local reps = card.ability.extra.base_retriggers + card.ability.extra.base_retriggers * card.ability.extra.retrigger_mod
        local gold_count = 0
        for _, v in ipairs(G.hand.cards) do
            if SMODS.has_enhancement(v, 'm_gold') then gold_count = gold_count + 1 end
        end

        if gold_count > 0 then
            local flare_card = context.blueprint_card or card
            return {
                pre_func = function()
                    ArrowAPI.stands.flare_aura(flare_card, 0.5)
                end,
                message = localize('k_again_ex'),
                repetitions = (gold_count * reps),
                card = flare_card,
            }
        end
    end
end

return consumInfo