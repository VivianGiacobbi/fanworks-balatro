local update_shop_ref = Game.update_shop
Game.update_shop = function(dt)
    update_shop_ref(dt)
    --[[
    sendDebugMessage('packs: '..(G.GAME.current_round.used_packs and #G.GAME.current_round.used_packs or 0))
    for i=1, #G.GAME.current_round.used_packs do
        sendDebugMessage(G.GAME.current_round.used_packs[i])
    end
    --]]
end