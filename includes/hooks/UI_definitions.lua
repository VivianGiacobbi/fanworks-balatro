---------------------------
--------------------------- Maggie Speech Bubble Support
---------------------------

function G.UIDEF.jok_speech_bubble(text_key, loc_vars, extra)
    local text = {}
    local extra = extra or {}

    localize{type = 'quips', key = text_key, vars = loc_vars or {}, nodes = text}
    local row = {}
    for k, v in ipairs(text) do
        --v[1].config.colour = extra.text_colour or v[1].config.colour or G.C.JOKER_GREY
        row[#row+1] =  {n=G.UIT.R, config={align = extra.text_alignment or "cl"}, nodes=v}
    end
    local t = {n=G.UIT.ROOT, config = {align = "cm", minh = 1, r = 0.3, padding = 0.07, minw = 1, colour = extra.root_colour or G.C.JOKER_GREY, shadow = true}, nodes={
        {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.1, minw = 1, colour = extra.bg_colour or G.C.WHITE}, nodes={
            {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.03, minw = 1, colour = extra.bg_colour or G.C.WHITE}, nodes=row}}
        }
    }}
    return t
end





---------------------------
--------------------------- The Creek score modifiers
---------------------------

function G.UIDEF.predict_card_ui(cardarea)
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minh = 1, r = 0.3, padding = 0.07, minw = 1, colour = G.C.JOKER_GREY, shadow = true},
        nodes = {{
            n = G .UIT.C,
            config = {align = "cm", minh = 1, r = 0.2, padding = 0.1, minw = 1, colour = G.C.L_BLACK},
            nodes = {{
                n = G.UIT.O,
                config = {object = cardarea}
            }}
        }}
    }
end


---------------------------
--------------------------- The Creek score modifiers
---------------------------

local ref_uibox_blind = create_UIBox_blind_popup
function create_UIBox_blind_popup(...)
    local ret = ref_uibox_blind(...)

    local args = { ... }
    local blind = args[1]

    if blind.key == 'bl_fnwk_creek' then
        local dyn_nodes = {}
        for i=0, 6 do
            dyn_nodes[#dyn_nodes+1] = {string = (i*0.25 + 1.75)..localize('k_x_base'), colour = G.C.RED}
        end
        ret.nodes[2].nodes[1].nodes[2].nodes[2] = {
            n=G.UIT.O,
            config={
                object = DynaText({
                    string = dyn_nodes,
                    colours = {G.C.RED},
                    pop_in_rate = 9999999,
                    silent = true,
                    random_element = true,
                    random_no_repeat = true,
                    pop_delay = 0.3,
                    scale = 0.4,
                    min_cycle_time = 0,
                })
            }
        }
    end

    return ret
end




---------------------------
--------------------------- Fix Disturbia badge
---------------------------

local ref_card_popup = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(...)
    local args = { ... }
    local card = args[1]

    if card.config and card.config.center and card.config.center.key == 'c_fnwk_streetlight_disturbia' then
        card.ability_UIBox_table.card_type = 'Stand'
        card.ability_UIBox_table.badges.force_rarity = nil
        return ref_card_popup(card)
    end

    return ref_card_popup(...)
end





---------------------------
--------------------------- Add "submit button" for The Work Blind
---------------------------

local ref_use_and_sell = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(...)
    local ret = ref_use_and_sell(...)

    local args = {...}
    local card = args[1]
    if card.area and card.area == G.jokers and card.ability.set == 'Joker' and G.GAME.blind
    and G.GAME.blind.fnwk_works_submitted < G.GAME.blind.fnwk_required_works then
        local inner_nodes = ret.nodes[1].nodes[2].nodes
        inner_nodes[#inner_nodes+1] = {
            n = G.UIT.C,
            config = { align = 'cr' },
            nodes = {{
                n = G.UIT.C,
                config = { ref_table = card, align = "cr", maxw = 1.25, padding = 0.1, r = 0.08, minw = 1.25, minh = 1, hover = true, shadow = true, colour = G.C.FANWORKS, one_press = true, button = 'fnwk_submit_to_blind'},
                nodes={
                    {n=G.UIT.B, config = {w=0.1,h=0.6}},
                    {n=G.UIT.T, config = {text = localize('b_fnwk_submit'), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                }}
            }
        }
    end

    return ret
end





---------------------------
--------------------------- Multimedia deck preview fuckery
---------------------------

local ref_deck_preview = G.UIDEF.deck_preview
function G.UIDEF.deck_preview(args)
    local ret = ref_deck_preview(args)
    
    if G.GAME.modifiers.fnwk_obscure_suits then
        local suit_labels = ret.nodes[1].nodes[1].nodes[1].nodes
        for i, v in ipairs(suit_labels) do
            if i > 1 then
                local color = SMODS.Gradients['fnwk_dark_edition_'..math.random(1, 3)]
                local main_node = v.nodes[2].nodes[1]
                main_node.config.text = '?'
                main_node.config.colour = color

                local mod_node = v.nodes[2].nodes[2]
                if mod_node then
                    mod_node.config.text = ' (?) '
                    mod_node.config.colour = color
                end
            end
        end

        local deck_rows = ret.nodes[1].nodes[1].nodes[2].nodes
        for i, row in ipairs(deck_rows) do
            for _, col in ipairs(row.nodes) do
                if i ~= 1 then
                    local node = col.nodes[1]
                    node.config.text = '?'
                    node.config.colour = SMODS.Gradients['fnwk_dark_edition_'..math.random(1, 3)]
                    node.config.scale = 0.3
                end
            end
        end
    end

    return ret
end


local ref_view_deck = G.UIDEF.view_deck
function G.UIDEF.view_deck(...)
    if not G.GAME.modifiers.fnwk_obscure_suits then
        return ref_view_deck(...)
    end

    local ret = {FnwkRandomSuitOrderCall(ref_view_deck, ...)}

    return unpack(ret)
end

local ref_suits_page = G.FUNCS.your_suits_page
G.FUNCS.your_suits_page = function(args)
    if not G.GAME.modifiers.fnwk_obscure_suits then
        return ref_suits_page(args)
    end

    local ret = {FnwkRandomSuitOrderCall(ref_suits_page, args)}

    return unpack(ret)
end

SMODS.Atlas({ key = 'obscured_ui', path = "obscured_ui.png", px = 18, py = 18})

local ref_tally_sprite = tally_sprite
function tally_sprite(...)
    local args = {...}
    if not args[4] or not G.GAME.modifiers.fnwk_obscure_suits then
        return ref_tally_sprite(...)
    end

    args[2] = {{ string = '?', colour = G.C.DARK_EDITION }, { string = '?', colour = G.C.DARK_EDITION }}
    args[3] = { '?' }
    local ret = ref_tally_sprite(unpack(args))
    local icon_sprite = ret.nodes[1].nodes[1].config.object
    icon_sprite.atlas = G.ASSET_ATLAS['fnwk_obscured_ui']
    icon_sprite.sprite_pos = { x = 0, y = 0 }
    icon_sprite:reset()

    return ret
end