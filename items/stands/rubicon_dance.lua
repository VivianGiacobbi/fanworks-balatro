local ref_glass_locvars = SMODS.Centers.m_glass.loc_vars
local ref_glass_calculate = SMODS.Centers.m_glass.calculate
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
        if next(dances) then
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
                            G.FUNCS.csau_flare_stand_aura(v, 0.5)
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
        

        return ref_glass_calculate(self, card, context)
    end,
}, true)

local consumInfo = {
    name = 'Dance Macabre',
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FF55FEDC', 'A600D0DC' },
        extra = {
            suit = 'Spades'
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'rubicon',
    requires_stands = true,
    
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
    if context.fnwk_card_destroyed and context.removed.fnwk_removed_by_dance then
        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(card, 0.5)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                    card:juice_up()
                return true end }))
                delay(1)
            end
        }
    end
end

return consumInfo