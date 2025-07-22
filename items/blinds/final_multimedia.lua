local blindInfo = {
    name = "Mauve Multimedia",
    boss_colour = HEX('DBA5FF'),
    pos = {x = 0, y = 0},
    dollars = 8,
    mult = 2,
    vars = {},
    boss = {min = 1, max = 10, showdown = true},
}

local function set_fronts()
    for _, v in pairs(G.I.CARD) do
        if v.config and v.config.card and v.children.front and v.config.center.key ~= 'm_stone' then
            v:set_sprites(nil, v.config.card)
        end
    end
end

function blindInfo.set_blind(self)
    local color_options = {}
    for _, v in ipairs(G.fnwk_obscure_suits) do
        color_options[v.key] = {}
        for i=1, #G.fnwk_obscure_suit_colors do
            color_options[v.key][i] = i
        end
    end

    local obscure_suit_info = {}
    local suit_options = {}
    for i=1, #SMODS.Suit.obj_buffer do
        if not next(suit_options) then
            for idx, v in ipairs(G.fnwk_obscure_suits) do
                suit_options[#suit_options+1] = idx
            end
        end
        local suit_index = table.remove(suit_options, #suit_options == 1 and 1 or pseudorandom('fnwk_multimedia_suit', 1, #suit_options))
        local suit = G.fnwk_obscure_suits[suit_index]
        local color_index = table.remove(color_options[suit.key], pseudorandom('fnwk_multimedia_color', 1, #color_options[suit.key]))
        obscure_suit_info[i] = copy_table(suit)
        obscure_suit_info[i].color = mix_colours(G.fnwk_obscure_suit_colors[color_index], G.C.BLACK, 0.8)
    end

    -- simple table shuffle
    for i = #obscure_suit_info, 2, -1 do
		local j = math.random(i)
		obscure_suit_info[i], obscure_suit_info[j] = obscure_suit_info[j], obscure_suit_info[i]
	end

    local chosen_suits = {}
    for i, k in ipairs(SMODS.Suit.obj_buffer) do
        local suit = obscure_suit_info[i]
        chosen_suits[k] = { key = suit.key, row_pos = suit.row_pos, r_replace = suit.color, g_replace = G.C.BLACK, b_replace = G.C.WHITE }
    end

    G.GAME.modifiers.fnwk_obscure_suits = chosen_suits
    set_fronts()
end

function blindInfo.disable(self)
    G.GAME.modifiers.fnwk_obscure_suits = nil
    set_fronts()
end

function blindInfo.defeat(self)
    G.GAME.modifiers.fnwk_obscure_suits = nil
    set_fronts()
end

function blindInfo.fnwk_blind_load(self, blindTable)
    if G.GAME.modifiers.fnwk_obscure_suits then
         set_fronts()
    end
end

return blindInfo