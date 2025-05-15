local ref_reroll_shop = G.FUNCS.reroll_shop
G.FUNCS.reroll_shop = function(e)
    local paperbacks = SMODS.find_card('c_fnwk_streetlight_paperback')
    local rewrites = SMODS.find_card('c_fnwk_streetlight_paperback_rewrite')
    if G.GAME.current_round.fnwk_paperback_rerolls > 0 or (next(rewrites) and not rewrites[1].ability.fnwk_rewrite_destroyed) then
        local juice_cards = next(rewrites) and rewrites or {paperbacks[G.GAME.current_round.fnwk_paperback_rerolls]}
        for _, v in ipairs(juice_cards) do
            G.FUNCS.csau_flare_stand_aura(v, 0.5)
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    v:juice_up()
                    return true
                end
            }))
            attention_text({
                text = localize('k_brienne'),
                scale = 1,
                hold = 0.35,
                backdrop_colour = G.C.STAND,
                align = 'bm',
                major = v,
                offset = {x = 0, y = 0.05*v.T.h}
            })
        end
        
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()

                for i = #G.shop_booster.cards, 1, -1 do
                    local c = G.shop_booster:remove_card(G.shop_booster.cards[i])
                    c:remove()
                    c = nil
                end

                for i = #G.shop_vouchers.cards, 1, -1 do
                    local c = G.shop_vouchers:remove_card(G.shop_vouchers.cards[i])
                    G.GAME.current_round.voucher.spawn[c.config.center.key] = false
                    c:remove()
                    c = nil
                end

                G.GAME.current_round.fnwk_paperback_rerolls = G.GAME.current_round.fnwk_paperback_rerolls - 1
                if G.GAME.current_round.fnwk_paperback_rerolls <= 0 then
                    G.GAME.current_round.fnwk_paperback_rerolls = 0
                end
                
                G.GAME.current_round.used_packs = {}
                for i=1, G.GAME.starting_params.boosters_in_shop + (G.GAME.modifiers.extra_boosters or 0) do
                    G.GAME.current_round.used_packs[i] = get_pack('shop_pack').key

                    local new_booster = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                    G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.used_packs[i]], {bypass_discovery_center = true, bypass_discovery_ui = true})
                    create_shop_card_ui(new_booster, 'Booster', G.shop_booster)
                    new_booster.ability.booster_pos = i
                    new_booster:start_materialize()
                    G.shop_booster:emplace(new_booster)
                end


                G.GAME.current_round.voucher = SMODS.get_next_vouchers()

                for _, key in ipairs(G.GAME.current_round.voucher or {}) do
                    if G.P_CENTERS[key] and G.GAME.current_round.voucher.spawn[key] then
                        SMODS.add_voucher_to_shop(key)
                    end
                end

                return true
            end
        }))
    end

    return ref_reroll_shop(e)
end