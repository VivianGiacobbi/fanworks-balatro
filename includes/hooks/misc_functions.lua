loc_colour = function(_c, _default)
	G.ARGS.LOC_COLOURS = G.ARGS.LOC_COLOURS or {
	  red = G.C.RED,
	  mult = G.C.MULT,
	  blue = G.C.BLUE,
	  chips = G.C.CHIPS,
	  green = G.C.GREEN,
	  money = G.C.MONEY,
	  gold = G.C.GOLD,
	  attention = G.C.FILTER,
	  purple = G.C.PURPLE,
	  white = G.C.WHITE,
	  inactive = G.C.UI.TEXT_INACTIVE,
	  spades = G.C.SUITS.Spades,
	  hearts = G.C.SUITS.Hearts,
	  clubs = G.C.SUITS.Clubs,
	  diamonds = G.C.SUITS.Diamonds,
	  tarot = G.C.SECONDARY_SET.Tarot,
	  planet = G.C.SECONDARY_SET.Planet,
	  spectral = G.C.SECONDARY_SET.Spectral,
	  edition = G.C.EDITION,
	  dark_edition = G.C.DARK_EDITION,
	  legendary = G.C.RARITY[4],
	  enhanced = G.C.SECONDARY_SET.Enhanced,
	  fanworks = G.C.FANWORKS,
	}
	return G.ARGS.LOC_COLOURS[_c] or _default or G.C.UI.TEXT_DARK
end

local function is_perfect_square(x)
	local sqrt = math.sqrt(x)
	return sqrt^2 == x
end

function get_fibonacci(hand)
	local ret = {}
	if #hand < 5 then return ret end
	local vals = {}
	for i = 1, #hand do
		local value = hand[i].base.nominal
		if hand[i].base.value == 'Ace' then
			value = 1
		elseif SMODS.has_no_rank(hand[i]) then
			value = 0
		end
		sendDebugMessage('card value: '..value)
		
		vals[#vals+1] = value
	end
	table.sort(vals, function(a, b) return a < b end)

	if not vals[1] == 0 and not (is_perfect_square(5 * vals[1]^2 + 4) or is_perfect_square(5 * vals[1]^2 - 4)) then
		return ret
	end

	local sum = 0
	local prev_1 = vals[1]
	local prev_2 = 0
	for i=1, #vals do
		sendDebugMessage(prev_1..' + '..prev_2..' = '.. vals[i])
		sum = prev_1 + prev_2
		
		if vals[i] ~= sum then
			return ret
		end

		prev_2 = prev_1
		prev_1 = vals[i] == 0 and 1 or vals[i]
	end

	sendDebugMessage('sending full hand')
	local t = {}
	for i=1, #hand do
		t[#t+1] = hand[i]
	end

	table.insert(ret, t)
	return ret
end

function psuedoseed_predict(bool)
	G.GAME.pseudorandom.predict_mode = bool or false
	G.GAME.pseudorandom.predicts = {}
	return G.GAME.pseudorandom.predict_mode
end