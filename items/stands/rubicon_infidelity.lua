local consumInfo = {
    name = 'Hi Infidelity',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { '8EEDA4DC', '9FCE07DC' },
        extra = {
            chance = 4
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
	artist = 'CreamSodaCrossroads',
    programmer = 'Vivian Giacobbi',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    local suit = G.GAME.fnwk_infidel_suits and G.GAME.fnwk_infidel_suits.main_suit or 'Spades'
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'fnwk_rubicon_infidelity')
    return {vars = {num, dom, localize(suit, 'suits_singular'), colours = { G.C.SUITS[suit] }}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff or not context.before then return end

    local right_card = context.scoring_hand[#context.scoring_hand]
    for _, scoring_card in pairs(context.scoring_hand) do
        -- find any cards not of the target transform key to transform
        if scoring_card ~= right_card and scoring_card:is_suit(G.GAME.fnwk_infidel_suits.main_suit)
        and SMODS.pseudorandom_probability(card, 'fnwk_rubicon_infidelity', 1, card.ability.extra.chance, 'fnwk_rubicon_infidelity') then
            -- flip first
            ArrowAPI.stands.flare_aura(card, 0.5)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    scoring_card:flip()
                    play_sound('card1')
                    scoring_card:juice_up(0.3, 0.3)
                    return true
                end
            }))


            scoring_card:set_ability(right_card.config.center, nil, 'manual')
            scoring_card.ability.type = right_card.ability.type
            SMODS.change_base(scoring_card, right_card.base.suit, right_card.base.value, true)

            for k, v in pairs(right_card.ability) do
                if type(v) == 'table' then scoring_card.ability[k] = copy_table(v)
                else scoring_card.ability[k] = v end
            end

            scoring_card:set_edition(right_card.edition or {}, true, true, true)
            for k, v in pairs(right_card.edition or {}) do
                if type(v) == 'table' then scoring_card.edition[k] = copy_table(v)
                else scoring_card.edition[k] = v end
            end
            check_for_unlock({type = 'have_edition'})

            scoring_card.delay_seal = true
            scoring_card:set_seal(right_card.seal, true, true)
            for k, v in pairs(right_card.seal and right_card.ability.seal or {}) do
                if type(v) == 'table' then scoring_card.ability.seal[k] = copy_table(v)
                else scoring_card.ability.seal[k] = v end
            end

            if right_card.params then scoring_card.params = right_card.params end
            scoring_card.debuff = right_card.debuff
            scoring_card.pinned = right_card.pinned

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    scoring_card.delay_seal = false
                    scoring_card:set_sprites(scoring_card.config.center, scoring_card.config.card)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.25,
                func = function()
                    scoring_card:flip()
                    play_sound('tarot2', 1, 0.6)
                    scoring_card:juice_up(0.3, 0.3)
                    return true
                end
            }))

            delay(0.4)
        end
    end
end

return consumInfo