local consumInfo = {
    name = "L'enfer",
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            num_enhanced = 1,
            draw_size = 5,
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'scepter',
    in_progress = true,
    blueprint_compat = false,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {FnwkFormatDisplayNumber(card.ability.extra.num_enhanced), card.ability.extra.draw_size} }
end

function consumInfo.calculate(self, card, context)
    if context.blueprint or card.debuff or context.retrigger_joker then return end

    if context.discard and #context.full_hand == 1 and next(SMODS.get_enhancements(context.other_card)) then
        G.GAME.fnwk_lenfer_draw = true
        return {
            func = function()
                G.FUNCS.flare_stand_aura(card, 0.38)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    func = function()
                        play_sound('generic1')
                        card:juice_up()
                        return true
                    end 
                }))
            end,
            delay = 0.45,
            remove = true,
        }
    end
end

return consumInfo