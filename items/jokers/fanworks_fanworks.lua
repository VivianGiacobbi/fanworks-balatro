local jokerInfo = {
	key = 'j_fnwk_fanworks_fanworks',
	name = 'Fanworks',
	config = {
        extra = {
            mult_mod = 2,
        }
    },
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	artist = 'gote'
}

local function tally_fanworks_jokers()
	if not G.GAME or not G.GAME.fnwk_owned_jokers then
		return 0
	end

	local tally = 0
	for k, _ in pairs(G.GAME.fnwk_owned_jokers) do
		local center = G.P_CENTERS[k]
		if center and center.original_mod and center.original_mod.id == 'fanworks' and (center.set == 'Joker' or center.set == 'Stand') then 
			tally = tally + 1
		end
	end

	return tally
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult_mod * tally_fanworks_jokers() }}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if not context.blueprint then
		if (context.buying_card and context.card.ability.set == 'Joker') or (context.created_card and context.area == G.jokers) then
			local new_card = context.created_card or context.card
			local mod = new_card.config.center.original_mod
			if mod and mod.id == 'fanworks' then
				return {
					message = localize('k_upgrade_ex'),
					card = card,
				}
			end
		end
	end

	if not context.joker_main then
		return
	end

	local tally = tally_fanworks_jokers()
	if tally > 0 then
		return {
			message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_mod * tally} },
			mult_mod = card.ability.extra.mult_mod * tally,
			card = context.blueprint_card or card
		}
	end
end

return jokerInfo