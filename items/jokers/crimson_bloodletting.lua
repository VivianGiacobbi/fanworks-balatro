local jokerInfo = {
    key = 'j_fnwk_crimson_bloodletting',
    name = 'Bloodletting Tome',
    config = {
        extra = {
            destroy = 2,
            destroy_count = 0,
        }
    },
    rarity = 2,
    cost = 6,
    unlocked = false,
    unlock_condition = {type = 'discard_custom', card_key = 'H_K', amount = 5},
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    fanwork = 'crimson',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gar", set = "Other"}
    return { vars = { card.ability.extra.destroy, card.ability.extra.destroy - card.ability.extra.destroy_count } }
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
    local display_card = G.P_CARDS[self.unlock_condition.card_key]
    return { 
        vars = {
            self.unlock_condition.amount,
            display_card.value,
            display_card.suit,
            colours = {
                G.C.SUITS[display_card.suit]
            }
        },
    }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then
        return false
    end

    local tally = 0
    for i = 1, #args.cards do
        local key = SMODS.Suits[args.cards[i].base.suit].card_key..'_'..SMODS.Ranks[args.cards[i].base.value].card_key
        if key == self.unlock_condition.card_key then
            tally = tally+1
        end
    end

    return tally >= self.unlock_condition.amount
end

function jokerInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then
        return
    end
    
    if context.cardarea == G.jokers and context.remove_playing_cards then
        card.ability.extra.destroy_count = card.ability.extra.destroy_count + #context.removed
        local num_reps = math.floor(card.ability.extra.destroy_count /card.ability.extra.destroy)
        card.ability.extra.destroy_count = card.ability.extra.destroy_count % card.ability.extra.destroy

        if not context.blueprint and num_reps < 1 then
            return {
                message = localize{type='variable',key='a_remaining',vars={card.ability.extra.destroy - card.ability.extra.destroy_count}},
                card = card
            }
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                if context.blueprint_card then
                    context.blueprint_card:juice_up()
                else
                    card:juice_up()
                end
                play_sound('generic1')
                return true
            end
        }))

        for i=1, num_reps do
            local new_card = create_playing_card(
                { front = G.P_CARDS.H_K, center = G.P_CENTERS.c_base }, G.discard, true, nil, { G.C.RED }, true
            )
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand:emplace(new_card)
                    new_card:start_materialize()
                    G.GAME.blind:debuff_card(new_card)
                    G.hand:sort()
                    return true
                end
            }))
            playing_card_joker_effects({new_card})
        end

        
    end
end

return jokerInfo