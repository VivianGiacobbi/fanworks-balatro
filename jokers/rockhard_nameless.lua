local jokerInfo = {
    key = 'j_fnwk_rockhard_nameless',
	name = 'Endless Nameless',
	config = {
        extra = {
            mult = 0,
            mult_mod = 1
        },
        water_time = 0
    },
	rarity = 1,
	cost = 6,
    hasSoul = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'rockhard',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_wild
    info_queue[#info_queue+1] = {key = "artist_cringe", set = "Other"}
    return { vars = {card.ability.extra.mult_mod, card.ability.extra.mult }}
end

function jokerInfo.update(self, card, dt)
    card.ability.water_time = card.ability.water_time + G.real_dt
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.joker_main and not card.debuff and card.ability.extra.mult > 0 then
        return {
            message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
            mult_mod = card.ability.extra.mult
        }
    end
    
    if (context.cardarea == G.jokers and context.hand_upgraded) and not card.debuff and not context.blueprint then        
        local count = 0
        for k, v in pairs(context.upgraded) do
            count = count + 1
        end
        local levels = card.ability.extra.mult_mod * context.amount * count
        card.ability.extra.mult = card.ability.extra.mult + levels 
        return {
            card = card,
            message = localize{type='variable',key='a_mult',vars={levels}}
        }
    end
end

return jokerInfo