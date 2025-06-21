local jokerInfo = {
    name = 'Creaking Bjokestar',
    config = {
        extra = {
            hand = 'jojobal_FlushFibonacci',
            last_mult = 0,
            mult = 1,
        },
    },
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    fanwork = 'plancks',
    alt_art = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.coop }}
    return { vars = {card.ability.extra.mult}}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    G.GAME.hands['jojobal_Fibonacci'].visible = true
    G.GAME.hands['jojobal_FlushFibonacci'].visible = true
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if fnwk_has_valid_fib_card() then
        return
    end
    G.GAME.hands['jojobal_Fibonacci'].visible = false
    G.GAME.hands['jojobal_FlushFibonacci'].visible = false
end

function jokerInfo.calculate(self, card, context)
    if not context.blueprint and not context.retrigger_joker and context.before and context.scoring_name == card.ability.extra.hand then
        local old_mult = card.ability.extra.mult
        card.ability.extra.mult = card.ability.extra.last_mult + card.ability.extra.mult
        card.ability.extra.last_mult  = old_mult

        return {
            message = localize('k_upgrade_ex'),
            colour = G.C.MULT
        }
    end

    if context.joker_main then
        return {
            mult = card.ability.extra.mult
        }
    end
end

return jokerInfo