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
	origin = {
		category = 'fanworks',
		sub_origins = {
			'stalk',
		},
        custom_color = 'stalk',
    },
	artist = 'gote',
}

local function secret_hands_played()
	if not G.GAME then
		return 0
	end

	local secret = 0
	for _, key in ipairs(SMODS.PokerHand.obj_buffer) do
		if not SMODS.PokerHands[key].visible and G.GAME.hands[key].played > 0 then
			secret = secret + 1
		end
	end

	return secret
end

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.mult, card.ability.extra.chips}}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = {self.unlock_condition.secret_num}}
end

function jokerInfo.check_for_unlock(self, args)
	if args.type ~= self.unlock_condition.type then
		return false
	end

	return secret_hands_played() >= self.unlock_condition.secret_num
end

function jokerInfo.in_pool(self, args)
	return secret_hands_played() > 0
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