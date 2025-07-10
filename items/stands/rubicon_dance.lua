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
    hasSoul = true,
    fanwork = 'rubicon',
    blueprint_compat = false,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cream }}
    return { vars = {
            localize(card.ability.extra.suit, 'suits_singular'),
            colours = {
                G.C.SUITS[card.ability.extra.suit]
            }
        }
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint or context.retrigger_joker then return end

    if context.fix_probability and context.identifier == 'glass' then
        if context.trigger_obj:is_suit(card.ability.extra.suit) then
            return {
                numerator = 0
            }
        else
            return {
                numerator = 1,
                denominator = 0
            }
        end
    end

    if context.fnwk_playing_card_removed and context.removed.glass_trigger
    and SMODS.has_enhancement(context.removed, 'm_glass') then
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