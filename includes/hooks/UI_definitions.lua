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
--------------------------- The Creek score modifiers
---------------------------

local ref_uibox_blind = create_UIBox_blind_popup
function create_UIBox_blind_popup(...)
    local ret = ref_uibox_blind(...)

    local args = { ... }
    local blind = args[1]
    local discovered = args[2]

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

    if discovered and blind.special_colour then
        local ability_text = ret.nodes[2].nodes[1].nodes[4]
        if ability_text then
            ability_text.config.colour = blind.special_colour
        end
    end

    return ret
end

local ref_blind_choice = create_UIBox_blind_choice
function create_UIBox_blind_choice(...)
    local ret = ref_blind_choice(...)

    local args = { ... }
    local type = args[1]
    if G.P_BLINDS[G.GAME.round_resets.blind_choices[type]].score_invisible or G.GAME.modifiers.fnwk_all_scores_hidden then
        local score_node = ret.nodes[1].nodes[3].nodes[1].nodes[2].nodes[2].nodes[3]
        score_node.config.object = DynaText({
            string = '?????',
            colours = {disabled and G.C.UI.TEXT_INACTIVE or G.C.DARK_EDITION},
            bump = true,
            pop_in_rate = 1.5*G.SPEEDFACTOR,
            silent = true,
            scale = 0.65,
        })
        score_node.n = G.UIT.O
    end

    return ret
end





---------------------------
--------------------------- Multi line attention text support
---------------------------

local ref_attention_text = attention_text
function attention_text(args)
    if not args or not args.text or (args.text and type(args.text) ~= 'table') then
        return ref_attention_text(args)
    end

    args.scale = args.scale or 1
    args.colour = SMODS.shallow_copy(args.colour or G.C.WHITE)
    args.hold = (args.hold or 0) + 0.1*(G.SPEEDFACTOR)
    args.pos = args.pos or {x = 0, y = 0}
    args.align = args.align or 'cm'
    args.emboss = args.emboss or nil
    args.fade = 1

    if args.cover then
        args.cover_colour = SMODS.shallow_copy(args.cover_colour or G.C.RED)
        args.cover_colour_l = SMODS.shallow_copy(lighten(args.cover_colour, 0.2))
        args.cover_colour_d = SMODS.shallow_copy(darken(args.cover_colour, 0.2))
    else
        args.cover_colour = copy_table(G.C.CLEAR)
    end

    args.uibox_config = {
        align = args.align or 'cm',
        offset = args.offset or {x=0,y=0}, 
        major = args.cover or args.major or nil,
    }

    local nodes = {}
    for _, line in ipairs(args.text) do
        nodes[#nodes+1] = {{
            n=G.UIT.C, 
            config={align = "m"},
            nodes={{
                n=G.UIT.O, 
                config={
                    object = DynaText({
                        string = line,
                        colours = {args.colour},
                        silent = not args.noisy,
                        pop_in = 0,
                        pop_in_rate = 6,
                        rotate = args.rotate or nil,
                        maxw = args.maxw,
                        float = true,
                        shadow = true,
                        scale = args.scale
                    })
                }
            }}
        }}
    end

    local final_text = {
        n=G.UIT.ROOT, 
        config = {
            align = args.cover_align or 'cm',
            minw = (args.cover and args.cover.T.w or 0.001) + (args.cover_padding or 0),
            minh = (args.cover and args.cover.T.h or 0.001) + (args.cover_padding or 0),
            padding = 0.03,
            r = 0.1,
            emboss = args.emboss,
            colour = args.cover_colour
        },
        nodes={}
    }
    
    for _, line in ipairs(nodes) do
        final_text.nodes[#final_text.nodes+1] = {n=G.UIT.R, config={align = "m"}, nodes=line}
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0,
        blockable = false,
        blocking = false,
        func = function()
            args.AT = UIBox{
                T = {args.pos.x,args.pos.y, 0, 0},
                definition = final_text, 
                config = args.uibox_config
            }
            args.AT.attention_text = true

            args.text = args.AT.UIRoot.children
            for _, v in ipairs(args.text) do
                v.children[1].children[1].config.object:pulse(0.5)
            end
            
            if args.cover then
            Particles(args.pos.x,args.pos.y, 0,0, {
                timer_type = 'TOTAL',
                timer = 0.01,
                pulse_max = 15,
                max = 0,
                scale = 0.3,
                vel_variation = 0.2,
                padding = 0.1,
                fill=true,
                lifespan = 0.5,
                speed = 2.5,
                attach = args.AT.UIRoot,
                colours = {args.cover_colour, args.cover_colour_l, args.cover_colour_d},
            })
            end
            if args.backdrop_colour then
            args.backdrop_colour = SMODS.shallow_copy(args.backdrop_colour)
            Particles(args.pos.x,args.pos.y,0,0,{
                timer_type = 'TOTAL',
                timer = 5,
                scale = 2.4*(0.75 + 0.25 * #args.text),
                lifespan = 5,
                speed = 0,
                attach = args.AT,
                colours = {args.backdrop_colour}
            })
            end
            return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = args.hold,
        blockable = false,
        blocking = false,
        func = function()
            if not args.start_time then
                args.start_time = G.TIMERS.TOTAL
                for _, v in ipairs(args.text) do
                    v.children[1].children[1].config.object:pop_out(3)
                end
            else
                --args.AT:align_to_attach()
                args.fade = math.max(0, 1 - 3*(G.TIMERS.TOTAL - args.start_time))
                if args.cover_colour then args.cover_colour[4] = math.min(args.cover_colour[4], 2*args.fade) end
                if args.cover_colour_l then args.cover_colour_l[4] = math.min(args.cover_colour_l[4], args.fade) end
                if args.cover_colour_d then args.cover_colour_d[4] = math.min(args.cover_colour_d[4], args.fade) end
                if args.backdrop_colour then args.backdrop_colour[4] = math.min(args.backdrop_colour[4], args.fade) end
                args.colour[4] = math.min(args.colour[4], args.fade)
                if args.fade <= 0 then
                    args.AT:remove()
                    return true
                end
            end
        end
    }))
end





---------------------------
--------------------------- Custom Challenge display behavior
---------------------------

function G.FUNCS.fnwk_run_challenge_functions(ch)
    if not ch.restrictions then return end

    if ch.restrictions.banned_cards then
        if type(ch.restrictions.banned_cards) == 'function' then
            ch.restrictions.banned_cards = ch.restrictions.banned_cards()
        end

        if ch.restrictions.banned_cards.allowed then
            local bans = {}
            local allow_map = {}
            local allow_list = {}
            for _, sets in pairs(ch.restrictions.banned_cards.allowed) do
                for _, info in ipairs(sets) do
                    allow_list[#allow_list+1] = { id = info.id, ids = info.ids }
                    allow_map[info.id] = true
                    for _, id in ipairs(info.ids or {}) do allow_map[id] = true end
                end
            end

            for k, center in pairs(G.P_CENTERS) do
                if not allow_map[k] and ch.restrictions.banned_cards.allowed[center.set] then
                    bans[#bans+1] = k
                end
            end

            ch.restrictions.banned_cards = {{id = 'j_joker', ids = bans}}
            ch.restrictions.allowed_cards = allow_list
        end
    end

    if ch.restrictions.banned_tags and type(ch.restrictions.banned_tags) == 'function' then
        ch.restrictions.banned_tags = ch.restrictions.banned_tags()
    end

    if ch.restrictions.banned_other then
        if type(ch.restrictions.banned_other) == 'function' then
            ch.restrictions.banned_other = ch.restrictions.banned_other()
        end

        if ch.restrictions.banned_other.allowed then
            local bans = {}
            local allow_map = {}
            local allow_list = {}
            for _, blind in pairs(ch.restrictions.banned_other.allowed) do
                allow_list[#allow_list+1] = { id = blind.id, type = 'blind' }
                allow_map[blind.id] = true
            end

            for k, _ in pairs(G.P_BLINDS) do
                if not allow_map[k] then
                    bans[#bans+1] = { id = k, type = 'blind' }
                end
            end

            ch.restrictions.banned_other = bans
            ch.restrictions.allowed_other = allow_list
        end
    end
end

local ref_challenge_desc = G.UIDEF.challenge_description_tab
function G.UIDEF.challenge_description_tab(args)
	if args and args._tab == 'Restrictions' then
		G.FUNCS.fnwk_run_challenge_functions(G.CHALLENGES[args._id])
	end

    local ret = ref_challenge_desc(args)

    local ch = G.CHALLENGES[args._id]
    if args._tab == 'Rules' and G.localization.descriptions.Challenge[ch.key] then
        ret.nodes[1].nodes[1].config.minw = 2.5
        local custom_rules = (ch.rules and ch.rules.custom and next(ch.rules.custom)) or false
        local rule_node = ret.nodes[1].nodes[1].nodes[2]
        rule_node.config.minw = custom_rules and 3.65 or 3.8
        rule_node.config.maxw = custom_rules and 3.65 or 3.8
        rule_node.config.minh = custom_rules and 4 or 4.1
        ret.nodes[1].nodes[1].nodes[2] = {
            n = G.UIT.R,
            config = {align = "cm", padding = custom_rules and 0.05 or 0, colour = G.C.WHITE, r = 0.1 },
            nodes = { rule_node }
        }

        ret.nodes[1].nodes[2].config.minw = 1.75
        local modifier_node = ret.nodes[1].nodes[2].nodes[2]
        modifier_node.config.minw = 2.3
        modifier_node.config.maxw = 2.3
        modifier_node.config.minh = 4.1
        ret.nodes[1].nodes[2].nodes[2] = {
            n = G.UIT.R,
            config = {align = "cm", colour = G.C.WHITE, r = 0.1 },
            nodes = { modifier_node }
        }

        local story_text = {{}}
        localize{type = 'descriptions', set = 'Challenge', key = ch.key, nodes = story_text[#story_text], text_colour = G.C.BLACK }
        story_text[#story_text] = desc_from_rows(story_text[#story_text], nil, 4.2)
        story_text[#story_text].config.colour = G.C.CLEAR
        if not next(story_text[#story_text].nodes) then
            story_text[#story_text].nodes[1] = {n = G.UIT.T, config = { align = "cm", text = ''}}
        end

        local story_node = {n=G.UIT.C, config={align = "cm", minw = 3, r = 0.1, colour = G.C.BLUE}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0.08, minh = 0.6}, nodes={
                {n=G.UIT.T, config={text = localize('k_challenge_story'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0.075, colour = G.C.WHITE, r = 0.1 }, nodes={
                (ch.fanwork and ch.fanwork ~= 'fanworks') and {
                    n = G.UIT.R,
                    config = {
                        align = "cm",
                        minw = 2,
                        padding = 0.05,
                        shadow = true,
                    },
                    nodes = {{
                    n = G.UIT.C,
                        config = {
                            align = "cm",
                            padding = 0.05,
                            maxw = 3,
                            minh = 0.5,
                            colour = G.fnwk_badge_colours['co_'..ch.fanwork] and HEX(G.fnwk_badge_colours['co_'..ch.fanwork]) or G.C.STAND,
                            r = 0.1,
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = {
                                text = ' '..localize('ba_'..ch.fanwork)..' ',
                                scale = 1,
                                colour = G.C.WHITE,
                                minh = 0.4,
                                shadow = true,
                            }
                        }}
                    }}
                } or nil,
                {n = G.UIT.R, config = {align = "cm", minh = (ch.fanwork and ch.fanwork ~= 'fanworks') and 3.275 or 3.95, minw = 4.4, maxw = 4.4, padding = 0.05, r = 0.1, colour = G.C.WHITE}, nodes = story_text}
            }},
        }}

        table.insert(ret.nodes[1].nodes, 1, story_node)
    end

    if args._tab == 'Restrictions' and ch.restrictions then
        if ch.restrictions.allowed_cards then
            local banned_nodes = ret.nodes[1].nodes[1].nodes[2].nodes

            -- make sure to remove them to make sure
            for _, v in ipairs(banned_nodes) do
                v.nodes[1].config.object:remove()
            end
            table.fnwk_clear(banned_nodes)

            table.insert(banned_nodes, {
                n=G.UIT.R, config={align = "tm", minh = 0.3}, nodes= localize{type = 'text', key = 'fnwk_banned_except', vars = {}}
            })
            table.insert(banned_nodes, {n=G.UIT.R, config={align = "cm", minh = 0.1}})

            local row_cards = {}
            local n_rows = math.max(1, math.floor(#ch.restrictions.allowed_cards/10) + 2 - math.floor(math.log(6, #ch.restrictions.allowed_cards)))
            local max_width = 1
            for k, v in ipairs(ch.restrictions.allowed_cards) do
                local _row = math.floor((k-1)*n_rows/(#ch.restrictions.allowed_cards)+1)
                row_cards[_row] = row_cards[_row] or {}
                row_cards[_row][#row_cards[_row]+1] = v
                if #row_cards[_row] > max_width then max_width = #row_cards[_row] end
            end

            local card_size = math.max(0.2, 0.65 - 0.01*(max_width*n_rows))
            for _, row_card in ipairs(row_cards) do
                local allow_area = CardArea(
                    0,0,
                    6,
                    3/n_rows,
                    {
                        card_limit = nil,
                        type = 'title_2',
                        view_deck = true,
                        highlight_limit = 0,
                        card_w = G.CARD_W*card_size
                    }
                )

                for _, v in ipairs(row_card) do
                    local card = Card(0, 0, G.CARD_W*card_size, G.CARD_H*card_size, nil, G.P_CENTERS[v.id],
                        {bypass_discovery_center = true, bypass_discovery_ui = true}
                    )
                    allow_area:emplace(card)
                end

                
                table.insert(banned_nodes,
                    {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                        {n=G.UIT.O, config={object = allow_area}}
                    }}
                )

            end
        end

        if ch.restrictions.allowed_other then
            local banned_nodes = ret.nodes[1].nodes[3].nodes[2].nodes
            for _, v in ipairs(banned_nodes) do
                v.nodes[1].config.object:remove()
            end
            table.fnwk_clear(banned_nodes)

            table.insert(banned_nodes, {n=G.UIT.R, config={align = "tm", minh = 0.2, maxw = 2}, nodes= localize{type = 'text', key = 'fnwk_blinds_except', vars = {}}})
            table.insert(banned_nodes, {n=G.UIT.R, config={align = "cm", minh = 0.1, maxw = 2}})

            local allowed_blinds = {}
            for _, v in pairs(ch.restrictions.allowed_other) do
                sendDebugMessage('allowing blind: '..v.id)
                allowed_blinds[#allowed_blinds+1] = G.P_BLINDS[v.id]
            end
        
            table.sort(allowed_blinds, function (a, b) return a.order < b.order end)
            for _, v in ipairs(allowed_blinds) do
                local temp_blind = AnimatedSprite(0,0,1,1, G.ANIMATION_ATLAS[v.atlas or ''] or G.ANIMATION_ATLAS['blind_chips'], v.pos)
                temp_blind:define_draw_steps({{shader = 'dissolve', shadow_height = 0.05},{shader = 'dissolve'}})
                temp_blind.float = true
                temp_blind.states.hover.can = true
                temp_blind.states.drag.can = false
                temp_blind.states.collide.can = true
                temp_blind.config = {blind = v, force_focus = true}
                temp_blind.hover = function()
                    if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
                        if not temp_blind.hovering and temp_blind.states.visible then
                        temp_blind.hovering = true
                        temp_blind.hover_tilt = 3
                        temp_blind:juice_up(0.05, 0.02)
                        play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
                        temp_blind.config.h_popup = create_UIBox_blind_popup(v, true)
                        temp_blind.config.h_popup_config ={align = 'cl', offset = {x=-0.1,y=0},parent = temp_blind}
                        Node.hover(temp_blind)
                        end
                    end
                end

                temp_blind.stop_hover = function()
                    temp_blind.hovering = false
                    Node.stop_hover(temp_blind)
                    temp_blind.hover_tilt = 0
                end

                table.insert(banned_nodes,
                {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                    {n=G.UIT.O, config={object = temp_blind}}
                }})
            end
        end
    end

    return ret
end

local ref_ui_button = UIBox_button
function UIBox_button(args)
    local ret = ref_ui_button(args)
    if not args.count and args.button == 'change_challenge_description' and G.CHALLENGES[args.id].mod then
        local ch = G.CHALLENGES[args.id]
        local mod = ch.mod or {}

        -- copy new animated modicon style
        local atlas_key = mod.prefix and mod.prefix .. '_modicon' or 'modicon'
        local modicon
        if G.ANIMATION_ATLAS[atlas_key] then
            modicon = AnimatedSprite(0, 0, 0.5, 0.5, G.ANIMATION_ATLAS[atlas_key] or G.ASSET_ATLAS[atlas_key] or G.ASSET_ATLAS['tags'], tag_pos)
        else
            modicon = Sprite(0, 0, 0.5, 0.5, G.ASSET_ATLAS[atlas_key] or G.ASSET_ATLAS['tags'], tag_pos)
        end

        local text_colour = ch.fanwork and G.fnwk_badge_colours['te_'..ch.fanwork] and HEX(G.fnwk_badge_colours['te_'..ch.fanwork]) or args.text_colour or G.C.WHITE
        local text_nodes = ret.nodes[1].nodes
        for _, v in ipairs(text_nodes) do
            v.config.minw = math.max(0, v.config.minw - 1.2)
            v.config.maxw = math.max(v.config.minw, 2)
            v.nodes[1].config.colour = text_colour
        end

        local badge_colour = ch.fanwork and ch.fanwork ~= 'fanworks' and (G.fnwk_badge_colours['co_'..ch.fanwork] and HEX(G.fnwk_badge_colours['co_'..ch.fanwork])) or nil
        local new_nodes = {
            {n= G.UIT.C, config={ minw = 0.8, align = 'cm', padding = args.padding or 0 }, nodes = {
                { n=G.UIT.O, config = {align = 'rm', can_collide = true, object = modicon, tooltip = {text = {mod.display_name}}}}
            }},
            {n= G.UIT.C, config={ minw = 0.8, colour = badge_colour, r = 0.1, minh = args.minh, align = 'cm' }, nodes = {
                badge_colour and {n = G.UIT.C, config={minw = 0.2, align = 'cm'}} or nil,
                {n = G.UIT.C, config={align = 'cm'}, nodes = text_nodes},
                {n = G.UIT.C, config={minw = badge_colour and 0.2 or 0.4, align = 'cm'}}
            }},
        }

        ret.config.padding = 0
        ret.nodes[1].nodes = new_nodes
    end

    return ret
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
    if not suit or not G.GAME.modifiers.fnwk_obscure_suits then
        return ref_tally_sprite(...)
    end

    value = {{ string = '?', colour = G.C.DARK_EDITION }, { string = '?', colour = G.C.DARK_EDITION }}
    local args = { ... }
    args[3] = { '?' }
    local ret = ref_tally_sprite(unpack(args))
    local icon_sprite = ret.nodes[1].nodes[1].config.object
    icon_sprite.atlas = G.ASSET_ATLAS['fnwk_obscured_ui']
    icon_sprite.sprite_pos = { x = 0, y = 0 }
    icon_sprite:reset()

    return ret
end



---------------------------
--------------------------- Multimedia deck preview fuckery
---------------------------

local ref_run_setup = G.UIDEF.run_setup_option
function G.UIDEF.run_setup_option(...)
    local ret = ref_run_setup(...)

    if G.GAME.viewed_back and G.GAME.viewed_back.effect.center.artist then
        local args = {...}

        local credit = {
            n = G.UIT.R,
            config = {align = "cm"},
            nodes = {{
                n = G.UIT.O,
                config = {
                    id = G.GAME.viewed_back.name,
                    func = 'RUN_SETUP_fnwk_check_artist',
                    object = UIBox{definition = G.UIDEF.fnwk_deck_credit(G.GAME.viewed_back), config = {offset = {x=0,y=0}}}
                }
            }}
        }

        if args[1] == 'Continue' then
            local back_desc_nodes = ret.nodes[1].nodes[1].nodes[2].nodes
            back_desc_nodes[1].config.minh = 0.45
            back_desc_nodes[2].config.minh = 0.9
            table.insert(back_desc_nodes, 3, credit)
        elseif args[1] == 'New Run' then
            local back_desc_nodes = ret.nodes[1].nodes[1].nodes[1].nodes[2].nodes[1].nodes[1].nodes[1].nodes[2].nodes
            back_desc_nodes[1].config.minh = 0.45
            back_desc_nodes[2].config.minh = 0.9
            table.insert(back_desc_nodes, 3, credit)
        end
    end

    return ret
end

function G.UIDEF.fnwk_deck_credit(back)
    -- set the artists
    local vars = {}
    if type(G.GAME.viewed_back.effect.center.artist) == 'table' then
        for i, v in ipairs(G.GAME.viewed_back.effect.center.artist) do
            vars[i] = G.fnwk_credits[v]
        end
    else
        vars[1] = G.fnwk_credits[G.GAME.viewed_back.effect.center.artist]
    end

    local name_nodes = localize{type = 'name', key = "fnwk_artist_"..#vars, set = 'Other', nodes = name_nodes, scale = 0.6}
    local desc_nodes = {}
    localize{type = 'descriptions', key = "fnwk_artist_"..#vars, set = "Other", vars = vars, nodes = desc_nodes, scale = 0.7}
    local credit = {
        n = G.UIT.ROOT,
        config = {id = back.name, align = "cm", minw = 4, r = 0.1, colour = G.C.CLEAR },
        nodes = {
            name_from_rows(name_nodes, nil),
            desc_from_rows(desc_nodes, nil),
        }
    }

    -- customized measurements
    credit.nodes[1].config.padding = 0.035
    credit.nodes[2].config.padding = 0.03
    credit.nodes[2].config.minh = 0.15
    credit.nodes[2].config.minw = 4
    credit.nodes[2].config.r = 0.05

    return credit
end