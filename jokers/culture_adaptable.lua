local jokerInfo = {
    key = 'j_fnwk_culture_adaptable',
	name = 'Adaptable Jokestar',
	config = {
        extra = 2
    },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'culture',
}

local function count_enhanced()
    local tally = 0
    if G.playing_cards then 
        for k, v in pairs(G.playing_cards) do
            if v.ability.set == 'Enhanced' then 
                tally = tally + 1
            end
        end
    end
    return tally
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_shaft", set = "Other"}
    return { vars = {card.ability.extra, count_enhanced() * card.ability.extra}}
end

function jokerInfo.calculate(self, card, context)
    if not context.joker_main or not context.cardarea == G.jokers or card.debuff then
        return
    end

    local enhanced = count_enhanced()
    if enhanced > 0 then
        return {
            message = localize { type = 'variable', key = 'a_mult', vars = {enhanced * card.ability.extra} },
            mult_mod = enhanced * card.ability.extra,
            card = context.blueprint_card or card
        }
    end
end

return jokerInfo