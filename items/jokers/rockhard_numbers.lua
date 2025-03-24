local jokerInfo = {
    key = 'j_fnwk_rockhard_numbers',
	name = 'High Numbers',
	config = {
        extra = {
            x_mult_mod = 0.25,
        },
    },
	rarity = 3,
	cost = 8,
    unlocked = false,
    unlock_condition = {type = 'modify_deck', unlock_count = 4},
    hasSoul = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	fanwork = 'rockhard',
    alt_art = true
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
    return { vars = { self.unlock_condition.unlock_count}}
end

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then
        return false
    end
    
    local card_identity_table = {}
    for _, card in ipairs(G.playing_cards) do
        local key = card.config.card_key

        key = key..'_'..card.config.center.key
        if card.seal then key = key..'_'..card.seal end
        if card.edition then key = key..'_'..card.edition.type end
        if not card_identity_table[key] then card_identity_table[key] = 0 end
        card_identity_table[key] = card_identity_table[key] + 1
        if (card_identity_table[key] >= self.unlock_condition.unlock_count) then
            return true
        end
    end

    return false
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.using_consumeable and not context.blueprint then
        if context.consumeable.ability.name == 'Cryptid' 
        or context.consumeable.ability.name == 'Death'
        or context.consumeable.ability.name == 'The Hanged Man' then
            local cryptids = G.GAME.run_consumeables['c_cryptid'] or 0
            local deaths = G.GAME.run_consumeables['c_death'] or 0
            local hung_men = G.GAME.run_consumeables['c_hanged_man'] or 0
            local total = cryptids + deaths + hung_men
            return {
                message = localize('k_upgrade_ex'),
                message_card = card,
            }
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