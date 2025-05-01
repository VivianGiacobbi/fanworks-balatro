local consumInfo = {
    key = 'c_fnwk_lighted_money',
    name = 'Money Talks',
    set = 'csau_Stand',
    config = {
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        -- stand_mask = true,
        extra = {
            dollars = 7
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'lighted',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.dollars}}
end

function consumInfo.calculate(self, card, context)
    if context.destroy_card and context.cardarea == G.play and SMODS.has_enhancement(context.destroy_card, 'm_gold') then
        return {
            remove = true
        }
    end

    if context.remove_playing_cards and context.scoring_hand then
        local removed = 0
        for _, v in ipairs(context.removed) do
            if SMODS.has_enhancement(v, 'm_gold') and SMODS.in_scoring(v, context.scoring_hand) then
               removed = removed + 1
            end
        end

        if removed > 0 then
            return {
                func = function()
                    G.FUNCS.csau_flare_stand_aura(card, 0.38)
                    ease_dollars(card.ability.extra.dollars * removed)
                end,
                extra = {
                    func = function()
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                            card:juice_up()
                            attention_text({
                                text = localize('$')..card.ability.extra.dollars * removed,
                                scale = 1, 
                                hold = 0.5,
                                backdrop_colour = G.C.MONEY,
                                align = 'bm',
                                major = card,
                                offset = {x = 0, y = 0.05*card.T.h}
                            })
                            return true end
                        }))
                    end
                }
            }
        end
    end
end

return consumInfo