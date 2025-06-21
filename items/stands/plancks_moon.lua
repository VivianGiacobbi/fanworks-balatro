local consumInfo = {
    name = 'Moon River',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'F61F59DC', 'FFF7F9DC' },
        extra = {
            x_mult = 1,
            x_mult_mod = 0.3,
            upgrade_count = 0,
            msg_row_max = 5,
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'plancks',
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.coop }}
    return { vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_mod} }
end

function consumInfo.add_to_deck(self, card, from_debuff)
    G.GAME.hands['jojobal_Fibonacci'].visible = true
    G.GAME.hands['jojobal_FlushFibonacci'].visible = true
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    if fnwk_has_valid_fib_card() then
        return
    end
    G.GAME.hands['jojobal_Fibonacci'].visible = false
    G.GAME.hands['jojobal_FlushFibonacci'].visible = false
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and not context.blueprint and not context.retrigger_joker then
        if not next(context.poker_hands['jojobal_Fibonacci']) then
            return
        end

        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
        card.ability.extra.upgrade_count = card.ability.extra.upgrade_count + 1

        local row_count = card.ability.extra.upgrade_count/card.ability.extra.msg_row_max
        local str = {}
        local num_reps = 0
        for i=1, math.ceil(row_count) do
            str[i] = ''
            for j=1, card.ability.extra.msg_row_max do
                str[i] = str[i]..'OLI'
                num_reps = num_reps + 1

                if j ~= card.ability.extra.msg_row_max and num_reps < card.ability.extra.upgrade_count then
                    str[i] = str[i]..' '
                end

                if num_reps >= card.ability.extra.upgrade_count then
                    break
                end
            end
        end

        if #str <= 1 then
            str = str[1]
        end

        local flare_card = context.blueprint_card or card
        return {
            func = function()
                G.FUNCS.flare_stand_aura(flare_card, 0.5)
            end,
            extra = {
                message = str,
                colour = G.C.MULT,
                card = flare_card
            }
        }
    end

	if context.joker_main and card.ability.extra.x_mult > 1 then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                G.FUNCS.flare_stand_aura(flare_card, 0.5)
            end,
            extra = {
                x_mult = card.ability.extra.x_mult,
                card = flare_card
            }
        }
	end
end

return consumInfo