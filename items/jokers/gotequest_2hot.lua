local jokerInfo = {
	key = 'j_fnwk_gotequest_2hot',
	name = '2HOT2HANDLE',
	config = {},
	rarity = 2,
	cost = 7,
	locked = true,
	unlocked = false,
	unlock_condition = {type = 'chip_nova', count = 18},
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'gotequest',
	in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = {CountGrammar(self.unlock_condition.count)}}
end

function jokerInfo.check_for_unlock(self, args)
	if args.type ~= self.unlock_condition.type then return end

	return args.total_novas >= self.unlock_condition.count
end

return jokerInfo