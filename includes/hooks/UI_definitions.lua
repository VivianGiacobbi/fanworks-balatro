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
function G.UIDEF.card_h_popup(card)
    if card.config and card.config.center and card.config.center.key == 'c_fnwk_streetlight_disturbia' then
        card.ability_UIBox_table.card_type = 'Stand'
        card.ability_UIBox_table.badges.force_rarity = nil
        local ret = ref_card_popup(card)
        return ret
    end
    return ref_card_popup(card)
end





---------------------------
--------------------------- The Creek score modifiers
---------------------------

local ref_uibox_blind = create_UIBox_blind_popup
function create_UIBox_blind_popup(blind, discovered, vars)
    local ret = ref_uibox_blind(blind, discovered, vars)
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
function create_UIBox_blind_choice(type, run_info)
    local ret = ref_blind_choice(type, run_info)

    if type == 'Boss' then
        local blind = G.P_BLINDS[G.GAME.round_resets.blind_choices['Boss']]
        if blind.key ~= 'bl_fnwk_creek' then return ret end
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
--------------------------- Automatic challenge ban functions
---------------------------

function G.FUNCS.fnwk_run_challenge_functions(challenge)
    if not challenge.restrictions then return end

    if challenge.restrictions.banned_cards and type(challenge.restrictions.banned_cards) == 'function' then
        challenge.restrictions.banned_cards = challenge.restrictions.banned_cards()
    end

    if challenge.restrictions.banned_tags and type(challenge.restrictions.banned_tags) == 'function' then
        challenge.restrictions.banned_tags = challenge.restrictions.banned_tags()
    end

    if challenge.restrictions.banned_other and type(challenge.restrictions.banned_other) == 'function' then
        challenge.restrictions.banned_other = challenge.restrictions.banned_other()
    end
end

local ref_challenge_desc = G.UIDEF.challenge_description_tab
function G.UIDEF.challenge_description_tab(args)
	args = args or {}

	if args._tab == 'Restrictions' then
		local challenge = G.CHALLENGES[args._id]
		G.FUNCS.fnwk_run_challenge_functions(challenge)
	end
    
	return ref_challenge_desc(args)
end





---------------------------
--------------------------- Add "submit button" for The Work Blind
---------------------------

local ref_use_and_sell = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local ret = ref_use_and_sell(card)

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
                local node = col.nodes[1]
                if i == 1 then node = node.nodes[2].nodes[1] end
                node.config.text = '?'
                node.config.colour = SMODS.Gradients['fnwk_dark_edition_'..math.random(1, 3)]
                node.config.scale = 0.3
            end
        end
    end

    return ret
end


local ref_view_deck = G.UIDEF.view_deck
function G.UIDEF.view_deck(unplayed_only)
    if not G.GAME.modifiers.fnwk_obscure_suits then
        return ref_view_deck(unplayed_only)
    end

    local ret = {FnwkRandomSuitOrderCall(ref_view_deck, unplayed_only)}

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
function tally_sprite(pos, value, tooltip, suit)
    if not suit or not G.GAME.modifiers.fnwk_obscure_suits then
        return ref_tally_sprite(pos, value, tooltip, suit)
    end

    value = {{ string = '?', colour = G.C.DARK_EDITION }, { string = '?', colour = G.C.DARK_EDITION }}
    tooltip = { '?' }
    local ret = ref_tally_sprite(pos, value, tooltip, suit)
    local icon_sprite = ret.nodes[1].nodes[1].config.object
    icon_sprite.atlas = G.ASSET_ATLAS['fnwk_obscured_ui']
    icon_sprite.sprite_pos = { x = 0, y = 0 }
    icon_sprite:reset()

    return ret
end