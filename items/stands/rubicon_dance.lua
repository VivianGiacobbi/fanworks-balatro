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
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rubicon',
		},
        custom_color = 'rubicon',
    },
	artist = 'cream',
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
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

    if context.playing_card_removed and context.individual and context.removed.glass_trigger
    and SMODS.has_enhancement(context.removed, 'm_glass') then
        return {
            func = function()
                ArrowAPI.stands.flare_aura(card, 0.5)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                    card:juice_up()
                return true end }))
                delay(1)
            end
        }
    end
end

return consumInfo