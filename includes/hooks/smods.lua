SMODS.current_mod.reset_game_globals = function(run_start)
    if run_start then
        G.GAME.fnwk_glass_shatters = 0
        G.GAME.fnwk_patsy_jokers_sold = 0
        G.GAME.fnwk_owned_jokers = {}
        G.GAME.fnwk_extra_discounts = {}
        G.GAME.fnwk_chip_novas = 0
        G.GAME.fnwk_consecutive_hands = 0
    end

    G.GAME.current_round.fnwk_paperback_rerolls = #SMODS.find_card('c_fnwk_streetlight_paperback')
    G.GAME.current_round.fnwk_packs_rerolled = 0
    fnwk_reset_funkadelic()
    fnwk_reset_infidel()
    fnwk_reset_loyal()

    for _, v in ipairs(G.playing_cards) do
        v.ability.fnwk_strut_this_hand = nil
    end

    if G.GAME.modifiers.fnwk_fanworks_standoff then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            after = 1,
            func = function()
                local rand_stands = {}
                for _, v in ipairs(G.consumeables.cards) do
                    if v.ability.set == 'Stand' then rand_stands[#rand_stands+1] = v end
                end

                if #rand_stands < 1 then return true
                elseif #rand_stands > 1 and not run_start then
                    local stand = pseudorandom_element(rand_stands, 'fnwk_standoff_select')
                    rand_stands = { stand }
                end

                for i, v in ipairs(rand_stands) do
                    local _pool, _pool_key = get_current_pool('Stand', nil, nil, 'fnwk_standoff')
                    local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
                    local it = 1
                    while center == 'UNAVAILABLE' or center == v.config.center.key do
                        it = it + 1
                        center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
                    end

                    v.ability.evolved = nil
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            ArrowAPI.game.transform_card(v, center, false, true)
                            save_run()
                            return true
                        end
                    }))
                    card_eval_status_text(v, 'extra', nil, nil, nil, {
                        message = localize('k_stand_replaced'),
                        colour = G.C.DARK_EDITION,
                        sound = 'polychrome1'
                    })

                    if i ~= #rand_stands then
                        delay(0.3)
                    end
                end
                return true
            end
        }))
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
function SMODS.smeared_check(...)
    local smeared = next(SMODS.find_card('k_smeared'))
    local infidel = next(SMODS.find_card('j_fnwk_rubicon_infidel'))
    if infidel and smeared then
        if not ((G.GAME.fnwk_infidel_suits['Hearts'] and G.GAME.fnwk_infidel_suits['Diamonds'])
        or (G.GAME.fnwk_infidel_suits['Spades'] and G.GAME.fnwk_infidel_suits['Clubs'])) then
            return true
        end
    end

    local ret = ref_smeared_check(...)

    local args = { ... }
    local card = args[1]
    local suit = args[2]

    if not ret and infidel then
        local infidelSuits = {}
        for k, _ in pairs(G.GAME.fnwk_infidel_suits) do
            infidelSuits[#infidelSuits+1] = k
        end
        if (card.base.suit == infidelSuits[1] or card.base.suit == infidelSuits[2]) and (suit == infidelSuits[1] or suit == infidelSuits[2]) then
            ret = true -- main true/false return
        end
    end

    return ret
end

local valid_keys = {
    ['p_dollars'] = true,
    ['dollars'] = true,
    ['h_dollars'] = true,
    ['mult'] = true,
    ['h_mult'] = true,
    ['mult_mod'] = true,
    ['chips'] = true,
    ['h_chips'] = true,
    ['chip_mod'] = true,
    ['x_chips'] = true,
    ['xchips'] = true,
    ['Xchip_mod'] = true,
    ['x_mult'] = true,
    ['xmult'] = true,
    ['Xmult'] = true,
    ['x_mult_mod'] = true,
    ['Xmult_mod'] = true,
    ['swap'] = true,
    ['balance'] = true,
    ['level_up'] = true
}

local ref_indv_effect = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition, ...)
    if not (G.GAME.blind and G.GAME.blind.in_blind and G.GAME.blind.config.blind.key == 'bl_fnwk_bolt') then
        return ref_indv_effect(effect, scored_card, key, amount, from_edition, ...)
    end

    local old_card = effect.card
    G.fnwk_message_cancel = nil
    local cancel = true
    for k, v in pairs(effect) do
        if valid_keys[k] then
            cancel = false
            break
        end
    end
    
    if cancel and (not effect.card or (effect.card and not effect.card.playing_card)) then
        G.fnwk_message_cancel = true
        effect.card = nil
    end

    local ret = ref_indv_effect(effect, scored_card, key, amount, from_edition, ...)
    G.fnwk_message_cancel = nil
    effect.card = old_card
    return ret
end


---------------------------
--------------------------- The Written Blind behavior
---------------------------

local ref_no_suit = SMODS.has_no_suit
function SMODS.has_no_suit(...)
    return (G.GAME and G.GAME.modifiers.fnwk_no_suits) or ref_no_suit(...)
end

local ref_showman = SMODS.showman
function SMODS.showman(...)
    local ret = ref_showman(...)
    if not ret then
        local args = {...}
        local card_key = args[1]
        ret = (G.GAME and G.GAME.modifiers.fnwk_duplicates_allowed and G.P_CENTERS[card_key].set == 'Joker')
    end

    return ret
end