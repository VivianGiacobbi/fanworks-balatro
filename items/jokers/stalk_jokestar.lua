local jokerInfo = {
	key = 'j_fnwk_stalk_jokestar',
	name = 'Investigative Jokestar',
	config = {
		extra = {
			mult = 20,
			chips = 100
		}
	},
	rarity = 1,
	cost = 4,
	unlocked = false,
    unlock_condition = {type = 'hand', secret_num = 3},
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'stalk',
	in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
	return { vars = {card.ability.extra.mult, card.ability.extra.chips}}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = {self.unlock_condition.secret_num}}
end

function jokerInfo.check_for_unlock(self, args)
	if args.type ~= self.unlock_condition.type then
		return false
	end

	local secret = 0
	for _, key in ipairs(SMODS.PokerHand.obj_buffer) do
		if not SMODS.PokerHands[key].visible and G.GAME.hands[key].played > 0 then
			secret = secret + 1
		end
	end

	return secret >= self.unlock_condition.secret_num
end

return jokerInfo