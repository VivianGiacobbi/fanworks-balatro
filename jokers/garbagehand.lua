local jokerInfo = {
	name = 'Garbage Hand',
	config = {
		extra = {
			mult = 4
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}


function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "guestartist14", set = "Other"}
	return {vars = {card.ability.extra.mult}}
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_garbage" })
	ach_jokercheck(self, ach_checklists.band)
end

function jokerInfo.calculate(self, card, context)
	if context.individual and context.cardarea == G.play and not card.debuff and context.other_card.ability.effect == 'Base' then
		local chip_val = context.other_card:get_id()
		local bonus_chip = context.other_card.ability.perma_bonus or 0
		local total_chip = chip_val + bonus_chip
		if total_chip <= 8 then
			return {
				mult = card.ability.extra.mult,
				card = card
			}
		end
	end
end



return jokerInfo
	