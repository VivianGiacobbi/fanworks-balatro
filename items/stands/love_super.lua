local consumInfo = {
    name = 'Super Strut',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'EA96B1DC' },
        extra = {
            reps_mod = 1,
        },
        fnwk_strut_prev_played = {},
        fnwk_strut_rank_count = 0
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'love',
		},
        custom_color = 'love',
    },
    blueprint_compat = true,
    programmer = 'Vivian Giacobbi',
    artist = 'Vivian Giacobbi',
}

function consumInfo.loc_vars(self, info_queue, card)
    local main_end = nil
    if card.ability.fnwk_strut_rank_count > 0 then
        local rank_str = ''
        for _, v in ipairs(SMODS.Rank.obj_buffer) do
            if card.ability.fnwk_strut_prev_played[v] then
                rank_str = rank_str..(#rank_str ~= 0 and '-' or '')..SMODS.Ranks[v].card_key
            end
        end

        main_end = {{
            n=G.UIT.C,
            config={align = "bm", padding = 0.1},
            nodes={{
                n=G.UIT.O, config={object = DynaText({
                    string = {rank_str},
                    colours = {G.C.DARK_EDITION},
                    bump = true,
                    pop_in_rate = 1.5*G.SPEEDFACTOR,
                    silent = true,
                    scale = 0.3,
                })}
			}}
		}}
    end

    return {
        main_end = main_end
    }
end

function consumInfo.calculate(self, card, context)
    if context.setting_blind or (context.end_of_round and context.main_eval) then
        card.ability.fnwk_strut_prev_played = {}
        card.ability.fnwk_strut_rank_count = 0
    end

    if context.debuff then return end

    if context.before and not (context.blueprint or context.retrigger_joker) then
        local ranks_this_hand = {}
        for _, v in ipairs(context.scoring_hand) do
            if not card.ability.fnwk_strut_prev_played[v.base.value] then
                ranks_this_hand[v.base.value] = true
                card.ability.fnwk_strut_prev_played[v.base.value] = true
                card.ability.fnwk_strut_rank_count = card.ability.fnwk_strut_rank_count + 1
            end

            if ranks_this_hand[v.base.value] then
                v.ability.fnwk_strut_this_hand = true
            else
                v.ability.fnwk_strut_this_hand = nil
            end
        end
    end

    if context.repetition and context.cardarea == G.play and not context.other_card.debuff
    and not context.other_card.ability.fnwk_strut_this_hand
    and card.ability.fnwk_strut_prev_played[context.other_card.base.value] then
		local flare_card = context.blueprint_card or card
        return {
            pre_func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            message = localize('k_again_ex'),
            repetitions = card.ability.extra.reps_mod,
            card = flare_card,
        }
	end
end

return consumInfo