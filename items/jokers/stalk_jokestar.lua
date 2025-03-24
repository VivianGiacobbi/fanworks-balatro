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
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
	return { vars = {card.ability.extra.mult, card.ability.extra.chips}}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = {self.unlock_condition.secret_num}}
end

function jokerInfo.check_for_unlock(self, args)
	if args.type ~= self.unlock_condition.type then
		return false
	end

	return SecretHandsPlayed() >= self.unlock_condition.secret_num
end

function jokerInfo.in_pool(self, args)
	return SecretHandsPlayed() > 0
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers and not card.debuff then
		if not SMODS.PokerHands[context.scoring_name].visible then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult,
				card = card
			}
		end
	end
end

return jokerInfo