local consumInfo = {
    name = 'Neon Trees',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FDE8EEDC', 'FD7DC0DC' },
        evolved = true,
        extra = {
            enhancement = 'm_gold',
            reps = 1,
        }
    },
    cost = 4,
    hasSoul = true,
    rarity = 'arrow_StandRarity',
    fanwork = 'streetlight',
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.piano }}
    return { 
        vars = {
            localize{type = 'name_text', set = 'Enhanced', key = card.ability.extra.enhancement},
            card.ability.extra.h_dollars_mod,
        }
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if not context.blueprint and not context.retrigger_joker and context.debuff_card
    and context.debuff_card.config.center.key == card.ability.extra.enhancement then
		return {
            prevent_debuff = true
        }
	end

    if context.repetition and context.end_of_round and context.cardarea == G.hand and not context.other_card.debuff 
    and SMODS.has_enhancement(context.other_card, card.ability.extra.enhancement) then
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

return consumInfo