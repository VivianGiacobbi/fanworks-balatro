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