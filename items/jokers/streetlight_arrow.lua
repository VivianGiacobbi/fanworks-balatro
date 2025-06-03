local jokerInfo = {
	name = 'Arrow Shard',
	config = {},
	rarity = 3,
	cost = 10,
	blueprint_compat = false,
	eternal_compat = false,
	perishable = true,
	fanwork = 'streetlight',
	required_stands = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.leafy }}

	local compat = 'incompatible'
	local has_stand = G.FUNCS.get_leftmost_stand()
    if has_stand and has_stand.ability.evolve_key then
        compat = 'compatible'
    end
	
	
    local main_end = (card.area and card.area == G.jokers) and {
        {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
            {n=G.UIT.C, config={ align = "m", colour = mix_colours(compat == 'compatible' and G.C.GREEN or G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 }, nodes={
                {n=G.UIT.T, config={text = ' '..localize('k_'..compat)..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
            }}
        }}
    } or nil

    return {
        vars = {},
        main_end = main_end
    }
end

function jokerInfo.calculate(self, card, context)
	if context.selling_self then
		local has_stand = G.FUNCS.get_leftmost_stand()
		if not has_stand or not has_stand.ability.evolve_key then
			return
		end

		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('timpani')
				if has_stand.config.center.key == 'c_jojobal_vento_gold' then
					check_for_unlock({ type = "evolve_ger" })
				end
				G.FUNCS.evolve_stand(has_stand)
				return true
			end 
		}))
	end
end

return jokerInfo