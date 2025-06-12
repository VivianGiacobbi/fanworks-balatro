---------------------------
--------------------------- Fanworks related global reset functions
---------------------------

function fnwk_reset_funkadelic()
    G.GAME.fnwk_current_funky_suits = {}
    local suits = {}
    for _, suit in pairs(SMODS.Suits) do
        suits[#suits+1] = suit.key
    end

    local firstIdx = math.floor(pseudorandom('fnwk_funk'..G.GAME.round_resets.ante) * 4) + 1
    G.GAME.fnwk_current_funky_suits[1] = suits[firstIdx]
    table.remove(suits, firstIdx)
    G.GAME.fnwk_current_funky_suits[2] = pseudorandom_element(suits, pseudoseed('fnwk_funk'..G.GAME.round_resets.ante))
end

function fnwk_reset_loyal()
    G.GAME.fnwk_current_loyal_suit = pseudorandom_element(SMODS.Suits, pseudoseed('fnwk_loyal')).key
end

function fnwk_reset_infidel()

    local suits = {}
    for _, suit in pairs(SMODS.Suits) do
        suits[#suits+1] = suit.key
    end

    local j, temp
	for i = #suits, 1, -1 do
		j = math.floor(pseudorandom('fnwk_infidel'..G.GAME.round_resets.ante) * #suits) + 1
		temp = suits[i]
		suits[i] = suits[j]
		suits[j] = temp
	end

    G.GAME.fnwk_infidel_suits= {
        [suits[1]] = true,
        [suits[2]] = true,
    }
end





---------------------------
--------------------------- Hand Level Up helper functions and contexts
---------------------------

function fnwk_batch_level_up(card, hands, amount)
    amount = amount or 1
    G.GAME.fnwk_last_upgraded_hand = {}
    for k, _ in pairs(hands) do
        level_up_hand(card, k, true, amount, true)
        G.GAME.fnwk_last_upgraded_hand[k] = true
    end
    SMODS.calculate_context({fnwk_hand_upgraded = true, upgraded = hands, amount = amount})
end

local ref_level_up_hand = level_up_hand
function level_up_hand(card, hand, instant, amount, bypass_event)
    local ret = ref_level_up_hand(card, hand, instant, amount)

    if not bypass_event then
        G.GAME.fnwk_last_upgraded_hand = {[hand] = true}
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                SMODS.calculate_context({fnwk_hand_upgraded = true, upgraded = {[hand] = true}, amount = amount})
                return true
            end
        }))
    end
    
    return ret
end






---------------------------
--------------------------- Force clear main_start and main_end
---------------------------
local main_card = nil

local ref_card_ui = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)  
    local not_full = not full_UI_table
    if not_full then
        if _c.loc_vars and type(_c.loc_vars) == 'function' then
            main_start = nil
            main_end = nil
        end

        main_card = card
    else
        if full_UI_table.name and main_card and main_card.config.center.key == 'c_fnwk_double_geometrical' then
            full_UI_table.name[1].nodes[2].config.ref_table = main_card
            main_card = nil
        elseif main_card.fnwk_disturbia_joker then
            if _c ~= G.P_CENTERS['c_fnwk_streetlight_disturbia'] and _c.key ~= "fnwk_artist_1" then
                return full_UI_table
            end
        end
    end

    local ret = ref_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)

    return ret
end





---------------------------
--------------------------- card created context
---------------------------

local ref_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if G.GAME.starting_params.fnwk_act_rarity and area == G.shop_jokers and _type == 'Joker' then
        if G.GAME.round_resets.blind_states.Small == 'Upcoming' then
            _rarity = 'Rare'
        elseif G.GAME.round_resets.blind_states.Small == 'Defeated' and G.GAME.round_resets.blind_states.Big == 'Upcoming' then
            _rarity = 'Common'
        elseif G.GAME.round_resets.blind_states.Big == 'Defeated' and G.GAME.round_resets.blind_states.Boss == 'Upcoming' then
            _rarity = 'Uncommon'
        end
    end
    
    local ret = ref_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)

    SMODS.calculate_context({fnwk_created_card = true, card = ret, area = area})

    return ret
end





---------------------------
--------------------------- Value easing contexts
---------------------------

local ref_ease_hands = ease_hands_played
function ease_hands_played(mod, instant)
    local ret = ref_ease_hands(mod, instant)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            SMODS.calculate_context({fnwk_change_hands = true})
            return true
        end
    }))

    return ret
end

local ref_ease_discards = ease_discard
function ease_discard(mod, instant, silent)
    local ret = ref_ease_discards(mod, instant, silent)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            SMODS.calculate_context({fnwk_change_discards = true})
            return true
        end
    }))
    return ret
end

local ref_ease_dollars = ease_dollars
function ease_dollars(mod, instant)
    local ret = ref_ease_dollars(mod, instant)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            SMODS.calculate_context({fnwk_change_dollars = true})
            return true
        end
    }))
    return ret
end

local ref_ease_ante = ease_ante
function ease_ante(mod)
    local ret = ref_ease_ante(mod)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            SMODS.calculate_context({fnwk_change_ante = true})
            return true
        end
    }))
    return ret
end


local ref_eval_card = eval_card
function eval_card(card, context)
    if card.fnwk_disturbia_joker then return {}, {} end

    return ref_eval_card(card, context)
end