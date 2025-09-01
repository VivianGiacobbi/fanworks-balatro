local consumInfo = {
    key = 'c_fnwk_jojopolis_hgm_cosmic',
    name = 'Hurdy Gurdy Man: Cosmic Wheels',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC', },
        evolved = true,
    },
    cost = 4,
    rarity = 'EvolvedRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'jojopolis',
		},
        custom_color = 'jojopolis',
    },
    blueprint_compat = true,
    artist = 'gote',
}

function consumInfo.calculate(self, card, context)
    if context.before then
        card.ability.fnwk_cosmic_played_hand = true
    end

    if card.ability.fnwk_cosmic_played_hand and context.drawing_cards and context.amount < G.hand.config.card_limit then
		card.ability.fnwk_cosmic_played_hand = nil
        return {
            func = function()
                ArrowAPI.stands.flare_aura(card, 0.5)
            end,
            extra = {
                message = localize('k_hgm_cosmic_draw'),
                colour = G.C.STAND,
                cards_to_draw = G.hand.config.card_limit
            }
		}
    end
end

return consumInfo