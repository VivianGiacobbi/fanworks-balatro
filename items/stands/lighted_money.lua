local consumInfo = {
    key = 'c_fnwk_lighted_money',
    name = 'Money Talks',
    set = 'Stand',
    config = {
        aura_colors = { 'FFE6BCDC', 'FFD081DC' },
        stand_mask = true,
        extra = {
            dollars = 7
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'lighted',
		},
        custom_color = 'lighted',
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Vivian Giacobbi',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.dollars}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if not context.blueprint and not context.retrigger_joker and context.destroy_card and context.cardarea == G.play and SMODS.has_enhancement(context.destroy_card, 'm_gold') then
        context.destroy_card.fnwk_removed_by_moneytalks = true
        return {
            remove = true
        }
    end

    if context.post_playing_card_removed and context.removed.fnwk_removed_by_moneytalks then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            delay = 0.5,
            extra = {
                dollars = card.ability.extra.dollars,
                colour = G.C.MONEY,
                card = flare_card
            }
        }
    end
end

return consumInfo