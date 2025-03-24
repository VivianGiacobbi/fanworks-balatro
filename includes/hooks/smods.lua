SMODS.current_mod.reset_game_globals = function(run_start)
    if run_start then
        G.GAME.glass_shatters = 0
        G.GAME.patsy_jokers_sold = 0
        G.GAME.owned_jokers = {}
        G.GAME.extra_discounts = {}
        G.GAME.run_consumeables = {}
        G.GAME.chip_novas = 0
        G.GAME.consecutive_hands = 0
    end

    G.GAME.current_round.packs_rerolled = 0
    reset_funkadelic()
    reset_infidel()

    for k, v in pairs(G.playing_cards) do
        v.joker_force_facedown = nil
        v.ability.played_while_flipped = nil
    end
end

--- Add effects for non-main editions to an effects table, similar to SMODS.calculate_quantum_enhancements()
--- @param card table Balatro card table to find extra editions on
--- @param effects table Balatro effects table, created in eval_card() misc function
--- @param context table Context able used for eval_card() function
--- @return boolean # Whether or not any quantum editions were found and calculated
function SMODS.calculate_quantum_editions(card, effects, context)
    if not card.edition then
        return false
    end

    context.extra_edition = true
    local extra_editions = SMODS.get_quantum_editions(card)
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
function SMODS.get_quantum_editions(card)
    if card.edition.others and nexts(card.edition.others) then
        local extras = copy_table(card.edition.others)
        return extras
    end
    return {}
end