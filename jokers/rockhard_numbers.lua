local jokerInfo = {
    key = 'j_fnwk_rockhard_numbers',
	name = 'High Numbers',
	config = {
        extra = {
            x_mult_mod = 0.25
        },
    },
	rarity = 3,
	cost = 9,
    hasSoul = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	fanwork = 'rockhard',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_cringe", set = "Other"}
    if not G.GAME.run_collectables then
        return { vars = { card.ability.extra.x_mult_mod, 1 } }
    end
    local cryptids = G.GAME.run_collectables['c_cryptid'] or 0
    local deaths = G.GAME.run_collectables['c_death'] or 0
    local hung_men = G.GAME.run_collectables['c_hanged_man'] or 0
    return { 
        vars = { 
            card.ability.extra.x_mult_mod, 
            1 + card.ability.extra.x_mult_mod * (cryptids + deaths + hung_men)
        }
    }
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.using_consumeable and not context.blueprint then
        if context.consumeable.ability.name == 'Cryptid' 
        or context.consumeable.ability.name == 'Death'
        or context.consumeable.ability.name == 'Hanged Man' then
            local cryptids = G.GAME.run_collectables['c_cryptid'] or 0
            local deaths = G.GAME.run_collectables['c_death'] or 0
            local hung_men = G.GAME.run_collectables['c_hanged_man'] or 0
            local total = cryptids + deaths + hung_men
            card_eval_status_text(
                card,
                'extra',
                nil,
                nil,
                nil,
                {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {1 + card.ability.extra.x_mult_mod * total}},
                    colour = G.C.MULT
                }
            )
        end
    end

    if context.cardarea == G.jokers and context.joker_main then
        local cryptids = G.GAME.run_collectables['c_cryptid'] or 0
        local deaths = G.GAME.run_collectables['c_death'] or 0
        local hung_men = G.GAME.run_collectables['c_hanged_man'] or 0
        local total = 1 + card.ability.extra.x_mult_mod * (cryptids + deaths + hung_men)
        if total > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={total}},
                card = context.blueprint_card or card,
                Xmult_mod = total,
            }
        end
    end
end

return jokerInfo