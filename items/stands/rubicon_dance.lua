local ref_glass_locvars = SMODS.Centers.m_glass.loc_vars
SMODS.Enhancement:take_ownership('glass', {
    config = {extra = 4},
    loc_vars = function(self, info_queue, card)
        if next(SMODS.find_card('c_fnwk_rubicon_dance')) then
            local loc_key = 'm_glass_fnwk_dance_'..(card:is_suit('Spades') and 'spades' or 'other')
            return {
                vars = {2},
                key = loc_key
            }
        end

        if ref_glass_locvars and type(ref_glass_locvars) == 'function' then
            return ref_glass_locvars(self, info_queue, card)
        end

        return { vars = {2, G.GAME.probabilities.normal, self.config.extra}}
    end,
    calculate = function(self, card, context)
        local dances = SMODS.find_card('c_fnwk_rubicon_dance')
        local valid = true
        for _, v in ipairs(dances) do
            if v.debuff then
                valid = false
                break
            end
        end

        if valid then
            if context.destroy_card and context.cardarea == G.play then
                local is_spades = context.destroy_card:is_suit('Spades')
                if not is_spades then
                    context.destroy_card.fnwk_removed_by_dance = true
                    return { remove = true }
                end
            end

            if context.main_scoring and context.cardarea == G.play then
                return {
                    func = function()
                        for _, v in ipairs(dances) do
                            G.FUNCS.flare_stand_aura(v, 0.5)
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                                v:juice_up()
                            return true end }))
                        end
                    end,
                    extra = {
                        x_mult = 2,
                    }
                }
            end

            return
        end
        
        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card and pseudorandom('glass') < G.GAME.probabilities.normal/card.ability.extra then
            return { remove = true }
        end

        if context.main_scoring and context.cardarea == G.play then
            return {
                x_mult = 2,
            }
        end
    end,
}, true)

local consumInfo = {
    name = 'Dance Macabre',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FF55FEDC', 'A600D0DC' },
        extra = {
            suit = 'Spades'
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'rubicon',
    blueprint_compat = false,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {
            localize(card.ability.extra.suit, 'suits_singular'),
            colours = {
                G.C.SUITS[card.ability.extra.suit]
            }
        }
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if context.fnwk_card_destroyed and context.removed.fnwk_removed_by_dance then
        return {
            func = function()
                G.FUNCS.flare_stand_aura(card, 0.5)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                    card:juice_up()
                return true end }))
                delay(1)
            end
        }
    end
end

return consumInfo