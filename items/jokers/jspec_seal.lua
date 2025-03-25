local jokerInfo = {
	key = 'j_fnwk_jspec_seal',
	name = 'Seal the Seal',
	config = {},
	rarity = 2,
	cost = 5,
	unlocked = false,
	unlock_condition = {type = 'modify_deck'},
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'jspec',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then
        return false
    end
    
	local num_seals = #G.P_CENTER_POOLS['Seal']
	local unique_seals = {}
	local unique_tally = 0
    for _, card in ipairs(G.playing_cards) do
        if card.seal and not unique_seals[card.seal] then 
			unique_seals[card.seal] = true
			unique_tally = unique_tally + 1
		end

        if unique_tally >= num_seals then
			return true
		end
    end

    return false
end

function jokerInfo.calculate(self, card, context)

	if card.debuff or context.blueprint then
		return
	end

	if context.individual and card.seal == "Purple" and not context.card.debuff then
		local seals = card:calculate_seal(context)
		if seals then
			ret.seals = seals
		end
		SMODS.trigger_effects({ret}, context.card)
    end

	if context.individual and card.seal == "Blue" and not context.card.debuff then
		local seals = card:calculate_seal(context)
		if seals then
			ret.seals = seals
		end
		SMODS.trigger_effects({ret}, context.card)
    end

end

return jokerInfo