local jokerInfo = {
	name = 'Biased Joker',
	config = {
		extra = {
			money = 2
		}
	},
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'streetlight',
	in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {card.ability.extra.money}}
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.2, 
		func = function()
			for k, v in pairs(G.I.CARD) do
				if v.get_id and v:get_id() == 12 then
					v:add_force_debuff(card)
				end
				if v.config.center then 
					local result = FindWomen(v.config.center.key)
					if result.cis or result.trans then
						v:add_force_debuff(card)
					end
				end
			end
        	return true 
    	end
	}))
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.2, 
		func = function()
			for k, v in pairs(G.I.CARD) do
				v:remove_force_debuff(card)
			end
        	return true 
    	end
	}))
end

return jokerInfo