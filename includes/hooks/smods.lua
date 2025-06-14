SMODS.current_mod.reset_game_globals = function(run_start)
    if run_start then
        G.GAME.fnwk_glass_shatters = 0
        G.GAME.fnwk_patsy_jokers_sold = 0
        G.GAME.fnwk_owned_jokers = {}
        G.GAME.fnwk_extra_discounts = {}
        G.GAME.fnwk_chip_novas = 0
        G.GAME.fnwk_consecutive_hands = 0
        G.GAME.fnwk_extra_blinds = {}
    end

    G.GAME.current_round.fnwk_paperback_rerolls = #SMODS.find_card('c_fnwk_streetlight_paperback')
    G.GAME.current_round.fnwk_packs_rerolled = 0
    fnwk_reset_funkadelic()
    fnwk_reset_infidel()
    fnwk_reset_loyal()

    for _, v in ipairs(G.playing_cards) do
        v.ability.fnwk_strut_this_hand = nil
    end
end

--- Add effects for non-main editions to an effects table, similar to SMODS.calculate_quantum_enhancements()
--- @param card table Balatro card table to find extra editions on
--- @param effects table Balatro effects table, created in eval_card() misc function
--- @param context table Context able used for eval_card() function
--- @return boolean # Whether or not any quantum editions were found and calculated
function SMODS.fnwk_calculate_quantum_editions(card, effects, context)
    if not card.edition then
        return false
    end

    context.extra_edition = true
    local extra_editions = SMODS.fnwk_get_quantum_editions(card)
    if #extra_editions < 1 then
        return false
    end
    local old_edition = copy_table(card.edition)

    
    for i, v in ipairs(extra_editions) do
        if G.P_CENTERS[v.key] then
            
            card.edition = v
            local eval = {edition = card:calculate_edition(context)}
            if eval then
                effects[#effects+1] = eval
            end
        end
    end
    
    card.edition = old_edition
    context.extra_edition = nil
    return true
end

--- Return any quantum editions from a card
--- @param card table Balatro card table to find extra editions on
--- @return table extras An indexed table containing extra editions, formatted like card.edition in vanilla
function SMODS.fnwk_get_quantum_editions(card)
    if card.edition.others and next(card.edition.others) then
        local extras = copy_table(card.edition.others)
        return extras
    end
    return {}
end


local ref_smeared_check = SMODS.smeared_check
function SMODS.smeared_check(card, suit)
    local smeared = next(SMODS.find_card('k_smeared'))
    local infidel = next(SMODS.find_card('j_fnwk_rubicon_infidel'))
    if infidel and smeared then
        if not ((G.GAME.fnwk_infidel_suits['Hearts'] and G.GAME.fnwk_infidel_suits['Diamonds'])
        or (G.GAME.fnwk_infidel_suits['Spades'] and G.GAME.fnwk_infidel_suits['Clubs'])) then
            return true
        end
    end

    local ret = ref_smeared_check(card, suit)

    if not ret and infidel then
        local infidelSuits = {}
        for k, _ in pairs(G.GAME.fnwk_infidel_suits) do
            infidelSuits[#infidelSuits+1] = k
        end
        if (card.base.suit == infidelSuits[1] or card.base.suit == infidelSuits[2]) and (suit == infidelSuits[1] or suit == infidelSuits[2]) then
            ret = true
        end
    end

    return ret
end