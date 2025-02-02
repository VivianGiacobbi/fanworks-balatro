Game.update_shop = function(self, dt)
    if not G.STATE_COMPLETE then
        stop_use()
        ease_background_colour_blind(G.STATES.SHOP)
        local shop_exists = not not G.shop
        G.shop = G.shop or UIBox{
            definition = G.UIDEF.shop(),
            config = {align='tmi', offset = {x=0,y=G.ROOM.T.y+11},major = G.hand, bond = 'Weak'}
        }
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.shop.alignment.offset.y = -5.3
                    G.shop.alignment.offset.x = 0
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        blockable = false,
                        func = function()
                            if math.abs(G.shop.T.y - G.shop.VT.y) < 3 then
                                G.ROOM.jiggle = G.ROOM.jiggle + 3
                                play_sound('cardFan2')
                                for i = 1, #G.GAME.tags do
                                    G.GAME.tags[i]:apply_to_run({type = 'shop_start'})
                                end
                                local nosave_shop = nil
                                if not shop_exists then
                                
                                    if G.load_shop_jokers then 
                                        nosave_shop = true
                                        G.shop_jokers:load(G.load_shop_jokers)
                                        for k, v in ipairs(G.shop_jokers.cards) do
                                            create_shop_card_ui(v)
                                            if v.ability.consumeable then v:start_materialize() end
                                            for _kk, vvv in ipairs(G.GAME.tags) do
                                                if vvv:apply_to_run({type = 'store_joker_modify', card = v}) then break end
                                            end
                                        end
                                        G.load_shop_jokers = nil
                                    else
                                        for i = 1, G.GAME.shop.joker_max - #G.shop_jokers.cards do
                                            G.shop_jokers:emplace(create_card_for_shop(G.shop_jokers))
                                        end
                                    end
                                    
                                    if G.load_shop_vouchers then 
                                        nosave_shop = true
                                        G.shop_vouchers:load(G.load_shop_vouchers)
                                        for k, v in ipairs(G.shop_vouchers.cards) do
                                            create_shop_card_ui(v)
                                            v:start_materialize()
                                        end
                                        G.load_shop_vouchers = nil
                                    else
                                        if G.GAME.current_round.voucher and G.P_CENTERS[G.GAME.current_round.voucher] then
                                            local card = Card(G.shop_vouchers.T.x + G.shop_vouchers.T.w/2,
                                            G.shop_vouchers.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.voucher],{bypass_discovery_center = true, bypass_discovery_ui = true})
                                            card.shop_voucher = true
                                            create_shop_card_ui(card, 'Voucher', G.shop_vouchers)
                                            card:start_materialize()
                                            G.shop_vouchers:emplace(card)
                                        end
                                    end
                                    

                                    if G.load_shop_booster then 
                                        nosave_shop = true
                                        G.shop_booster:load(G.load_shop_booster)
                                        for k, v in ipairs(G.shop_booster.cards) do
                                            create_shop_card_ui(v)
                                            v:start_materialize()
                                        end
                                        G.load_shop_booster = nil
                                    else
                                        for i = 1, 2 do
                                            G.GAME.current_round.used_packs = G.GAME.current_round.used_packs or {}
                                            if not G.GAME.current_round.used_packs[i] then
                                                G.GAME.current_round.used_packs[i] = get_pack('shop_pack').key
                                            end

                                            if G.GAME.current_round.used_packs[i] ~= 'USED' then 
                                                local card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                                                G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.used_packs[i]], {bypass_discovery_center = true, bypass_discovery_ui = true})
                                                create_shop_card_ui(card, 'Booster', G.shop_booster)
                                                card.ability.booster_pos = i
                                                card:start_materialize()
                                                G.shop_booster:emplace(card)
                                            end
                                        end

                                        for i = 1, #G.GAME.tags do
                                            G.GAME.tags[i]:apply_to_run({type = 'voucher_add'})
                                        end
                                        for i = 1, #G.GAME.tags do
                                            G.GAME.tags[i]:apply_to_run({type = 'shop_final_pass'})
                                        end
                                        for i = 1, #G.jokers.cards do
                                            eval_card(G.jokers.cards[i], {cardarea = G.jokers, start_shop = true})
                                        end
                                    end
                                end

                                G.CONTROLLER:snap_to({node = G.shop:get_UIE_by_ID('next_round_button')})
                                if not nosave_shop then G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end})) end
                                return true
                            end
                        end}))
                    return true
                end
            }))
          G.STATE_COMPLETE = true
    end  
    if self.buttons then self.buttons:remove(); self.buttons = nil end          
end