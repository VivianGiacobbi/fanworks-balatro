local consumInfo = {
	name = 'Invisible Sun',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { '7F1010DC', '4E6266DC' },
        extra = {
            reps = 3,
            reps_mod = 1,
            reps_max = 5,
            destroy_ranks = {[13] = true, [11] = true}
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'redrising',
    in_progress = true,
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.wario }}

    return {
        vars = {
            card.ability.extra.reps,
            card.ability.extra.reps ~= 1 and 's' or '',
            card.ability.extra.reps_max,
            card.ability.extra.reps_mod
        }
    }
end

function consumInfo.calculate(self, card, context)
    local bad_context = context.blueprint or context.retrigger_joker
    if not bad_context and context.end_of_round and not context.individual and not context.repetition and card.ability.extra.reps > 0 then
        card.ability.extra.reps = card.ability.extra.reps - 1
        return {
            message = localize{type='variable',key='a_reps_minus',vars={1}},
            card = card,
        }
    end

    if context.debuff then return end

    if not bad_context and context.remove_playing_cards then
        local add_reps = 0
        for _, v in ipairs(context.removed) do
            if not v.debuff and card.ability.extra.destroy_ranks[v:get_id()] then
                add_reps = add_reps + 1
            end
        end

        local old_reps = card.ability.extra.reps
        card.ability.extra.reps = card.ability.extra.reps + add_reps * card.ability.extra.reps_mod
        card.ability.extra.reps = math.min(card.ability.extra.reps_max, card.ability.extra.reps)

        if card.ability.extra.reps > old_reps then
            return {
                message = localize{type='variable',key='a_reps',vars={card.ability.extra.reps - old_reps}},
                card = card,
            }
        end
    end

    if context.repetition and context.cardarea == G.play and not context.end_of_round and context.other_card:get_id() == 12 then
		if card.ability.extra.reps > 0 then
            local flare_card = context.blueprint_card or card
            return {
                pre_func = function()
                    G.FUNCS.flare_stand_aura(flare_card, 0.5)
                end,
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.reps,
                card = flare_card,
            }
        end
	end 
end

return consumInfo