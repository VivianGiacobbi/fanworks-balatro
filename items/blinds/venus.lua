local blindInfo = {
    name = "The Venus",
    boss_colour = HEX('E86EB5'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 3, max = 10},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'mdv',
		},
        custom_color = 'mdv',
    },
    artist = 'winter',
}

function blindInfo.loc_vars(self)
    return {vars = {SMODS.get_probability_vars(card, 1, 2, 'fnwk_bl_venus')} }
end

function blindInfo.collection_loc_vars(self)
    return { vars = {SMODS.get_probability_vars(card, 1, 2, 'fnwk_bl_venus')}}
end

function blindInfo.set_blind(self)
    for _, v in ipairs(G.playing_cards) do
        v.fnwk_venus_debuff = SMODS.pseudorandom_probability(G.GAME.blind, 'fnwk_bl_venus', 1, 2, 'fnwk_bl_venus') or nil
        v.fnwk_venus_checked = true
    end
end

function blindInfo.recalc_debuff(self, card, from_blind)
    if card.area == G.jokers then
        return false
    end

    if card.fnwk_venus_debuff then
        return true
    elseif not card.fnwk_venus_checked then
        card.fnwk_venus_checked = true
        card.fnwk_venus_debuff = SMODS.pseudorandom_probability(G.GAME.blind, 'fnwk_bl_venus', 1, 2, 'fnwk_bl_venus') or nil
        
        if card.fnwk_venus_debuff then
            return true
        end
    end

    return false
end

function blindInfo.defeat(self)
    for _, v in ipairs(G.playing_cards) do
        v.fnwk_venus_debuff = nil
        v.fnwk_venus_checked = nil
    end
end

return blindInfo