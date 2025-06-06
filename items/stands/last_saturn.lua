local consumInfo = {
    key = 'c_fnwk_last_saturn',
    name = 'Saturn Barz',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC', },
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'last',
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.gote }}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
        local possible_hands = {}
        for k, _ in pairs(G.GAME.hands) do
            if not G.GAME.fnwk_last_upgraded_hand[k] then
                possible_hands[#possible_hands+1] = k
            end
        end

        if not next(possible_hands) then
            for k, _ in pairs(G.GAME.hands) do
                possible_hands[#possible_hands+1] = k
            end
        end

        local rand_hand = pseudorandom_element(possible_hands, pseudoseed('fnwk_saturn'))
        local juice_card = context.blueprint_card or card
        return {
            func = function() 
                G.FUNCS.flare_stand_aura(juice_card, 2)
            end,
            extra = {
                level_up = true,
                level_up_hand = rand_hand
            }
		}
    end
end

return consumInfo