local jokerInfo = {
	name = 'High Numbers',
	config = {
        extra = {
            x_mult_mod = 0.25,
            unlock_count = 4,
        },
    },
	rarity = 3,
	cost = 9,
    unlocked = false,
    hasSoul = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'rockhard',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_cringe", set = "Other"}
    if not G.GAME.run_consumeables then
        return { vars = { card.ability.extra.x_mult_mod, 1 } }
    end
    local cryptids = G.GAME.run_consumeables['c_cryptid'] or 0
    local deaths = G.GAME.run_consumeables['c_death'] or 0
    local hung_men = G.GAME.run_consumeables['c_hanged_man'] or 0
    return { 
        vars = { 
            card.ability.extra.x_mult_mod, 
            1 + card.ability.extra.x_mult_mod * (cryptids + deaths + hung_men)
        }
    }
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.unlock_count}}
end

function jokerInfo.check_for_unlock(self, args)
    if not G.playing_cards then
        return false
    end
    
    local card_identity_table = {}
    for _, v in ipairs(G.playing_cards) do
        local key = v.config.card_key

        key = key..'_'..v.config.center.key
        if v.seal then key = key..'_'..v.seal end
        if v.edition then key = key..'_'..v.edition.type end
        if not card_identity_table[key] then card_identity_table[key] = 0 end
        card_identity_table[key] = card_identity_table[key] + 1
        if (card_identity_table[key] >= 4) then
            return true
        end
    end

    return false
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.using_consumeable and not context.blueprint then
        if context.consumeable.ability.name == 'Cryptid' 
        or context.consumeable.ability.name == 'Death'
        or context.consumeable.ability.name == 'Hanged Man' then
            local cryptids = G.GAME.consumeables['c_cryptid'] or 0
            local deaths = G.GAME.run_consumeables['c_death'] or 0
            local hung_men = G.GAME.run_consumeables['c_hanged_man'] or 0
            local total = cryptids + deaths + hung_men
            card_eval_status_text(
                card,
                'extra',
                nil,
                nil,
                nil,
                {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {1 + card.ability.extra.x_mult_mod * total}},
                    colour = G.C.MULT
                }
            )
        end
    end

    if context.cardarea == G.jokers and context.joker_main then
        local cryptids = G.GAME.run_consumeables['c_cryptid'] or 0
        local deaths = G.GAME.run_consumeables['c_death'] or 0
        local hung_men = G.GAME.run_consumeables['c_hanged_man'] or 0
        local total = 1 + card.ability.extra.x_mult_mod * (cryptids + deaths + hung_men)
        if total > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={total}},
                card = context.blueprint_card or card,
                Xmult_mod = total,
            }
        end
    end
end

return jokerInfo