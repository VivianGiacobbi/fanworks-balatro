local consumInfo = {
    key = 'c_fnwk_lighted_limelight',
    name = 'Limelight',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'fnwk_rainbow', },
        extra = {
            edition = 'e_polychrome',
            chance = 7
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
    return { vars = {G.GAME.probabilities.normal, card.ability.extra.chance, JoJoFanworks.current_config['enable_Queer'] and 'Queer' or 'Polychrome'}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before then
        for _, v in ipairs(context.full_hand) do
            if not v.edition and not SMODS.in_scoring(v, context.scoring_hand) and pseudorandom('limelight') < G.GAME.probabilities.normal / card.ability.extra.chance then
                local juice_card = context.blueprint_card or card
                ArrowAPI.stands.flare_aura(juice_card, 0.5)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
                    v:set_edition(card.ability.extra.edition, true)
                    juice_card:juice_up()
                    return true end
                }))
                delay(0.5)
            end
        end
    end
end

return consumInfo