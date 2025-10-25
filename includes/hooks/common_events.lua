---------------------------
--------------------------- Fanworks related global reset functions
---------------------------

function fnwk_reset_funkadelic()
    G.GAME.fnwk_current_funky_suits = {}
    local suits = {}
    for k, _ in pairs(SMODS.Suits) do
        suits[#suits+1] = k
    end

    for i=1, 2 do
        local suit = table.remove(suits, pseudorandom('fnwk_funk'..G.GAME.round_resets.ante, 1, #suits))
        G.GAME.fnwk_current_funky_suits[suit] = true
    end
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

    G.GAME.fnwk_infidel_suits = {
        main_suit = suits[1],
        [suits[1]] = true,
        [suits[2]] = true,
    }
end





---------------------------
--------------------------- Force clear main_start and main_end
---------------------------
local main_card = nil

local ref_card_ui = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card, ...)
    if not full_UI_table then main_card = card
    elseif main_card and main_card.fnwk_disturbia_joker then
        if _c ~= G.P_CENTERS['c_fnwk_streetlight_disturbia'] and _c.key ~= "fnwk_artist_1" then
            return full_UI_table
        end
    end

    if _c == G.P_CENTERS['c_fnwk_redrising_invisible'] and card_type == 'Locked' then
        card_type = 'Undiscovered'
        hide_desc = true
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

    if area == G.shop_jokers and next(G.GAME.fnwk_saved_resils) and G.GAME.fnwk_rerolls_this_round == 0
	and not (G.SETTINGS.tutorial_progress and G.SETTINGS.tutorial_progress.forced_shop
	and G.SETTINGS.tutorial_progress.forced_shop[#G.SETTINGS.tutorial_progress.forced_shop]) then
		-- hate doing this
		local pop_resil = table.remove(G.GAME.fnwk_saved_resils, 1)
		local card = Card(
			area.T.x + area.T.w/2,
			area.T.y,
			G.CARD_W,
			G.CARD_H,
			nil,
			G.P_CENTERS[pop_resil.key]
		)

		card.ability.fnwk_resil_id = pop_resil.fnwk_resil_id
		card.ability.extra.times_sold = pop_resil.times_sold
        card.ability.extra.mult = pop_resil.mult
        card.ability.fnwk_resil_form = '_regen'
		card.cost = card.cost + (card.ability.extra.cost_mod * card.ability.extra.times_sold)
		card:set_edition(pop_resil.edition)
        card.children.center:set_sprite_pos({x = 1, y = 0})
		create_shop_card_ui(card)

		return card
	end

    local ret = ref_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, ...)

    if G.GAME.modifiers.fnwk_completed_stakes_in_shop and (area == G.shop_jokers or area == G.pack_cards) then
        local sticker_opts = {}
        if not SMODS.Stickers['eternal'].should_apply then sticker_opts[#sticker_opts+1] = 'eternal' end
        if not SMODS.Stickers['perishable'].should_apply then sticker_opts[#sticker_opts+1] = 'perishable' end
        if not SMODS.Stickers['rental'].should_apply then sticker_opts[#sticker_opts+1] = 'rental' end

        if #sticker_opts > 0 then
            local sticker = pseudorandom_element(sticker_opts, 'fnwk_complted_stake'..G.GAME.round_resets.ante)
            card['set_'..sticker](self, true)
        end
    end

    return ret
end





---------------------------
--------------------------- act sleeve legendary force
---------------------------

local ref_shop_card = create_card_for_shop
function create_card_for_shop(area)
    if G.GAME.starting_params.fnwk_act_force_legend_ante and not G.GAME.modifiers.fnwk_used_act_legend
    and G.GAME.round_resets.ante >= G.GAME.starting_params.fnwk_act_force_legend_ante then
        local legend = pseudorandom_element(G.P_JOKER_RARITY_POOLS[4], pseudoseed('Joker4'))
        local force_legend = create_card('Joker', area, nil, nil, nil, nil, legend.key, 'fnwk_act_force_legend')
        force_legend.states.visible = false
        G.E_MANAGER:add_event(Event({
            delay = 0.4,
            trigger = 'after',
            func = (function()
                force_legend:start_materialize()
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('polychrome1', 1.2 + math.random()*0.1, 0.4)
                force_legend:juice_up()
                return true
            end)
        }))

        G.GAME.modifiers.fnwk_used_act_legend = true
        create_shop_card_ui(force_legend)
        return force_legend
    end

    return ref_shop_card(area)
end

-- forces legendaries obtained via other means to not be unlocked normally
local ref_discover_card = discover_card
function discover_card(card)
    card = card or {}
    if not card.unlocked then return end
    return ref_discover_card(card)
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

local ease_dollar_ref = ease_dollars
function ease_dollars(mod, instant)
    if mod >= 0 and G.GAME.modifiers.fnwk_no_money then return end
    return ease_dollar_ref(mod, instant)
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
    local ret, post = ref_eval_card(...)
    G.fnwk_message_cancel = nil
    return ret, post
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
--------------------------- showing The Bathroom when unlocked
---------------------------

local ref_init_items = Game.init_item_prototypes
function Game:init_item_prototypes()
    local ret = ref_init_items(self)

    if G.P_CENTERS.j_fnwk_fanworks_bathroom.unlocked then
        G.P_CENTERS.j_fnwk_fanworks_bathroom.no_collection = nil
    end
end