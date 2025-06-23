local ref_game_start = Game.start_run
function Game:start_run(args)
    local ret = ref_game_start(self, args)

    local obj = G.GAME.blind.config.blind
    if G.GAME.blind.in_blind and obj.fnwk_post_blind_load and type(obj.fnwk_post_blind_load) == 'function' then
        sendDebugMessage('post blind load')
        obj:fnwk_post_blind_load()
    end

    return ret
end