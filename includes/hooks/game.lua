local ref_game_start = Game.start_run
function Game:start_run(args)
    G.GAME.fnwk_gradient_background = nil
    G.GAME.fnwk_gradient_ui = nil
    local ret = ref_game_start(self, args)

    if (not args or not args.savetext) and G.GAME.modifiers.fnwk_all_bosses then
        G.GAME.round_resets.blind_choices.Small = get_new_boss('Small')
        G.GAME.round_resets.blind_choices.Big = get_new_boss('Big')
    end

    local obj = G.GAME.blind.config.blind
    if G.GAME.blind.in_blind and obj.fnwk_post_blind_load and type(obj.fnwk_post_blind_load) == 'function' then
        obj:fnwk_post_blind_load()
    end

    return ret
end

local ref_game_menu = Game.main_menu
function Game:main_menu(...)
    local ret = ref_game_menu(self, ...)

    if G.NEON_FLASH then G.NEON_FLASH:remove() end
    G.NEON_FLASH = Sprite(0,0, G.ROOM.T.w*2, G.ROOM.T.h*4, G.ASSET_ATLAS['fnwk_screen'], {x = 0, y = 0})
    G.NEON_VALS = { AMT = 0, MAX = 1000 }
    G.NEON_FLASH:define_draw_steps({{
    	shader = 'fnwk_neon_flash',
    	send = {
    		{name = 'flash', ref_table = G.NEON_VALS, ref_value = 'AMT'},
            {name = 'flash_max', ref_table = G.NEON_VALS, ref_value = 'MAX'},
    	}}})
    G.NEON_FLASH:set_alignment({
        major = G.ROOM_ATTACH,
    	type = 'cm',
    	offset = {x=0,y=0}
    })

    return ret
end

local ref_game_delete = Game.delete_run
function Game:delete_run(...)
    local ret = ref_game_delete(self, ...)

    -- for the sake of cleanup, I don't want these hanging in the background
    if G.GAME and G.GAME.fnwk_extra_blinds and next(G.GAME.fnwk_extra_blinds) then
        for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
            v:remove()
        end
        G.GAME.fnwk_extra_blinds = nil
    end

    return ret
end