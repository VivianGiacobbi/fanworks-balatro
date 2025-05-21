local consumInfo = {
    key = 'c_fnwk_bone_king_farewell',
    name = 'Farewell to Kings',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'CBD4E7DC', 'FD5F55DC' },
        evolved = true,
        extra = {
            blind_mod = 0.5
        }
    },
    cost = 4,
    rarity = 'arrow_EvolvedRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'bone',
    in_progress = true,
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.blind_mod * 100}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if not context.blueprint and context.destroy_card and context.cardarea == G.play then
        local scoring  = SMODS.in_scoring(context.destroy_card, context.scoring_hand)
        local steel = SMODS.has_enhancement(context.destroy_card, 'm_steel')
        local king = context.destroy_card:get_id() == 13

        if scoring and steel and king then
            context.destroy_card.fnwk_removed_by_farewell = true
            return {
                remove = true
            }
        end
    end

    if context.fnwk_card_destroyed and G.play and context.removed.fnwk_removed_by_farewell then
        return {
            func = function()
                G.FUNCS.flare_stand_aura(context.blueprint_card or card, 0.5)
            end,
            extra = {
                message = localize('k_farewell'),
                sound = 'slice1',
                delay = 0,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra.blind_mod)
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                            G.hand_text_area.blind_chips:juice_up()
                            return true 
                        end 
                    }))
                    delay(0.6)
                end
            }
        }
    end
end

return consumInfo