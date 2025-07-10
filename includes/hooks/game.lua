local ref_game_start = Game.start_run
function Game:start_run(args)
    G.GAME.fnwk_gradient_background = nil
    G.GAME.fnwk_gradient_ui = nil
    local ret = ref_game_start(self, args)

    local obj = G.GAME.blind.config.blind
    if G.GAME.blind.in_blind and obj.fnwk_post_blind_load and type(obj.fnwk_post_blind_load) == 'function' then
        obj:fnwk_post_blind_load()
    end

    return ret
end