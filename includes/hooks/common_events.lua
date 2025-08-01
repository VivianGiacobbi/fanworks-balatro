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
        level_up_hand_bypass(card, k, true, amount, true)
        G.GAME.fnwk_last_upgraded_hand[k] = true
    end
    SMODS.calculate_context({fnwk_hand_upgraded = true, upgraded = hands, amount = amount})
end

function level_up_hand_bypass(card, hand, instant, amount, bypass_event)
    local ret = level_up_hand(card, hand, instant, amount)

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
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card, ...) 
    local not_full = not full_UI_table
    if not_full then
        if _c.loc_vars and type(_c.loc_vars) == 'function' then
            main_start = nil
            main_end = nil
        end

        main_card = card
    else
        if full_UI_table.name and main_card and main_card.config and main_card.config.center and main_card.config.center.key == 'c_fnwk_double_geometrical' then
            full_UI_table.name[1].nodes[2].config.ref_table = main_card
            main_card = nil
        elseif main_card and main_card.fnwk_disturbia_joker then
            if _c ~= G.P_CENTERS['c_fnwk_streetlight_disturbia'] and _c.key ~= "fnwk_artist_1" then
                return full_UI_table
            end
        end
    end

    return ref_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card, ...)
end





---------------------------
--------------------------- card created context
---------------------------

local ref_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, ...)
    if G.GAME.starting_params.fnwk_act_rarity and area == G.shop_jokers and _type == 'Joker' then
        if G.GAME.round_resets.blind_states.Small == 'Upcoming' then
            _rarity = 'Rare'
        elseif G.GAME.round_resets.blind_states.Small == 'Defeated' and G.GAME.round_resets.blind_states.Big == 'Upcoming' then
            _rarity = 'Common'
        elseif G.GAME.round_resets.blind_states.Big == 'Defeated' and G.GAME.round_resets.blind_states.Boss == 'Upcoming' then
            _rarity = 'Uncommon'
        end
    end

    local ret = ref_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, ...)

    SMODS.calculate_context({fnwk_created_card = true, card = ret, area = area})

    if G.GAME.modifiers.consumable_selection_mod and G.GAME.modifiers.consumable_selection_mod ~= 0
    and ret.ability and ret.ability.consumeable and ret.ability.max_highlighted then
        ret.ability.max_highlighted = ret.ability.max_highlighted + G.GAME.modifiers.consumable_selection_mod
    end

    return ret
end





---------------------------
--------------------------- Value easing contexts
---------------------------

local ref_ease_hands = ease_hands_played
function ease_hands_played(...)
    local ret = ref_ease_hands(...)
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
function ease_discard(...)
    local ret = ref_ease_discards(...)
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
function ease_dollars(...)
    local ret = ref_ease_dollars(...)
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
function ease_ante(...)
    local ret = ref_ease_ante(...)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            SMODS.calculate_context({fnwk_change_ante = true})
            return true
        end
    }))
    return ret
end





---------------------------
--------------------------- Skip scale messaging for Bolt blind
---------------------------

local ref_eval_card = eval_card
function eval_card(...)
    local args = {...}
    local card, context = args[1], args[2]
    if card.fnwk_disturbia_joker then return {}, {} end

    if G.GAME.modifiers.fnwk_no_hand_effects and context.cardarea == G.hand then
        return {}, {}
    end

    G.fnwk_message_cancel = G.GAME.blind and G.GAME.blind.in_blind and G.GAME.blind.config.blind.key == 'bl_fnwk_bolt'
    local ret = ref_eval_card(...)
    G.fnwk_message_cancel = nil
    return ret
end


local ref_card_text = card_eval_status_text
function card_eval_status_text(...)
    if G.fnwk_message_cancel then
        return
    end

    return ref_card_text(...)
end





---------------------------
--------------------------- Shimmering Deck Behavior
---------------------------

local ref_reroll_cost = calculate_reroll_cost
function calculate_reroll_cost(...)
    if G.GAME.starting_params.fnwk_only_free_rerolls then
        G.GAME.current_round.reroll_cost_increase = 0
        G.GAME.current_round.reroll_cost = 0
        return
    end

    return ref_reroll_cost(...)
end





---------------------------
--------------------------- The Manga background effect
---------------------------

local ref_background_blind = ease_background_colour_blind
function ease_background_colour_blind(...)
    local args = {...}
    local state = args[1]
    if state == G.STATES.ROUND_EVAL then
        -- reset the table references so the gradients aren't active anymore
        if G.GAME.fnwk_gradient_background then
            G.C.BACKGROUND.L = { G.C.BACKGROUND.L[1], G.C.BACKGROUND.L[2], G.C.BACKGROUND.L[3], G.C.BACKGROUND.L[4] }
            G.C.BACKGROUND.D = { G.C.BACKGROUND.D[1], G.C.BACKGROUND.D[2], G.C.BACKGROUND.D[3], G.C.BACKGROUND.D[4] }
            G.C.BACKGROUND.C = { G.C.BACKGROUND.C[1], G.C.BACKGROUND.C[2], G.C.BACKGROUND.C[3], G.C.BACKGROUND.C[4] }
            G.C.BACKGROUND.contrast = G.C.BACKGROUND.contrast
            G.GAME.fnwk_gradient_background = nil
        end

        if G.GAME.fnwk_gradient_ui then
            G.C.DYN_UI.MAIN = { G.C.DYN_UI.MAIN[1], G.C.DYN_UI.MAIN[2], G.C.DYN_UI.MAIN[3], G.C.DYN_UI.MAIN[4] }
            G.C.DYN_UI.DARK = { G.C.DYN_UI.DARK[1], G.C.DYN_UI.DARK[2], G.C.DYN_UI.DARK[3], G.C.DYN_UI.DARK[4] }
            G.C.DYN_UI.BOSS_MAIN = { G.C.DYN_UI.BOSS_MAIN[1], G.C.DYN_UI.BOSS_MAIN[2], G.C.DYN_UI.BOSS_MAIN[3], G.C.DYN_UI.BOSS_MAIN[4] }
            G.C.DYN_UI.BOSS_DARK = { G.C.DYN_UI.BOSS_DARK[1], G.C.DYN_UI.BOSS_DARK[2], G.C.DYN_UI.BOSS_DARK[3], G.C.DYN_UI.BOSS_DARK[4] }
            G.GAME.fnwk_gradient_ui = nil
            FnwkManualUIReload(0)
        end
    elseif G.GAME.blind and G.GAME.blind.in_blind then
        local blind = G.P_BLINDS[G.GAME.blind.config.blind.key]
        local col_primary = blind.boss_colour and blind.boss_colour.colours and blind.boss_colour or nil
        local col_special = blind.special_colour and blind.special_colour.colours and blind.special_colour or nil
        local col_tertiary = blind.tertiary_colour and blind.tertiary_colour.colours and blind.tertiary_colour or nil
        
        if col_primary or col_special or col_tertiary then
            G.GAME.fnwk_gradient_background = true

            if col_primary and col_primary ~= G.C.BACKGROUND.L then
                local predict_primary = SMODS.predict_gradient(col_primary, 0.8)
                ease_value(G.C.BACKGROUND.L, 1, predict_primary[1]*1.3 - G.C.BACKGROUND.L[1], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.L, 2, predict_primary[2]*1.3 - G.C.BACKGROUND.L[2], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.L, 3, predict_primary[3]*1.3 - G.C.BACKGROUND.L[3], false, nil, true, 0.8)
                G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					delay =  0.85,
					func = function()
						G.C.BACKGROUND.L = col_primary
						return true
					end
				}))
            elseif blind.boss_colour ~= G.C.BACKGROUND.L then
                ease_value(G.C.BACKGROUND.L, 1, blind.boss_colour[1]*1.3 - G.C.BACKGROUND.L[1], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.L, 2, blind.boss_colour[2]*1.3 - G.C.BACKGROUND.L[2], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.L, 3, blind.boss_colour[3]*1.3 - G.C.BACKGROUND.L[3], false, nil, true, 0.8)
            end

            if col_special and col_special ~= G.C.BACKGROUND.C then
                local predict_special = SMODS.predict_gradient(col_special, 0.8)
                ease_value(G.C.BACKGROUND.C, 1, predict_special[1]*1.3 - G.C.BACKGROUND.C[1], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.C, 2, predict_special[2]*1.3 - G.C.BACKGROUND.C[2], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.C, 3, predict_special[3]*1.3 - G.C.BACKGROUND.C[3], false, nil, true, 0.8)
                G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					delay =  0.85,
					func = function()
						G.C.BACKGROUND.C = col_special
						return true
					end
				}))
            elseif (blind.special_colour or blind.boss_colour) ~= G.C.BACKGROUND.C then
                col_special = blind.special_colour or blind.boss_colour
                ease_value(G.C.BACKGROUND.C, 1, col_special[1]*0.9 - G.C.BACKGROUND.C[1], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.C, 2, col_special[2]*0.9 - G.C.BACKGROUND.C[2], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.C, 3, col_special[3]*0.9 - G.C.BACKGROUND.C[3], false, nil, true, 0.8)
            end

            if col_tertiary and col_tertiary ~= G.C.BACKGROUND.D then
                local predict_tertiary = SMODS.predict_gradient(col_tertiary, 0.8)
                ease_value(G.C.BACKGROUND.D, 1, predict_tertiary[1]*0.4 - G.C.BACKGROUND.D[1], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.D, 2, predict_tertiary[2]*0.4 - G.C.BACKGROUND.D[2], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.D, 3, predict_tertiary[3]*0.4 - G.C.BACKGROUND.D[3], false, nil, true, 0.8)
                G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					delay =  0.85,
					func = function()
						G.C.BACKGROUND.D = col_tertiary
						return true
					end
				}))
            elseif (blind.tertiary_colour or blind.boss_colour) ~= G.C.BACKGROUND.D then
                col_tertiary = blind.tertiary_colour or blind.boss_colour
                ease_value(G.C.BACKGROUND.D, 1, col_tertiary[1]*0.4 - G.C.BACKGROUND.D[1], false, nil, true, 0.6)
                ease_value(G.C.BACKGROUND.D, 2, col_tertiary[2]*0.4 - G.C.BACKGROUND.D[2], false, nil, true, 0.6)
                ease_value(G.C.BACKGROUND.D, 3, col_tertiary[3]*0.4 - G.C.BACKGROUND.D[3], false, nil, true, 0.6)
            end

            G.C.BACKGROUND.contrast = blind.contrast or G.C.BACKGROUND.contrast
            return
        end
    end

    return ref_background_blind(...)
end



---------------------------
--------------------------- Third Act Breakdown Challenge support
---------------------------

-- evil bad overwrite
function get_new_boss(...)
    -- keep these two cases
    -- idk what it's used for but maybe modded cards can change this which I still want o allow
    G.GAME.perscribed_bosses = G.GAME.perscribed_bosses or {}
    if G.GAME.perscribed_bosses and G.GAME.perscribed_bosses[G.GAME.round_resets.ante] then
        local ret_boss = G.GAME.perscribed_bosses[G.GAME.round_resets.ante] 
        G.GAME.perscribed_bosses[G.GAME.round_resets.ante] = nil
        G.GAME.bosses_used[ret_boss] = G.GAME.bosses_used[ret_boss] + 1
        return ret_boss
    elseif G.FORCE_BOSS then return G.FORCE_BOSS end

    local args = {...}
    local replace_type = args[1] or 'Boss'
    local get_showdown = (replace_type == 'Boss' and (G.GAME.modifiers.fnwk_all_showdown or ((G.GAME.round_resets.ante%G.GAME.win_ante) == 0 and G.GAME.round_resets.ante >= 1)))

    local eligible_bosses = {}
    local num_bosses = 0
    local min_use = 1000
    for k, v in pairs(G.P_BLINDS) do
        if v.boss and not G.GAME.banned_keys[k] and G.GAME.bosses_used[k] <= min_use then
            local valid = (v.in_pool and type(v.in_pool) == 'function' and v:in_pool()) or true
            if valid and ((get_showdown and v.boss.showdown) or (not get_showdown and not v.boss.showdown and v.boss.min <= math.max(1, G.GAME.round_resets.ante))) then
                if G.GAME.bosses_used[k] < min_use then
                    min_use = G.GAME.bosses_used[k]
                    eligible_bosses = {}
                end
                eligible_bosses[k] = true
                num_bosses = num_bosses + 1
            end
        end
    end

    if num_bosses < 1 then return 'bl_small' end

    local _, boss = pseudorandom_element(eligible_bosses, pseudoseed('boss'))
    G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] + 1
    return boss
end

local ref_reset_blinds = reset_blinds
function reset_blinds(...)
    local boss_defeated = G.GAME.round_resets.blind_states.Boss == 'Defeated'
    local ret = ref_reset_blinds(...)

    if boss_defeated and G.GAME.modifiers.fnwk_all_bosses then
        G.GAME.round_resets.blind_choices.Small = get_new_boss('Small')
        G.GAME.round_resets.blind_choices.Big = get_new_boss('Big')
    end

    return ret
end