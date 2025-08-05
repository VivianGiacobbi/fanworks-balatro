local consumInfo = {
    name = 'Cough Syrup',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FF658BDC', 'FFE6AADC' },
        extra = {
            enhancement = 'm_wild',
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'crimson',
		},
        custom_color = 'crimson',
    },
    artist = 'gar',
    blueprint_compat = false,
}

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and not context.blueprint and not context.retrigger_joker then
        local wilds = {}
        for _, v in ipairs(context.scoring_hand) do
            if SMODS.has_enhancement(v, card.ability.extra.enhancement) then
                wilds[#wilds+1] = v
            end
        end

        if #wilds < 2 then
            card.ability.fnwk_cough_effect = nil
            return
        end

        local rand_idx = pseudorandom(pseudoseed('fnwk_cough'), 1, #wilds)
        for i, v in ipairs(wilds) do
            if i == rand_idx then
                v.fnwk_cough_keep = true
            else
                v.fnwk_cough_delete = true
            end
        end
    end

    if not context.blueprint and not context.retrigger_joker and context.destroy_card
    and context.cardarea == G.play and context.destroy_card.fnwk_cough_delete then
        return {
            remove = true
        }
    end

    if context.playing_card_removed and context.individual and context.removed.fnwk_cough_delete then

        local find_keep = nil
        for _, v in ipairs(context.scoring_hand) do
            if v.fnwk_cough_keep then
                find_keep = v
                break
            end
        end

        if not find_keep then return end

        local move_chips = (context.removed.ability.effect == 'Stone Card'
            or context.removed.config.center.replace_base_card) and 0 or context.removed.base.nominal
        local perma_chips = context.removed.ability.perma_bonus or 0

        if move_chips + perma_chips <= 0 then
            return
        end
        
        find_keep.ability.perma_bonus = (find_keep.ability.perma_bonus or 0) + move_chips + perma_chips

        local flare_card = context.blueprint_card or card
        ArrowAPI.stands.flare_aura(flare_card, 0.5)
        G.E_MANAGER:add_event(Event({
            func = function()
                flare_card:juice_up()
                return true 
            end
        }))
        
        card_eval_status_text(context.removed, 'extra', nil, nil, nil, {
			message = localize{type='variable',key='a_chips_minus',vars={move_chips + perma_chips}},
            colour = G.C.CHIPS
		})

        delay(0.2)

        ArrowAPI.stands.flare_aura(flare_card, 0.5)
        G.E_MANAGER:add_event(Event({
            func = function()
                flare_card:juice_up()
                return true 
            end
        }))
        card_eval_status_text(find_keep, 'extra', nil, nil, nil, {
			message = localize{type='variable',key='a_chips',vars={move_chips + perma_chips}},
            colour = G.C.CHIPS
		})
    end
end

return consumInfo