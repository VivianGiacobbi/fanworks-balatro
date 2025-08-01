local jokerInfo = {
	key = 'j_fnwk_bluebolt_secluded',
	name = 'Secluded Rust Joker',
	config = {
		extra = 1,
	},
	rarity = 2,
	cost = 8,
	unlocked = false,
	unlock_condition = {type = 'hand', facedowns = 5},
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'bluebolt'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.winter }}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = {self.unlock_condition.facedowns}}
end

function jokerInfo.check_for_unlock(self, args)
	if args.type ~= self.unlock_condition.type then return end

	local tally = 0
	for _, card in ipairs(args.full_hand) do
		if card.ability.wheel_flipped then
			tally = tally + 1
		end
	end

	return tally >= self.unlock_condition.facedowns
end

function jokerInfo.calculate(self, card, context)
	if not context.blueprint and not context.retrigger_joker and context.stay_flipped and context.other_card:is_suit('Diamonds') then
        return {
            stay_flipped = true,
        }
    end

	if not (context.repetition and context.cardarea == G.play) or card.debuff then
		return
	end

	local retriggers = 0
	if context.other_card:is_suit('Diamonds') then
		retriggers = card.ability.extra
	end
	
	if retriggers > 0 then
		return {
			message = localize('k_again_ex'),
			repetitions = retriggers,
			card = context.blueprint_card or card
		}
	end
end

return jokerInfo