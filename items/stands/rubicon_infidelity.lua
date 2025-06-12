local consumInfo = {
    name = 'Hi Infidelity',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { '8EEDA4DC', '9FCE07DC' },
        extra = {
            chance = 3
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'rubicon',
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cream }}
    return {vars = {card.ability.extra.chance}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff or not context.before then return end

    local left_card = context.scoring_hand[1]
    for i, scoring_card in pairs(context.scoring_hand) do
        -- find any cards not of the target transform key to transform
        if i ~= 1 and scoring_card:is_suit(left_card.base.suit) 
        and pseudorandom(pseudoseed('fnwk_hi_infidelity')) < G.GAME.probabilities.normal/card.ability.extra.chance then
            -- flip first
            G.FUNCS.flare_stand_aura(card, 0.5)
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
            
            scoring_card:set_ability(left_card.config.center, nil, true)
            scoring_card.ability.type = left_card.ability.type

            local suit = SMODS.Suits[left_card.base.suit].card_key
            local rank = SMODS.Ranks[left_card.base.value].card_key
            scoring_card:set_base(G.P_CARDS[suit..'_'..rank], nil, true)

            for k, v in pairs(left_card.ability) do
                if type(v) == 'table' then 
                    scoring_card.ability[k] = copy_table(v)
                else
                    scoring_card.ability[k] = v
                end
            end

            scoring_card:set_edition(left_card.edition or {}, true, true, true)
            for k, v in pairs(left_card.edition or {}) do
                if type(v) == 'table' then
                    scoring_card.edition[k] = copy_table(v)
                else
                    scoring_card.edition[k] = v
                end
            end
            check_for_unlock({type = 'have_edition'})

            scoring_card.delay_seal = true
            scoring_card:set_seal(left_card.seal, true)
            if left_card.seal then
                for k, v in pairs(left_card.ability.seal or {}) do
                    if type(v) == 'table' then
                        scoring_card.ability.seal[k] = copy_table(v)
                    else
                        scoring_card.ability.seal[k] = v
                    end
                end
            end

            if left_card.params then
                scoring_card.params = left_card.params
            end
            
            scoring_card.debuff = left_card.debuff
            scoring_card.pinned = left_card.pinned

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    scoring_card.delay_seal = false
                    scoring_card:set_sprites(nil, G.P_CARDS[scoring_card.config.card_key])
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