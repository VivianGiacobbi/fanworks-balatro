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

function G.UIDEF.artist_card_ui(cardarea)
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